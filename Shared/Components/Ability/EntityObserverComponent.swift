//
//  EntityObserverComponent.swift
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

/// Component that gives an entity the ability to observe other entities that gets
/// into contact with specified areas in the scene, or around entity's position.
public final class EntityObserverComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 630
    
    /// Tags of the entities for which this entity is observing.
    /// It is required that the observed entities to have `ColliderComponent`.
    public let entityTags: [String]
    
    /// Areas in which this entity is observing other entities.
    public let observingAreas: [ObservingArea]
    
    /// List of entity tags that were observed in the last frame.
    public private(set) var didObserveEntities: [String] = []
    
    /// List of entity tags this entity is observing in the current frame.
    public private(set) var observesEntities: [String] = []
    
    // MARK: - Configuration
    
    public struct Configuration {
        /// `true` if the velocity of this component's entity's kinematics body
        /// velocity should be set to `0` when this component is observing entities.
        public var shouldKinematicsBodyStopWhenObserving: Bool = false
    }
    /// Configuration shared by all components of this class.
    public static var sharedConfiguration = Configuration()
    /// Configuration that is used by only this instance of the component.
    /// Default value is `sharedConfiguration`.
    public let configuration: Configuration
    
    // MARK: - Initialize
    
    /// Create an entity observer component.
    ///
    /// - Parameters:
    ///     - entityTags: Tags of the entities for which this entity is observing.
    ///     - observingAreas: Areas in which this entity is observing other entities.
    ///     - configuration: Configuration used by this component.
    /// Default value is `sharedConfiguration`.
    public init(entityTags: [String],
                observingAreas: [ObservingArea],
                configuration: Configuration = EntityObserverComponent.sharedConfiguration) {
        self.observingAreas = observingAreas
        self.entityTags = entityTags
        self.configuration = configuration
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        observeEntities()
    }
    
    public func didSkipUpdate() {
        #if DEBUG
        cleanDebugElements()
        #endif
    }
    
    // MARK: - Private
    
    private func observeEntities() {
        guard let entitiesToObserve = scene?.entitiesWithTags(entityTags) else {
            return
        }
        guard let transform = transform else {
            return
        }
        guard let scene = scene else {
            return
        }
        
        var observes: [String] = []
        for observedEntity in entitiesToObserve {
            for observingArea in observingAreas {
                let observingRect = observingArea.frameInScene(scene, for: transform)
                
                if let observedColliderEntity = observedEntity.component(ofType: ColliderComponent.self) {
                    if
                        let tag = observedEntity.tag,
                        observedColliderEntity.colliderFrameInScene.intersects(observingRect)
                    {
                        observes.append(tag)
                    }
                } else if let tag = observedEntity.tag, observingRect.contains(observedEntity.transform.node.position) {
                    
                    observes.append(tag)
                }
            }
        }
        observesEntities = observes
        
        if observesEntities.isEmpty == false {
            if let kinematicsBody = entity?.component(ofType: KinematicsBodyComponent.self),
                configuration.shouldKinematicsBodyStopWhenObserving {
                kinematicsBody.velocity = .zero
            }
        }
    }
    
    // MARK: - Debuggable
    public static var isDebugEnabled: Bool = false
    public var isDebugEnabled: Bool = false
    private var debugNodes: [SKSpriteNode] = []
}

extension EntityObserverComponent: StateResettingComponent {
    public func resetStates() {
        didObserveEntities = observesEntities
        
        observesEntities = []
    }
}

extension EntityObserverComponent {
    /// Frame values for an observing area.
    public struct ObservingArea: CustomStringConvertible {
        
        /// Frame of the observing area in tile coordinates.
        public let frame: TiledRect
        
        /// `false` if the observing area coordinates are on scene coordinates.
        /// `true` if it is moving together with the owning entity's transform. When this
        /// value is `true`, `frame`'s origin is used as an offset value for the
        /// position of the area in respect to position of the entity's transformn.
        /// For example, if origin of `frame` is `(x: 0, y: 0)`, `frame` will be centered
        /// on the transfom's position.
        public let isLocal: Bool
        
        // MARK: - Initialize
        
        /// Create an observing area
        ///
        /// - Parameters:
        ///     - area: Frame of the observing area in tile coordinates.
        ///     - isLocal: `false` if the observing area coordinates are on scene coordinates.
        /// `true` if it is moving together with the owning entity's transform. When this
        /// value is `true`, `frame`'s origin is used as an offset value for the
        /// position of the area in respect to position of the entity's transformn.
        /// For example, if origin of `frame` is `(x: 0, y: 0)`, `frame` will be centered
        /// on the transfom's position.
        public init(frame: TiledRect, isLocal: Bool) {
            self.frame = frame
            self.isLocal = isLocal
        }
        
        public var description: String {
            return "observingArea: \(frame.description), isLocal: \(isLocal)"
        }
        
        public func frameInScene(_ scene: GlideScene, for transform: TransformNodeComponent) -> CGRect {
            var observingRect = frame.rect(with: scene.tileSize)
            if isLocal {
                observingRect.origin = transform.node.convert(observingRect.origin, to: scene)
                observingRect.origin -= (observingRect.size / 2)
            }
            return observingRect
        }
    }
}

#if DEBUG
extension EntityObserverComponent: DebuggableComponent {
    public func updateDebugElements() {
        guard let scene = scene else {
            return
        }
        guard let transform = transform else {
            return
        }
        
        guard debugNodes.isEmpty else {
            
            for (index, area) in observingAreas.enumerated() where area.isLocal == false {
                let debugNode = debugNodes[index]
                let observingRect = area.frameInScene(scene, for: transform)
                debugNode.position = observingRect.origin + observingRect.size / 2
            }
            
            return
        }
        
        for observingArea in observingAreas {
            let observingRect = observingArea.frameInScene(scene, for: transform)
            
            let debugSprite = SKSpriteNode(color: Color.cyan.withAlphaComponent(0.3), size: observingRect.size)
            let nodeName = debugElementName(with: observingArea.description)
            debugSprite.name = nodeName
            if observingArea.isLocal == false {
                debugSprite.position = observingRect.origin + observingRect.size / 2
                scene.addChild(debugSprite, in: GlideZPositionContainer.debug)
            } else {
                debugSprite.position = observingArea.frame.origin.point(with: scene.tileSize)
                transform.node.addChild(debugSprite)
            }
            debugNodes.append(debugSprite)
        }
    }
    
    public func cleanDebugElements() {
        debugNodes.forEach { $0.removeFromParent() }
    }
}
#endif
