//
//  GlideEntity.swift
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

/// Basic entity which coordinates added `GlideComponent`s to itself.
/// Although it's technically possible to add `GKComponent`s that do not
/// conform to `GlideComponent`, it is recommended to add components
/// which conform to this protocol to get full advantage from this entity
/// and its components.
/// Initialize this class and add your custom components in your entity
/// initializer method or subclass to have more flexibility with your
/// custom entity class.
/// Since, entities are basically a collection of components with most of the use cases,
/// consider implementing a factory class with static functions which creates direct instances
/// of `GlideEntity` and adds custom components to this instance, instead of creating
/// separate `GlideEntity` subclasses for each of your entities.
///
/// One thing to note is, it is not supported to use `GKEntity`'s
/// `removeComponent(ofType:)` method, as this is not an open function
/// and it is not possible to clean up component related properties
/// from the entity through overriding this method.
/// Therefore, Use `removeGlideComponent(ofType:)` method of this class instead.
open class GlideEntity: GKEntity {
    
    /// Same as the name of the node of this entity's `TransformNodeComponent`.
    public override var name: String? {
        set {
            transform.node.name = newValue
        }
        get {
            return transform.node.name
        }
    }
    
    /// Tag for this entity. Can be used to filter entities in the scene.
    public var tag: String?
    
    /// This entity's scene's current time in seconds.
    /// Returns `0` if the entity doesn't have a scene.
    public var currentTime: TimeInterval {
        return scene?.currentTime ?? 0
    }
    
    /// Transform node component for this entity.
    /// Returns same value as calling `component(ofType: TransformNodeComponent.self)`
    /// on the entity.
    public let transform: TransformNodeComponent
    
    /// Scene to which this entity belongs.
    public var scene: GlideScene? {
        return transform.node.scene as? GlideScene
    }
    
    /// Represents the first found `zPositionContainer` amound this entity's
    /// `ZPositionContainerIndicatorComponent`s `zPositionContainer`s.
    public var zPositionContainer: ZPositionContainer? {
        return sortedComponents.compactMap {
            ($0 as? ZPositionContainerIndicatorComponent)?.zPositionContainer
        }.first
    }
    
    /// `true` if any of this entity's components conforms to `CameraFocusingComponent` protocol.
    public var isCameraFocusable: Bool {
        return components.first { $0 is CameraFocusingComponent } != nil
    }
    
    /// Accumulated `focusOffset` from this entity's `CameraFocusingComponent`s.
    public var cameraFocusOffset: CGPoint? {
        return components.reduce(CGPoint.zero, { (result, component) -> CGPoint in
            if let cameraFocusingComponent = component as? CameraFocusingComponent {
                return result + cameraFocusingComponent.focusOffset
            }
            return result
        })
    }
    
    /// MARK: - Update control
    
    /// `true` if the entity's update methods should be called.
    public var shouldBeUpdated: Bool {
        guard willBeRemoved == false else {
            return false
        }
        return components.reduce(true) { result, component in
            if let managing = component as? UpdateControllingComponent {
                return result && managing.shouldEntityBeUpdated
            }
            return result && true
        }
    }
    
    /// `true` if the entity can take damage.
    public var canTakeDamage: Bool {
        return components.reduce(true) { result, component in
            if let managing = component as? DamageControllingComponent {
                return result && managing.canEntityTakeDamage
            }
            return result && true
        }
    }
    
    /// `true` if the entity's transform can be removed from the scene.
    public var canBeRemoved: Bool {
        return components.reduce(false) { result, component in
            if let managing = component as? RemovalControllingComponent {
                return result || managing.canEntityBeRemoved
            }
            return result || false
        }
    }
    
    /// `true` if the entity's components should process user input.
    public var shouldBlockInputs: Bool {
        return components.reduce(false) { result, component in
            if let managing = component as? InputControllingComponent {
                return result || managing.shouldBlockInputs
            }
            return result || false
        }
    }
    
    // MARK: - Initialize
    
    /// Create an entity.
    ///
    /// - Parameters:
    ///     - initialNodePosition: Position for the transform node of this entity.
    public convenience init(initialNodePosition: CGPoint) {
        self.init(initialNodePosition: initialNodePosition, positionOffset: .zero)
    }
    
    /// Create an entity.
    ///
    /// - Parameters:
    ///     - initialNodePosition: Position for the transform node of this entity.
    ///     - positionOffset: Offset for transform node position from the given
    /// `initialNodePosition`.
    public init(initialNodePosition: CGPoint, positionOffset: CGPoint) {
        self.transform = TransformNodeComponent(initialNodePosition: initialNodePosition, positionOffset: positionOffset)
        super.init()
        
        addTransformNodeComponent(transform)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func addComponent(_ component: GKComponent) {
        if self.component(ofType: type(of: component)) != nil {
            fatalError("Can't add same type of component twice.")
        }
        super.addComponent(component)
        if scene != nil {
            (component as? GlideComponent)?.start()
        }
    }
    
    /// Use this method to remove components from your entity.
    /// Since `removeComponent(ofType:)` method of `GKEntity` is not implemented with an open.
    /// modifier, this method is implemented as a replacement.
    public func removeGlideComponent<ComponentType>(ofType componentClass: ComponentType.Type) where ComponentType: (GlideComponent & GKComponent) {
        
        if let glideComponent = component as? GlideComponent {
            glideComponent.willBeRemovedFromEntity()
        }
        
        super.removeComponent(ofType: componentClass)
    }
    
    // MARK: - Setup
    
    /// Can be used as a place for initialization of components.
    /// Implementation of `super` does nothing.
    /// Don't call this method directly.
    open func setup() { }
    
    /// Called right after transform node of entity is added to a scene.
    /// Implementation of `super` does nothing.
    /// Don't call this method directly.
    ///
    /// - Parameters:
    ///     - scene: Scene that the entity's transform node has as a parent.
    open func didMoveToScene(_ scene: GlideScene) { }
    
    /// Called right before updating components of the entity.
    /// Implementation of `super` does nothing.
    /// Don't call this method directly.
    ///
    /// - Parameters:
    ///     - currentTime: Current time in the frame.
    ///     - seconds: Seconds passed since the last frame.
    open func willUpdateComponents(currentTime: TimeInterval, deltaTime: TimeInterval) { }
    
    open override func update(deltaTime seconds: TimeInterval) {
        // Overriden by intention to prevent super to call update on components.
    }
    
    /// Called right before calling `didUpdate(deltaTime:)` of each component.
    /// Implementation of `super` does nothing.
    /// Don't call this method directly.
    ///
    /// - Parameters:
    ///     - currentTime: Current time in the frame.
    ///     - seconds: Seconds passed since the last frame.
    open func didUpdateComponents(currentTime: TimeInterval, deltaTime: TimeInterval) { }
    
    /// Called after `didUpdateComponents(currentTime:deltaTime:)` of `GlideEntity`.
    /// Implementation of `super` does nothing.
    /// Don't call this method directly.
    ///
    /// - Parameters:
    ///     - currentTime: Current time in the frame.
    ///     - seconds: Seconds passed since the last frame.
    open func resetStates(currentTime: TimeInterval, deltaTime: TimeInterval) { }
    
    /// Called after scene of the entity updates its camera entity.
    /// Implementation of `super` does nothing.
    /// Don't call this method directly.
    ///
    /// - Parameters:
    ///     - seconds: Seconds passed since the last frame.
    ///     - cameraComponent: Camera component of the scene's camera entity.
    open func updateAfterCameraUpdate(deltaTime seconds: TimeInterval, cameraComponent: CameraComponent) { }
    
    /// Called in each frame to inform entities about size changes of the scene.
    /// Implementation of `super` does nothing.
    /// Don't call this method directly.
    ///
    /// - Parameters:
    ///     - scene: Scene of the entity.
    ///     - previousSceneSize: Size of the scene before in the last frame.
    open func layout(scene: GlideScene, previousSceneSize: CGSize) { }
    
    /// Called for an entity in each frame as long as its `shouldBeUpdated` is `true`.
    /// Implementation of `super` does nothing.
    /// Don't call this method directly.
    open func didSkipUpdate() { }
    
    /// Implementation of `super` does nothing.
    /// Don't call this method directly.
    open func sceneDidEvaluateActions() { }
    
    /// Implementation of `super` does nothing.
    /// Don't call this method directly.
    open func didFinishUpdate() { }
    
    /// Called for an entity right before its transform node is removed from the scene.
    /// After that call, the entity gets out of update loop until added back to the
    /// scene.
    /// Implementation of `super` does nothing.
    /// Don't call this method directly.
    open func prepareForRemoval() { }
    
    // MARK: - Internal
    
    private(set) var willBeRemoved: Bool = false
    
    var sortedComponents: [GKComponent] {
        return components.sorted { (left, right) -> Bool in
            let leftPriority = ComponentPriorityRegistry.shared.priority(for: type(of: left))
            let rightPriority = ComponentPriorityRegistry.shared.priority(for: type(of: right))
            return leftPriority < rightPriority
        }
    }
    
    func internal_didMoveToScene(_ scene: GlideScene) {
        willBeRemoved = false
        
        sortedComponents.forEach {
            if let glideComponent = $0 as? (GKComponent & GlideComponent) {
                glideComponent.start()
            }
        }
        
        didMoveToScene(scene)
    }
    
    func internal_update(currentTime: TimeInterval, deltaTime: TimeInterval) {
        willUpdateComponents(currentTime: currentTime, deltaTime: deltaTime)
        sortedComponents.forEach {
            if let glideComponent = $0 as? (GKComponent & GlideComponent) {
                glideComponent.willUpdate(deltaTime: deltaTime)
            }
        }
        
        update(deltaTime: deltaTime)
        updateComponents(currentTime: currentTime, deltaTime: deltaTime)
        #if DEBUG
        sortedComponents.forEach {
            if let debuggable = $0 as? DebuggableComponent {
                if debuggable.shouldUpdateDebugElements {
                    debuggable.updateDebugElements()
                } else {
                    debuggable.cleanDebugElements()
                }
            }
        }
        #endif
        
        didUpdateComponents(currentTime: currentTime, deltaTime: deltaTime)
        sortedComponents.forEach {
            if let glideComponent = $0 as? (GKComponent & GlideComponent) {
                glideComponent.didUpdate(deltaTime: deltaTime)
            }
        }
    }
    
    func internal_resetStates(currentTime: TimeInterval, deltaTime: TimeInterval) {
        sortedComponents.forEach {
            if let cleanable = $0 as? StateResettingComponent {
                cleanable.resetStates()
            }
        }
        
        resetStates(currentTime: currentTime, deltaTime: deltaTime)
    }
    
    func internal_updateAfterCameraUpdate(deltaTime seconds: TimeInterval, cameraComponent: CameraComponent) {
        sortedComponents.forEach {
            if let glideComponent = $0 as? (GKComponent & GlideComponent) {
                glideComponent.updateAfterCameraUpdate(deltaTime: seconds, cameraComponent: cameraComponent)
            }
        }
        
        updateAfterCameraUpdate(deltaTime: seconds, cameraComponent: cameraComponent)
    }
    
    func internal_layout(scene: GlideScene, previousSceneSize: CGSize) {
        sortedComponents.forEach {
            if let layoutable = $0 as? NodeLayoutableComponent {
                layoutable.layout(scene: scene, previousSceneSize: previousSceneSize)
            }
        }
        
        layout(scene: scene, previousSceneSize: previousSceneSize)
    }
    
    func internal_didSkipUpdate() {
        sortedComponents.forEach {
            if let glideComponent = $0 as? (GKComponent & GlideComponent) {
                glideComponent.didSkipUpdate()
            }
        }
        
        didSkipUpdate()
    }
    
    func internal_sceneDidEvaluateActions() {
        sortedComponents.forEach {
            if let cleanable = $0 as? ActionsEvaluatorComponent {
                cleanable.sceneDidEvaluateActions()
            }
        }
        
        sceneDidEvaluateActions()
    }
    
    func internal_didFinishUpdate() {
        sortedComponents.forEach {
            ($0 as? GlideComponent)?.didFinishUpdate()
        }
        
        didFinishUpdate()
    }
    
    func internal_prepareForRemoval() {
        willBeRemoved = true
        sortedComponents.forEach {
            if let glideComponent = $0 as? (GKComponent & GlideComponent) {
                glideComponent.entityWillBeRemovedFromScene()
            }
        }
        
        prepareForRemoval()
    }
    
    // MARK: - Private
    
    private func addTransformNodeComponent(_ transform: TransformNodeComponent) {
        addComponent(transform)
    }
    
    private func updateComponents(currentTime: TimeInterval, deltaTime: TimeInterval) {
        sortedComponents.forEach { $0.update(deltaTime: deltaTime) }
    }
}
