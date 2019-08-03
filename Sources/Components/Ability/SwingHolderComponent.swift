//
//  SwingHolderComponent.swift
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

/// Component that gives an entity the ability to interact with swings.
public final class SwingHolderComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 690
    
    /// `true` if the entity was holding a swing in the last frame.
    public private(set) var wasHolding: Bool = false
    
    /// `true` if the entity is holding a swing in the current frame.
    public internal(set) var isHolding: Bool = false
    
    /// `true` if the entity can currently hold on to swing components.
    /// Purpose of this property is to let the entity jump off and get rid of
    /// contact with the entity of the related `SwingComponent`.
    /// Thus, value of this property gets to `false` between start of jumping
    /// and clearing contact with the swing.
    public internal(set) var canHold: Bool = true
    
    /// Direction of pushing the swing in the last frame.
    public private(set) var previousPushDirection: CircularDirection = .stationary
    
    /// Direction of pushing the swing in the current frame.
    public var pushDirection: CircularDirection = .stationary
    
    // MARK: - Configuration
    
    public struct Configuration {
        public var swingPushFactor: CGFloat = 25.0 // Degrees
    }
    /// Configuration shared by all components of this class.
    public static var sharedConfiguration = Configuration()
    /// Configuration that is used by only this instance of the component.
    /// Default value is `sharedConfiguration`.
    public let configuration: Configuration
    
    // MARK: - Initialize
    
    /// Create a swing holder component.
    ///
    /// - Parameters:
    ///     - configuration: Configuration used by this component.
    /// Default value is `sharedConfiguration`.
    public init(configuration: Configuration = SwingHolderComponent.sharedConfiguration) {
        self.configuration = configuration
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        adjustAngleOfSwingIfNeeded()
    }
    
    public func didUpdate(deltaTime seconds: TimeInterval) {
        updateCanHoldIfNeeded()
    }
    
    // MARK: - Private
    
    /// Transform of the swing that the entity is holding on to.
    var swingTransform: TransformNodeComponent?
    
    private func adjustAngleOfSwingIfNeeded() {
        guard isHolding else {
            return
        }
        
        guard let swingComponent = swingTransform?.entity?.component(ofType: SwingComponent.self) else {
            return
        }
        
        switch pushDirection {
        case .clockwise:
            swingComponent.applyPush(.clockwise(configuration.swingPushFactor))
        case .counterClockwise:
            swingComponent.applyPush(.counterClockwise(configuration.swingPushFactor))
        default:
            break
        }
    }
    
    private func updateCanHoldIfNeeded() {
        guard isHolding && canHold else {
            return
        }
        
        let jumpComponent = entity?.component(ofType: JumpComponent.self)
        
        if jumpComponent?.jumped == false && jumpComponent?.jumps == true {
            canHold = false
        }
    }
}

extension SwingHolderComponent: StateResettingComponent {
    public func resetStates() {
        wasHolding = isHolding
        previousPushDirection = pushDirection
        isHolding = false
        swingTransform = nil
        pushDirection = .stationary
    }
}
