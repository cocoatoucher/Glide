//
//  BlinkerComponent.swift
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

/// Component that gives an entity's rendered nodes the ability to visually blink.
/// This is a common behavior that might come handy to indicate damage to an
/// entity after it gets a hit.
/// An entity's `HealthComponent`, if there is any, automatically triggers blinking
/// for this component when an entity takes damage.
public final class BlinkerComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 710
    
    /// `true` if the entity blinked in the last frame.
    public private(set) var didBlink: Bool = false
    
    /// Set to `true` to make the entity's rendered nodes blink.
    public var blinks: Bool = false {
        didSet {
            blinkingTimeElapsed = 0
        }
    }
    
    /// Value of how many seconds the entity should blink.
    public let blinkingDuration: TimeInterval
    
    // MARK: - Initialize
    
    /// Create a blinker component.
    ///
    /// - Parameters:
    ///     - blinkingDuration: Value of how many seconds the entity should blink.
    public init(blinkingDuration: TimeInterval) {
        self.blinkingDuration = blinkingDuration
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        handleBlinking(deltaTime: seconds)
    }
    
    // MARK: - Private
    
    private var blinkingTimeElapsed: TimeInterval = 0
    private let blinkingAnimationKey = "blinking"
    
    private func handleBlinking(deltaTime seconds: TimeInterval) {
        if didBlink == false, blinks {
            startBlinking()
            blinkingTimeElapsed = 0
        } else if blinks {
            blinkingTimeElapsed += seconds
            if blinkingTimeElapsed >= blinkingDuration {
                blinks = false
                stopBlinking()
            }
        } else {
            stopBlinking()
        }
    }
    
    private func startBlinking() {
        let fadeAction = [SKAction.fadeAlpha(to: 0.2, duration: 0.1), SKAction.fadeAlpha(to: 1.0, duration: 0.1)]
        let blinkingAction = SKAction.repeatForever(SKAction.sequence(fadeAction))
        transform?.node.run(blinkingAction, withKey: blinkingAnimationKey)
    }
    
    private func stopBlinking() {
        let node = transform?.node
        node?.removeAction(forKey: blinkingAnimationKey)
        transform?.node.alpha = 1.0
    }
}

extension BlinkerComponent: DamageControllingComponent {
    var canEntityTakeDamage: Bool {
        return blinks == false
    }
}

extension BlinkerComponent: StateResettingComponent {
    public func resetStates() {
        didBlink = blinks
    }
}
