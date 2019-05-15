//
//  CollisionsController+DefinedCollisions.swift
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

import CoreGraphics

extension CollisionsController {
    // MARK: - Snappable contact
    
    func snappableContact(for colliderMovement: ColliderMovement,
                          snappables: [SnappableComponent],
                          contacts: [ContactContext],
                          nonCollisionContacts: inout [ContactContext]) -> ContactContext? {
        let collider = colliderMovement.collider
        
        for snappable in snappables {
            guard let snappableCollider = snappable.entity?.component(ofType: ColliderComponent.self) else {
                return nil
            }
            
            let existingContact = contacts.first { $0.collider === collider && $0.otherObject == .collider(snappableCollider) }
            guard existingContact == nil else {
                continue
            }
            if let contact = contact(for: colliderMovement, with: snappable, snappableCollider: snappableCollider) {
                if contact.isCollision {
                    return contact
                } else {
                    nonCollisionContacts.append(contact)
                }
            }
        }
        
        for snappable in snappables {
            handleSnappableCornerJumpContact(for: colliderMovement, snappable: snappable)
        }
        
        return nil
    }
    
    func contact(for colliderMovement: ColliderMovement,
                 with snappable: SnappableComponent,
                 snappableCollider: ColliderComponent) -> ContactContext? {
        let collider = colliderMovement.collider
        let proposedObjectFrame = colliderMovement.proposedObjectFrame
        
        guard let snappableTransform = snappable.entity?.component(ofType: TransformNodeComponent.self) else {
            return nil
        }
        
        let proposedSnappableFrame = snappableCollider.colliderFrame(at: snappableTransform.proposedPosition)
        let intersection = proposedObjectFrame.intersection(proposedSnappableFrame)
        guard intersection.size.height > 0 && intersection.size.width > 0 else {
            return nil
        }
        
        let shouldCollide = collider.entity?.component(ofType: SnapperComponent.self) != nil && snappableCollider.isEnabled
        
        let collisionContact = contactBetweenObjects(colliderMovement: colliderMovement,
                                                     intersection: intersection,
                                                     otherObject: .collider(snappableCollider),
                                                     otherObjectFrame: snappableCollider.colliderFrameInScene,
                                                     proposedOtherObjectFrame: proposedSnappableFrame,
                                                     shouldCollide: shouldCollide)
        let nonCollisionContact = contactBetweenObjects(colliderMovement: colliderMovement,
                                                        intersection: intersection,
                                                        otherObject: .collider(snappableCollider),
                                                        otherObjectFrame: snappableCollider.colliderFrameInScene,
                                                        proposedOtherObjectFrame: proposedSnappableFrame,
                                                        shouldCollide: false)
        
        if let contact = collisionContact, contact.isUnspecified == false {
            if snappable.providesOneWayCollision &&
                contact.colliderContactSides.contains(.bottom) &&
                collider.didPushDown == false {
                return contact
            }
            if snappable.providesOneWayCollision == false {
                return contact
            }
        }
        
        return nonCollisionContact
    }
    
    private func handleSnappableCornerJumpContact(for colliderMovement: ColliderMovement,
                                                  snappable: SnappableComponent) {
        let proposedHitPoints = colliderMovement.proposedHitPoints
        let collider = colliderMovement.collider
        let proposedObjectFrame = colliderMovement.proposedObjectFrame
        
        guard let tileMapRepresentation = tileMapRepresentation else {
            return
        }
        guard collider.onCornerJump == false && collider.discardsCornerJump == false else {
            return
        }
        guard let snappableTransform = snappable.entity?.component(ofType: TransformNodeComponent.self) else {
            return
        }
        guard let snappableCollider = snappable.entity?.component(ofType: ColliderComponent.self) else {
            return
        }
        let shouldCollide = collider.entity?.component(ofType: SnapperComponent.self) != nil && snappableCollider.isEnabled
        guard shouldCollide else {
            return
        }
        
        let proposedSnappableFrame = snappableCollider.colliderFrame(at: snappableTransform.proposedPosition)
        
        let cornerJumpFrameOriginY = proposedSnappableFrame.maxY - tileMapRepresentation.tileSize.height + 1
        
        let leftCornerJumpFrameOrigin = CGPoint(x: proposedSnappableFrame.minX - tileMapRepresentation.tileSize.width,
                                                y: cornerJumpFrameOriginY)
        let proposedLeftCornerJumpFrame = CGRect(origin: leftCornerJumpFrameOrigin,
                                                 size: tileMapRepresentation.tileSize)
        
        let rightCornerJumpFrameOrigin = CGPoint(x: proposedSnappableFrame.maxX,
                                                 y: cornerJumpFrameOriginY)
        let proposedRightCornerJumpFrame = CGRect(origin: rightCornerJumpFrameOrigin,
                                                  size: tileMapRepresentation.tileSize)
        
        var intersection = proposedObjectFrame.intersection(proposedLeftCornerJumpFrame)
        if intersection.isNull {
            intersection = proposedObjectFrame.intersection(proposedRightCornerJumpFrame)
        }
        guard intersection.size.width > 0 && intersection.size.height > 0 else {
            return
        }
        guard
            intersection.intersects(proposedHitPoints.bottom.left) ||
                intersection.intersects(proposedHitPoints.bottom.right)
            else {
                return
        }
        
        if collider.wasOnCornerJump {
            collider.onCornerJump = true
        } else if collider.wasOnGround {
            collider.onCornerJump = true
        } else {
            collider.discardsCornerJump = true
        }
    }
    
    // MARK: - Contacts between objects
    
    func findContactsBetween(entities: [GlideEntity], contacts: inout [ContactContext]) {
        let allColliderEntities = entities.filter {
            $0.component(ofType: ColliderComponent.self) != nil &&
                $0.component(ofType: SnappableComponent.self) == nil
        }
        
        for entity in allColliderEntities {
            guard let collider = entity.component(ofType: ColliderComponent.self), collider.isEnabled else {
                continue
            }
            let otherColliderEntities = entities.filter {
                $0 !== entity && $0.component(ofType: ColliderComponent.self) != nil && $0.component(ofType: ColliderComponent.self)?.isEnabled == true
            }
            
            var currentPosition = entity.transform.node.position
            var convertedProposedPosition = entity.transform.proposedPosition
            if
                let scene = entity.transform.node.scene,
                let entityParent = entity.transform.node.parent
            {
                currentPosition = scene.convert(entity.transform.node.position, from: entityParent)
                convertedProposedPosition = scene.convert(entity.transform.proposedPosition, from: entityParent)
            }
            
            let parentTranslation = entity.transform.parentTransform?.currentTranslation ?? .zero
            let proposedPosition = convertedProposedPosition + parentTranslation
            let proposedColliderFrame = collider.colliderFrame(at: proposedPosition)
            let currentHitPoints = collider.hitPoints(at: currentPosition)
            let proposedHitPoints = collider.hitPoints(at: proposedPosition)
            
            let colliderMovement = ColliderMovement(collider: collider,
                                                    proposedPosition: proposedPosition,
                                                    proposedObjectFrame: proposedColliderFrame,
                                                    proposedHitPoints: proposedHitPoints,
                                                    currentPosition: currentPosition,
                                                    currentHitPoints: currentHitPoints)
            
            if let contact = otherColliderContact(for: colliderMovement,
                                                  with: otherColliderEntities,
                                                  contacts: contacts) {
                contacts.append(contact)
            }
        }
    }
    
    func otherColliderContact(for colliderMovement: ColliderMovement,
                              with otherEntities: [GlideEntity],
                              contacts: [ContactContext]) -> ContactContext? {
        let collider = colliderMovement.collider
        
        for otherEntity in otherEntities {
            guard let otherCollider = otherEntity.component(ofType: ColliderComponent.self) else {
                continue
            }
            let shouldContactTestOtherEntity = collider.shouldContactTest(otherCategoryMask: otherCollider.categoryMask)
            
            guard shouldContactTestOtherEntity else {
                continue
            }
            
            // Already detected contact for this object
            let existingContact = contacts.first {
                ($0.collider === collider && $0.otherObject == .collider(otherCollider)) ||
                    ($0.collider === otherCollider && $0.otherObject == .collider(collider))
            }
            guard existingContact == nil else {
                continue
            }
            
            if let contact = contact(for: colliderMovement, with: otherEntity, otherCollider: otherCollider) {
                return contact
            }
        }
        return nil
    }
    
    // swiftlint:disable:next function_body_length
    func contact(for colliderMovement: ColliderMovement,
                 with otherEntity: GlideEntity,
                 otherCollider: ColliderComponent) -> ContactContext? {
        let otherEntityPosition = otherEntity.transform.node.position
        let otherProposedPosition = otherEntity.transform.proposedPosition
        
        var otherEntityConvertedPosition: CGPoint
        var otherEntityProposedPosition: CGPoint
        if let otherEntityScene = otherEntity.transform.node.scene,
            let otherEntityParent = otherEntity.transform.node.parent {
            otherEntityConvertedPosition = otherEntityScene.convert(otherEntityPosition, from: otherEntityParent)
            otherEntityProposedPosition = otherEntityScene.convert(otherProposedPosition, from: otherEntityParent)
        } else {
            otherEntityConvertedPosition = otherEntityPosition
            otherEntityProposedPosition = otherProposedPosition
        }
        
        otherEntityProposedPosition += otherEntity.transform.parentTransform?.currentTranslation ?? .zero
        let otherEntityColliderFrame = otherCollider.colliderFrame(at: otherEntityConvertedPosition)
        let proposedOtherEntityColliderFrame = otherCollider.colliderFrame(at: otherEntityProposedPosition)
        
        let proposedObjectFrame = colliderMovement.proposedObjectFrame
        let intersection = proposedObjectFrame.intersection(proposedOtherEntityColliderFrame)
        
        guard intersection.size.height > 0 && intersection.size.width > 0 else {
            return nil
        }
        
        guard
            var contact = contactBetweenObjects(colliderMovement: colliderMovement,
                                                intersection: intersection,
                                                otherObject: .collider(otherCollider),
                                                otherObjectFrame: otherEntityColliderFrame,
                                                proposedOtherObjectFrame: proposedOtherEntityColliderFrame,
                                                shouldCollide: false)
            else {
                return nil
        }
        
        let currentPosition = colliderMovement.currentPosition
        let objectFrame = colliderMovement.collider.colliderFrame(at: currentPosition)
        
        let currentOtherEntityHitPoints = otherCollider.hitPoints(at: otherEntityConvertedPosition)
        let proposedOtherEntityHitPoints = otherCollider.hitPoints(at: otherEntityProposedPosition)
        
        let otherColliderMovement = ColliderMovement(collider: otherCollider,
                                                     proposedPosition: otherEntityProposedPosition,
                                                     proposedObjectFrame: proposedOtherEntityColliderFrame,
                                                     proposedHitPoints: proposedOtherEntityHitPoints,
                                                     currentPosition: otherEntityConvertedPosition,
                                                     currentHitPoints: currentOtherEntityHitPoints)
        let otherEntityContactSides = contactSides(for: otherColliderMovement,
                                                   intersection: intersection,
                                                   otherObjectFrame: objectFrame,
                                                   proposedOtherObjectFrame: proposedObjectFrame)
        
        if let parent = otherEntity.transform.node.parent {
            let otherNode = otherEntity.transform.node
            let convertedIntersectionOrigin = otherNode.convert(intersection.origin, from: parent)
            contact.otherObjectIntersection = CGRect(x: convertedIntersectionOrigin.x,
                                                     y: convertedIntersectionOrigin.y,
                                                     width: intersection.width,
                                                     height: intersection.height)
        }
        contact.otherObjectContactSides = otherEntityContactSides.map { $0.contactSide }
        return contact
    }
}
