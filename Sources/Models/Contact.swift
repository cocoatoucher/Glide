//
//  Contact.swift
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
import CoreGraphics

/// Values that indicate a contact or collision between two objects.
public struct Contact {
    /// Collider of the entity that got into contact or collision.
    public let collider: ColliderComponent
    /// Other object that got into contact or collision.
    public let otherObject: ContactedObject
    /// Sides that got into contact of the collision box for the entity.
    public let contactSides: [ContactSide]
    /// Intersection frame of collision frames of the entity and other object
    /// in the coordinate space of the entity.
    public let intersection: CGRect
    /// Sides that got into contact of the collision box for the other object.
    /// That value is `nil` if the other object is not an entity.
    public let otherContactSides: [ContactSide]?
    /// Intersection frame of collision frames of the entity and other object
    /// in the coordinate space of the other object.
    /// That value is `nil` if the other object is not an entity.
    public let otherIntersection: CGRect?
}
