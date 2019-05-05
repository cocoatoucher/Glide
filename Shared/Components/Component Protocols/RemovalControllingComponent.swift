//
//  RemovalControllingComponent.swift
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

/// When adopted, a component can decide if its entity can be removed
/// by the scene as a result of a removal event.
/// Entity will be removed if at least one of its `RemovalControllingComponent`s
/// return `true` for its `canEntityBeRemoved` value.
/// An example scenario where this might be useful is, an entity needs
/// to be removed but there is be an explosion animation that should be
/// played.
/// Adoption of this protocol by the component which will play this
/// animation ensures that the entity will not be removed until the
/// animation has done playing.
public protocol RemovalControllingComponent {
    
    /// `true` if the component is ready for removal of its entity.
    var canEntityBeRemoved: Bool { get }
}
