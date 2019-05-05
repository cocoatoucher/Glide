//
//  SelfSpawnEntitiesComponent.swift
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

/// Component that makes an entity spawn other provided entities either periodically with a
/// specified time interval, or when the entity observes specified entities.
/// Latter requires the entity to have `EntityObserverComponent`.
public final class SelfSpawnEntitiesComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 560
    
    /// `true` if there was spawning in the last frame.
    public private(set) var didSpawn: Bool = false

    /// `true` if there is spawning in the current frame.
    public private(set) var spawns: Bool = false
    
    /// Type of spawning.
    public let spawnMethod: SpawnMethod
    
    /// Callback for creating spawned entities at a given position.
    public let spawnEntityHandler: (_ position: CGPoint) -> GlideEntity?
    
    // MARK: - Configuration
    
    public struct Configuration {
        /// No entities will be spawned if the time elapsed since the last spawn is less
        /// than this value.
        public var minimumRestTimeBetweenSpawns: TimeInterval = 0.2 // seconds
    }
    /// Configuration shared by all components of this class.
    public static var sharedConfiguration = Configuration()
    /// Configuration that is used by only this instance of the component.
    /// Default value is `sharedConfiguration`.
    public let configuration: Configuration
    
    // MARK: - Initialize
    
    /// Create a self spawn entities component.
    ///
    /// - Parameters:
    ///     - spawnMethod: Type of spawning.
    ///     - configuration: Configuration used by this component.
    /// Default value is `sharedConfiguration`.
    ///     - spawnEntityHandler: Callback for creating spawned entities at a given position.
    public init(spawnMethod: SpawnMethod,
                configuration: Configuration = SelfSpawnEntitiesComponent.sharedConfiguration,
                spawnEntityHandler: @escaping (_ position: CGPoint) -> GlideEntity?) {
        self.spawnMethod = spawnMethod
        self.configuration = configuration
        self.spawnEntityHandler = spawnEntityHandler
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func update(deltaTime seconds: TimeInterval) {
        switch spawnMethod {
        case .onTimeInterval(let interval):
            guard let currentTime = currentTime else {
                break
            }
            if currentTime - lastSpawnTimeForTimeIntervalSpawn >= interval {
                spawnEntityIfNeeded()
                lastSpawnTimeForTimeIntervalSpawn = currentTime
            }
        case .onEntityObserve(let entityTags):
            guard let entityObserver = entity?.component(ofType: EntityObserverComponent.self) else {
                break
            }
            let observesAnyEntity = entityTags.first{ entityObserver.didObserveEntities.contains($0) } != nil
            if observesAnyEntity {
                spawnEntityIfNeeded()
            }
        }
    }
    
    // MARK: - Private
    private var lastSpawnTime: TimeInterval = 0
    private var lastSpawnTimeForTimeIntervalSpawn: TimeInterval = 0
    
    private func spawnEntityIfNeeded() {
        guard let transform = transform else { return }
        guard let currentTime = currentTime else {
            return
        }
        
        guard currentTime - lastSpawnTime >= configuration.minimumRestTimeBetweenSpawns else {
            return
        }
        
        lastSpawnTime = currentTime
        spawns = true
        if let entity = spawnEntityHandler(transform.currentPosition) {
            scene?.addEntity(entity)
        }
    }
}

extension SelfSpawnEntitiesComponent {
    /// Conditions for spawning entities
    public enum SpawnMethod {
        /// Entities will be spawned periodically with given interval in seconds.
        case onTimeInterval(interval: TimeInterval)
        /// Entities will be observed when `EntityObserverComponent` observes entities
        /// with provided tags.
        /// `EntityObserverComponent` is required for this condition to work.
        case onEntityObserve(entityTags: [String])
    }
}

extension SelfSpawnEntitiesComponent: StateResettingComponent {
    public func resetStates() {
        didSpawn = spawns
        spawns = false
    }
}
