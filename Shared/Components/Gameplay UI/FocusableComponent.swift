//
//  FocusableComponent.swift
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

/// Component that makes an entity controllable by the focusables controller
/// of a scene.
/// See `FocusableEntitiesControllerComponent`.
public final class FocusableComponent: GKComponent, GlideComponent {
    
    /// `true` if the entity of this component should become focused among
    /// its sibling focusables.
    public private(set) var isFirstFocusable: Bool = false
    
    /// Entity with `FocusableComponent` on the left side of this component's entity
    /// in screen coordinates.
    public var leftwardFocusable: FocusableComponent?
    
    /// Entity with `FocusableComponent` on the right side of this component's entity
    /// in screen coordinates.
    public var rightwardFocusable: FocusableComponent?
    
    /// Entity with `FocusableComponent` on the top of this component's entity
    /// in screen coordinates.
    public var upwardFocusable: FocusableComponent?
    
    /// Entity with `FocusableComponent` on the bottom of this component's entity
    /// in screen coordinates.
    public var downwardFocusable: FocusableComponent?
    
    /// `true` if the entity was focused in the last frame.
    public private(set) var wasFocused: Bool = false
    
    /// `true` if the entity is focused in the current frame.
    public internal(set) var isFocused: Bool = false
    
    /// `true` if the entity was sent a select event in the last frame.
    public private(set) var wasSelected: Bool = false
    
    /// `true` if the entity is sent a select event in the current frame.
    public internal(set) var isSelected: Bool = false
    
    /// `true` if the entity was sent a cancel event in the last frame.
    public private(set) var wasCancelled: Bool = false
    
    /// `true` if the entity is sent a cancel event in the current frame.
    public internal(set) var isCancelled: Bool = false
    
    /// Name of the input profile to use as the selection event for this focusable.
    public let selectionInputProfile: String
    
    // MARK: - Initialize
    
    /// Create a focusable component.
    ///
    /// - Parameters:
    ///     - selectionInputProfile: Name of the input profile to use as the selection event
    /// for this focusable.
    public init(selectionInputProfile: String) {
        self.selectionInputProfile = selectionInputProfile
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FocusableComponent: StateResettingComponent {
    public func resetStates() {
        wasFocused = isFocused
        wasSelected = isSelected
        wasCancelled = isCancelled
        
        isSelected = false
        isCancelled = false
    }
}
