//
//  CollisionsController.swift
//  glide
//
//  Copyright (c) 2019 cocoatoucher user on github.com (https://github.com/cocoatoucher/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import GameplayKit

extension CollisionsController {
    enum ContactState {
        case entered
        case stayed
    }
}

class CollisionsController {
    let tileMapRepresentation: CollisionTileMapRepresentation?
    private(set) var previousContacts: [ContactContext] = []
    private(set) var contacts: [ContactContext] = []
    var exitContacts: [ContactContext] {
        return previousContacts.filter { contacts.contains($0) == false }
    }
    
    init(tileMapRepresentation: CollisionTileMapRepresentation?) {
        self.tileMapRepresentation = tileMapRepresentation
    }
    
    func stateForContact(_ contact: ContactContext) -> ContactState? {
        if previousContacts.contains(contact) && contacts.contains(contact) {
            return .stayed
        } else if contacts.contains(contact) {
            return .entered
        }
        return nil
    }
    
    func resetContacts() {
        previousContacts = contacts
        contacts = []
    }
    
    func cleanReferencedComponents() {
        previousContacts = previousContacts.filter { $0.collider.transform?.node.parent != nil }
        previousContacts = previousContacts.filter { $0.otherObject.colliderComponent == nil ||
            $0.otherObject.colliderComponent?.transform?.node.parent != nil }
    }
    
    // MARK: - Update
    func update(entities: [GlideEntity]) {
        var contacts: [ContactContext] = []
        findContactsAndResolveCollisionsWithEnvironment(entities, contacts: &contacts)
        findContactsBetween(entities: entities, contacts: &contacts)
        self.contacts = contacts
    }
    
    func findContactsAndResolveCollisionsWithEnvironment(_ entities: [GlideEntity], contacts: inout [ContactContext]) {
        let nonChildColliderEntities = entities.filter {
            $0.component(ofType: ColliderComponent.self) != nil &&
            $0.component(ofType: SnappableComponent.self) == nil &&
            $0.transform.parentTransform == nil
        }
        
        let allSnappables = entities.compactMap { $0.component(ofType: SnappableComponent.self) }
        var snappables: [SnappableComponent] = []
        for snappable in allSnappables {
            guard let collider = snappable.entity?.component(ofType: ColliderComponent.self) else {
                continue
            }
            if isColliderWithinCollisionMapBoundaries(collider: collider) == false {
                collider.isOutsideCollisionMapBounds = true
                continue
            }
            snappables.append(snappable)
        }
        
        for entity in nonChildColliderEntities {
            
            guard let collider = entity.component(ofType: ColliderComponent.self) else {
                continue
            }
            if isColliderWithinCollisionMapBoundaries(collider: collider) == false {
                collider.isOutsideCollisionMapBounds = true
                continue
            }
            
            var currentContacts: [ContactContext] = []
            
            let toPosition = entity.transform.proposedPosition
            
            let finalProposedPosition = resolvedProposedPosition(for: entity,
                                                                 to: toPosition,
                                                                 shouldLerp: true,
                                                                 snappables: snappables,
                                                                 contacts: &currentContacts)
            
            entity.transform.proposedPosition = finalProposedPosition
            currentContacts.forEach { contacts.append($0) }
        }
    }
    
    func resolvedProposedPosition(for entity: GlideEntity,
                                  to proposedPosition: CGPoint,
                                  shouldLerp: Bool,
                                  snappables: [SnappableComponent],
                                  contacts: inout [ContactContext]) -> CGPoint {
        guard let collider = entity.component(ofType: ColliderComponent.self) else {
            return proposedPosition
        }
        
        var proposedPositions: [CGPoint] = []
        if shouldLerp {
            proposedPositions = interpolatedPositions(from: entity.transform.node.position,
                                                      to: proposedPosition,
                                                      intermediaryPositions: entity.transform.intermediaryProposedPositions,
                                                      maximumDelta: interpolationMaximumDelta)
            entity.transform.intermediaryProposedPositions = nil
        } else {
            proposedPositions = [proposedPosition]
        }
        
        for currentProposedPosition in proposedPositions {
            var nonCollisionContacts: [ContactContext] = []
            
            let currentContact = self.contact(of: entity,
                                              collider: collider,
                                              at: currentProposedPosition,
                                              snappables: snappables,
                                              contacts: contacts,
                                              nonCollisionContacts: &nonCollisionContacts)
            
            guard collider.shouldBeKilledByCollision == false else {
                continue
            }
            
            guard let contact = currentContact else {
                contacts.append(contentsOf: nonCollisionContacts)
                // Recursive algorithm ends here, when the current proposed position
                // is clear of contacts and there is no new proposed positions in
                // the current loop.
                continue
            }
            
            collider.applyContactSides(contact.colliderContactSides)
            contacts.append(contact)
            contacts.append(contentsOf: nonCollisionContacts)
            
            // Keep checking for the modified proposed position
            // until we are clear of contacts
            return resolvedProposedPosition(for: entity,
                                            to: contact.proposedPosition,
                                            shouldLerp: false,
                                            snappables: snappables,
                                            contacts: &contacts)
        }
        
        return proposedPosition
    }
    
    // MARK: - Contact finding
    
    func contact(of entity: GlideEntity,
                 collider: ColliderComponent,
                 at proposedPosition: CGPoint,
                 snappables: [SnappableComponent],
                 contacts: [ContactContext],
                 nonCollisionContacts: inout [ContactContext]) -> ContactContext? {
        let currentPosition = entity.transform.node.position
        
        let proposedColliderFrame = collider.colliderFrame(at: proposedPosition)
        let currentHitPoints = collider.hitPoints(at: currentPosition)
        let proposedHitPoints = collider.hitPoints(at: proposedPosition)
        
        let colliderMovement = ColliderMovement(collider: collider,
                                                proposedPosition: proposedPosition,
                                                proposedObjectFrame: proposedColliderFrame,
                                                proposedHitPoints: proposedHitPoints,
                                                currentPosition: currentPosition,
                                                currentHitPoints: currentHitPoints)
        
        ////////////////////////////////////
        // Ground
        if let tileMapRepresentation = tileMapRepresentation {
            if let contact = groundContact(for: colliderMovement,
                                           tileMapRepresentation: tileMapRepresentation,
                                           contacts: contacts,
                                           nonCollisionContacts: &nonCollisionContacts) {
                return contact
            }
        }
        
        ////////////////////////////////////
        // Snappables
        if let contact = snappableContact(for: colliderMovement,
                                          snappables: snappables,
                                          contacts: contacts,
                                          nonCollisionContacts: &nonCollisionContacts) {
            return contact
        }
        
        return nil
    }
    
    func contactBetweenObjects(colliderMovement: ColliderMovement,
                               intersection: CGRect,
                               otherObject: ContactedObject,
                               otherObjectFrame: CGRect,
                               proposedOtherObjectFrame: CGRect,
                               shouldCollide: Bool) -> ContactContext? {
        let proposedPosition = colliderMovement.proposedPosition
        
        let contactSidesAndOffsets = self.contactSides(for: colliderMovement,
                                                       intersection: intersection,
                                                       otherObjectFrame: otherObjectFrame,
                                                       proposedOtherObjectFrame: proposedOtherObjectFrame)
        
        var modifiedProposedPosition: CGPoint
        var contactSides: [ContactSide]
        if shouldCollide {
            let contactSidesAndProposedPosition = self.contactSidesAndProposedPosition(from: contactSidesAndOffsets, initialProposedPosition: proposedPosition)
            modifiedProposedPosition = contactSidesAndProposedPosition.0
            contactSides = contactSidesAndProposedPosition.1
        } else {
            modifiedProposedPosition = proposedPosition
            contactSides = contactSidesAndOffsets.map { $0.contactSide }
        }
        
        guard shouldCollide == false || (shouldCollide && contactSides.isEmpty == false) else {
            return nil
        }
        
        let entityNode = colliderMovement.collider.transform?.node
        let entityParent = entityNode?.parent
        var colliderIntersectionOrigin: CGPoint
        if let entityNode = entityNode, let entityParent = entityParent {
            colliderIntersectionOrigin = entityNode.convert(intersection.origin, from: entityParent)
        } else {
            colliderIntersectionOrigin = intersection.origin
        }
        let colliderIntersection = CGRect(x: colliderIntersectionOrigin.x,
                                          y: colliderIntersectionOrigin.y,
                                          width: intersection.width,
                                          height: intersection.height)
        
        return ContactContext(collider: colliderMovement.collider,
                              otherObject: otherObject,
                              isCollision: shouldCollide,
                              colliderContactSides: contactSides,
                              colliderIntersection: colliderIntersection,
                              otherObjectContactSides: [],
                              otherObjectIntersection: .zero,
                              proposedPosition: modifiedProposedPosition)
    }
    
    func contactSidesAndProposedPosition(from contactSidesAndOffsets: [ContactContext.ContactSideAndOffset],
                                         initialProposedPosition: CGPoint) -> (CGPoint, [ContactSide]) {
        var contactSides: [ContactSide] = []
        var modifiedProposedPosition = initialProposedPosition
        for contactSideAndOffset in contactSidesAndOffsets {
            let contactSide = contactSideAndOffset.contactSide
            let offset = contactSideAndOffset.offset
            switch contactSide {
            case .top, .bottom:
                modifiedProposedPosition.y += offset
            case .left, .right:
                modifiedProposedPosition.x += offset
            case .unspecified:
                break
            }
            contactSides.append(contactSide)
        }
        return (modifiedProposedPosition, contactSides)
    }
    
    // MARK: - Lerping
    
    private let interpolationMaximumDelta: CGFloat = 8.0
    
    func interpolatedPositions(from currentPosition: CGPoint,
                               to proposedPosition: CGPoint,
                               intermediaryPositions: [CGPoint]?,
                               maximumDelta: CGFloat) -> [CGPoint] {
        var result: [CGPoint] = []
        
        if let intermediaryPositions = intermediaryPositions {
            var lastPosition = currentPosition // entity.transform.node.position
            for intermediaryPosition in intermediaryPositions {
                let interpolated = lastPosition.interpolatedPoints(to: intermediaryPosition, maximumDelta: maximumDelta)
                result.append(contentsOf: interpolated)
                lastPosition = intermediaryPosition
            }
            let interpolated = lastPosition.interpolatedPoints(to: proposedPosition, maximumDelta: maximumDelta)
            result.append(contentsOf: interpolated)
        } else {
            result = currentPosition.interpolatedPoints(to: proposedPosition, maximumDelta: maximumDelta)
        }
        return result
    }
    
    private func isColliderWithinCollisionMapBoundaries(collider: ColliderComponent) -> Bool {
        guard let tileMapRepresentation = tileMapRepresentation else {
            return true
        }
        
        let colliderFrame = collider.colliderFrameInScene
        let isOutsideCollisionMapBounds = colliderFrame.maxX < 0 ||
            colliderFrame.minX > tileMapRepresentation.mapSize.width ||
            colliderFrame.maxY < 0 || colliderFrame.minY > tileMapRepresentation.mapSize.height
        
        if isOutsideCollisionMapBounds {
            return false
        }
        return true
    }
}
