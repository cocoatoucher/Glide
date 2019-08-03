//
//  SwingComponent.swift
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

/// Component that provides snapping behaviors of a swing.
public final class SwingComponent: GKComponent, GlideComponent {
    
    /// Length of the chain node of the swing which starts from the entity's
    /// transform and extends upwards with the given length.
    public let chainLengthInTiles: Int
    
    /// Child entity for the chain of the swing, which can be assigned with custom textures.
    public lazy var chainEntity: GlideEntity = {
        let entity = GlideEntity(initialNodePosition: CGPoint.zero)
        
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: .zero)
        spriteNodeComponent.spriteNode.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        spriteNodeComponent.spriteNode.color = Color.red
        entity.addComponent(spriteNodeComponent)
        
        return entity
    }()
    
    // MARK: - Configuration
    
    public struct Configuration {
        /// Gravity that affects the movement of the swing.
        public var gravity: CGFloat = 8 // m/s²
        /// Maximum angle that the swing can open up while swinging.
        public var maximumAmplitude: CGFloat = 75 // degrees
        /// Degrees to decrease the amplitude of the swing while it
        /// is slowing down.
        public var slowDownAmplitudeChange: CGFloat = 30 // degrees
        /// Convenience for being able to use metric system values in the configuration.
        public var metersToScreenPoints: CGFloat = 27.0 // 1m = 27points
    }
    /// Configuration shared by all components of this class.
    public static var sharedConfiguration = Configuration()
    /// Configuration that is used by only this instance of the component.
    /// Default value is `sharedConfiguration`.
    public let configuration: Configuration
    
    // MARK: - Initialize
    
    /// Create a swing component.
    ///
    /// - Parameters:
    ///     - chainLengthInTiles: Length of the chain node of the swing which
    /// starts from the entity's transform and extends upwards with the given length.
    ///     - configuration: Configuration used by this component.
    /// Default value is `sharedConfiguration`.
    public init(chainLengthInTiles: Int,
                configuration: Configuration = SwingComponent.sharedConfiguration) {
        self.chainLengthInTiles = chainLengthInTiles
        self.configuration = configuration
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func applyPush(_ push: SwingPush) {
        appliedPush = push
    }
    
    public func start() {
        guard let scene = scene else {
            return
        }
        guard let transform = transform else {
            return
        }
        
        let chainNodeSize = TiledSize(width: 1, height: chainLengthInTiles).size(with: scene.tileSize)
        chainEntity.component(ofType: SpriteNodeComponent.self)?.spriteNode.size = chainNodeSize
        scene.addEntity(chainEntity)
        chainEntity.transform.parentTransform = transform
    }
    
    public func willBeRemovedFromEntity() {
        scene?.removeEntity(chainEntity)
    }
    
    public func didUpdate(deltaTime seconds: TimeInterval) {
        calculateAmplitude()
        calculateCurrentAngle()
        
        if previousAppliedPush == .none {
            if lastDirection == .clockwise {
                applyPush(.counterClockwise(configuration.slowDownAmplitudeChange))
            } else if lastDirection == .counterClockwise {
                applyPush(.clockwise(configuration.slowDownAmplitudeChange))
            }
        }
    }
    
    public func handleNewContact(_ contact: Contact) {
        handleSnapping(with: contact)
    }
    
    public func handleExistingContact(_ contact: Contact) {
        handleSnapping(with: contact)
    }
    
    public func handleFinishedContact(_ contact: Contact) {
        let otherEntity = contact.otherObject.colliderComponent?.entity
        guard let swingHolderComponent = otherEntity?.component(ofType: SwingHolderComponent.self) else {
            return
        }
        swingHolderComponent.canHold = true
    }
    
    // MARK: - Private
    
    private var swingStartTime: TimeInterval = 0.0
    
    private var previousAppliedPush: SwingPush = .none
    private var appliedPush: SwingPush = .none // radians
    
    private var previousAmplitude: CGFloat = 0.0
    private var amplitude: CGFloat = 0 // radians
    
    private var previousAngle: CGFloat = -90 * 180 / CGFloat.pi
    private var angle: CGFloat = -90 * 180 / CGFloat.pi // radians
    
    private var lastDirection: CircularDirection = .stationary
    
    private func calculateAmplitude() {
        if previousAppliedPush != .none {
            if lastDirection == .clockwise {
                switch previousAppliedPush {
                case .clockwise:
                    amplitude += previousAppliedPush.changeInRadians
                case .counterClockwise:
                    amplitude -= previousAppliedPush.changeInRadians
                default:
                    break
                }
            } else if lastDirection == .counterClockwise {
                switch previousAppliedPush {
                case .counterClockwise:
                    amplitude += previousAppliedPush.changeInRadians
                case .clockwise:
                    amplitude -= previousAppliedPush.changeInRadians
                default:
                    break
                }
            } else {
                // Initial bump when there was no movement before
                amplitude += abs(previousAppliedPush.changeInRadians)
            }
        }
        
        amplitude = max(0, min(amplitude, configuration.maximumAmplitude))
    }
    
    private func calculateCurrentAngle() {
        guard let transform = transform else {
            return
        }
        guard let currentTime = currentTime else {
            return
        }
        guard let scene = scene else {
            return
        }
        
        var movingClockwise = false
        if case .clockwise = previousAppliedPush {
            movingClockwise = true
        }
        
        let radius: CGFloat = CGFloat(chainLengthInTiles) * scene.tileSize.height
        
        let gravity: CGFloat = abs(configuration.gravity) * configuration.metersToScreenPoints
        
        let period = (CGFloat.pi * 2) * sqrt(radius / gravity)
        
        if previousAmplitude == 0 && amplitude != 0 {
            swingStartTime = currentTime
            if movingClockwise {
                swingStartTime = currentTime - TimeInterval(period / 2)
            }
        }
        
        let timeSinceThrown = currentTime - swingStartTime
        
        let amplitudeInRadians = amplitude * CGFloat.pi / 180
        
        var newAngle = amplitudeInRadians * (sin(sqrt(gravity / radius) * CGFloat(timeSinceThrown)))
        newAngle -= CGFloat.pi / 2
        
        if angle > newAngle {
            lastDirection = .clockwise
        } else if newAngle > angle {
            lastDirection = .counterClockwise
        } else {
            lastDirection = .stationary
        }
        
        angle = newAngle
        
        transform.proposedPosition.x = transform.initialPosition.x + radius * cos(newAngle)
        transform.proposedPosition.y = transform.initialPosition.y + radius * sin(newAngle)
        
        chainEntity.component(ofType: SpriteNodeComponent.self)?.spriteNode.zRotation = newAngle - (CGFloat.pi / 2)
    }
    
    private func handleSnapping(with contact: Contact) {
        let otherEntity = contact.otherObject.colliderComponent?.entity
        guard
            let swingHolderComponent = otherEntity?.component(ofType: SwingHolderComponent.self),
            let snapper = otherEntity?.component(ofType: SnapperComponent.self)
            else {
                return
        }
        
        guard swingHolderComponent.canHold else {
            return
        }
        
        swingHolderComponent.isHolding = true
        swingHolderComponent.swingTransform = transform
        
        snapper.isSnapping = true
        snapper.snappedPositionCallback = { [weak self] transform in
            guard let self = self else { return nil }
            guard let selfTransform = self.transform else { return nil }
            return CGPoint(x: selfTransform.proposedPosition.x, y: selfTransform.proposedPosition.y)
        }
    }
}

extension SwingComponent: StateResettingComponent {
    public func resetStates() {
        previousAngle = angle
        previousAmplitude = amplitude
        previousAppliedPush = appliedPush
        appliedPush = .none
    }
}

extension SwingComponent {
    public enum SwingPush: Equatable {
        case none
        case clockwise(CGFloat)
        case counterClockwise(CGFloat)
        
        var changeInRadians: CGFloat {
            switch self {
            case .none:
                return 0
            case .clockwise(let value), .counterClockwise(let value):
                return abs(value) * CGFloat.pi / 180
            }
        }
    }
}
