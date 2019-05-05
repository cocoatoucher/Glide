//
//  ContactContext.swift
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

import Foundation

/// Values that indicate detailed information about a contact.
struct ContactContext: Equatable {
    let collider: ColliderComponent
    let otherObject: ContactedObject
    var isCollision: Bool
    let colliderContactSides: [ContactSide]
    let colliderIntersection: CGRect
    var otherObjectContactSides: [ContactSide]
    var otherObjectIntersection: CGRect
    var proposedPosition: CGPoint
    
    func controllerAVerticalContactSide() -> ContactSide? {
        return colliderContactSides.filter { $0 == .bottom || $0 == .top }.first
    }
    
    var isUnspecified: Bool {
        return colliderContactSides.contains(.unspecified)
    }
    
    var contactForCollider: Contact {
        return Contact(collider: collider,
                       otherObject: otherObject,
                       contactSides: colliderContactSides,
                       intersection: colliderIntersection,
                       otherContactSides: otherObjectContactSides,
                       otherIntersection: otherObjectIntersection)
    }
    
    var contactForOtherObject: Contact? {
        guard let otherCollider = otherObject.colliderComponent else {
            return nil
        }
        return Contact(collider: otherCollider,
                       otherObject: .collider(collider),
                       contactSides: otherObjectContactSides,
                       intersection: otherObjectIntersection,
                       otherContactSides: colliderContactSides,
                       otherIntersection: colliderIntersection)
    }
    
    static func == (lhs: ContactContext, rhs: ContactContext) -> Bool {
        return
            lhs.collider === rhs.collider &&
                lhs.otherObject == rhs.otherObject &&
                lhs.isCollision == rhs.isCollision
    }
}

extension ContactContext {
    struct ContactSideAndOffset: Equatable {
        let contactSide: ContactSide
        let offset: CGFloat
        
        static func == (lhs: ContactSideAndOffset, rhs: ContactSideAndOffset) -> Bool {
            return lhs.contactSide == rhs.contactSide && lhs.offset == rhs.offset
        }
    }
}
