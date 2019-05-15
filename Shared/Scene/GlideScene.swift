//
//  GlideScene.swift
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
import SpriteKit

// swiftlint:disable file_length
// swiftlint:disable:next type_body_length
open class GlideScene: SKScene {
    
    public weak var glideSceneDelegate: GlideSceneDelegate?
    
    /// Tile map node that is populated with collider tiles.
    /// See `ColliderTile` for more information on recognized collider tile definitions.
    public let collisionTileMapNode: SKTileMapNode?
    
    public var tileSize: CGSize {
        return collisionTileMapNode?.tileSize ?? .zero
    }
    
    /// Definitions for container nodes that will be created in the scene.
    /// Order container node with a lower index in this array has a lower `zPosition`
    /// which means it is farther from the camera of a scene.
    public let zPositionContainers: [ZPositionContainer]
    
    /// Entity controlling the camera node of the scene.
    public lazy var cameraEntity: GlideEntity = {
        let cameraNode = SKCameraNode()
        camera = cameraNode
        let entity = EntityFactory.cameraEntity(cameraNode: cameraNode, boundingBoxSize: collisionTileMapNode?.mapSize ?? size)
        entity.name = zPositionContainerNodeName(GlideZPositionContainer.camera)
        entity.transform.node.zPosition = CGFloat.greatestFiniteMagnitude
        entity.transform.usesProposedPosition = false
        entity.transform.node.addChild(cameraNode)
        return entity
    }()
    
    /// Entity with `ConversationFlowControllerComponent` of the scene.
    public lazy var conversationFlowControllerEntity: GlideEntity = {
        let entity = GlideEntity(initialNodePosition: CGPoint.zero)
        let conversationFlowController = ConversationFlowControllerComponent()
        entity.addComponent(conversationFlowController)
        return entity
    }()
    
    /// Returns the conversation currently controlled by this scene's
    /// `conversationFlowControllerEntity`
    public var activeConversation: Conversation? {
        return conversationFlowControllerEntity.component(ofType: ConversationFlowControllerComponent.self)?.conversation
    }
    
    /// Entity with `FocusableEntitiesControllerComponent` of the scene.
    public lazy var focusableEntitiesControllerEntity: GlideEntity = {
        let entity = GlideEntity(initialNodePosition: CGPoint.zero)
        let focusableEntitiesController = FocusableEntitiesControllerComponent()
        entity.addComponent(focusableEntitiesController)
        return entity
    }()
    
    /// `true` if this scene should be paused when the app goes to background.
    public var shouldPauseWhenAppIsInBackground: Bool = true
    
    open override var isPaused: Bool {
        willSet {
            #if os(OSX)
            if isPaused && newValue == false {
                NSApp.keyWindow?.makeFirstResponder(self.view)
            }
            #endif
        }
        didSet {
            Input.shared.flushInputs()
            if isPaused {
                wasPaused = true
            }
            
            DispatchQueue.main.async {
                self.glideSceneDelegate?.glideScene(self, didChangePaused: self.isPaused)
            }
        }
    }
    
    #if DEBUG
    var isDebuggingCollisionTileMapNode: Bool = false {
        didSet {
            updateCollisionTileMapNodeDebug()
        }
    }
    #endif
    
    // MARK: - Initialize
    
    /// Create a scene.
    ///
    /// - Parameters:
    ///     - collisionTileMapNode: Tile map node that is populated with collidable tiles.
    /// See `ColliderTile` for more information on recognized collider tile definitions.
    ///     - zPositionContainers: Definitions for container nodes that will be created in the scene.
    public init(collisionTileMapNode: SKTileMapNode?,
                zPositionContainers: [ZPositionContainer]) {
        
        ComponentPriorityRegistry.shared.initializeIfNeeded()
        self.zPositionContainers = zPositionContainers
        self.collisionTileMapNode = collisionTileMapNode
        
        var tileMapRepresentation: CollisionTileMapRepresentation?
        if let collisionTileMapNode = collisionTileMapNode {
            tileMapRepresentation = CollisionTileMapRepresentation(tileMap: collisionTileMapNode)
        }
        self.collisionsController = CollisionsController(tileMapRepresentation: tileMapRepresentation)
        
        super.init(size: .zero)
        
        constructZPositionContainerNodes()
        registerForNotifications()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Scene Setup
    
    open override func sceneDidLoad() {
        super.sceneDidLoad()
        
        if let collisionTileMapNode = collisionTileMapNode {
            collisionTileMapNode.position = CGPoint(x: collisionTileMapNode.mapSize.width / 2,
                                                    y: collisionTileMapNode.mapSize.height / 2)
        }
        
        scene?.addChild(defaultContainerNode)
        
        #if DEBUG
        scene?.addChild(debugContainerNode)
        debugContainerNode.zPosition = CGFloat.greatestFiniteMagnitude - 1000
        updateCollisionTileMapNodeDebug()
        #endif
        
        addEntity(conversationFlowControllerEntity)
        addEntity(focusableEntitiesControllerEntity)
        
        addChild(cameraEntity.transform.node)
        
        internalEntities = [conversationFlowControllerEntity, focusableEntitiesControllerEntity, cameraEntity]
    }
    
    #if DEBUG
    func updateCollisionTileMapNodeDebug() {
        guard let collisionTileMapNode = collisionTileMapNode else {
            return
        }
        
        if isDebuggingCollisionTileMapNode {
            if collisionTileMapNode.parent == nil {
                zPositionContainerNode(with: GlideZPositionContainer.debug)?.addChild(collisionTileMapNode)
            }
        } else {
            collisionTileMapNode.removeFromParent()
        }
    }
    #endif
    
    open override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        initializeIfNeeded()
    }
    
    open override func didChangeSize(_ oldSize: CGSize) {
        if collisionTileMapNode == nil {
            cameraEntity.component(ofType: CameraComponent.self)?.boundingBoxSize = size
        }
        layoutOnScreenItems()
    }
    
    /// Point for adding your initial entities to the scene. Called before the
    /// update loop starts.
    /// Implementation of `super` does nothing.
    /// Don't call this method directly.
    open func setupScene() { }
    
    /// Called each time scene size changes.
    /// Implementation of `super` does nothing.
    /// Don't call this method directly.
    open func layoutOnScreenItems() { }
    
    // MARK: - Managing entities
    
    /// Add an entity to the scene in default z position container.
    ///
    /// - Parameters:
    ///     - entity: Entity which will start getting callbacks from scene's update loop.
    /// This value's transform node will be added to the scene.
    public func addEntity(_ entity: GlideEntity) {
        let zPositionContainer = entity.zPositionContainer
        addEntity(entity, in: zPositionContainer ?? GlideZPositionContainer.default)
    }
    
    /// Add an entity to the scene in a specific z position container.
    ///
    /// - Parameters:
    ///     - entity: Entity which will start getting events from scene's update loop.
    /// This value's transform node will be added to the scene.
    ///     - zPositionContainer: Desired z position container of scene which will become
    /// the parent of the entity's transform node.
    public func addEntity(_ entity: GlideEntity, in zPositionContainer: ZPositionContainer) {
        guard let zPositionContainerNode = zPositionContainerNode(with: zPositionContainer) else {
            return
        }
        addEntity(entity, in: zPositionContainerNode)
    }
    
    /// Add an entity to the scene in a specific z position container.
    ///
    /// - Parameters:
    ///     - entity: Entity which will start getting callbacks from scene's update loop.
    /// This value's transform node will be added to the scene.
    ///     - zPositionContainer: Desired z position container of scene in which the entity's
    /// transform node will be added.
    public func addChild(_ node: SKNode, in zPositionContainer: ZPositionContainer) {
        let zPositionContainer = zPositionContainerNode(with: zPositionContainer)
        zPositionContainer?.addChild(node)
    }
    
    /// Remove an entity's transform node from the scene and stop if from getting future
    /// update loop events.
    ///
    /// - Parameters:
    ///     - entity: Entity to remove its transform node from scene.
    public func removeEntity(_ entity: GlideEntity) {
        finishEntity(entity, killIfPossible: false, isForcedRemove: true)
    }
    
    // MARK: - Helpers
    
    /// Get entities with given transform node name.
    ///
    /// - Parameters:
    ///     - nodeName: Name of the transform node for the entity.
    public func entitiesWithName(_ nodeName: String) -> [GlideEntity] {
        return entities.filter { $0.transform.node.name == nodeName }
    }
    
    /// Get entities with given tags.
    ///
    /// - Parameters:
    ///     - tags: Tags to use for querying entities.
    public func entitiesWithTags(_ tags: [String]) -> [GlideEntity] {
        return entities.filter {
            if let tag = $0.tag {
                return tags.contains(tag)
            }
            return false
        }
    }
    
    /// Get the first entity with given tag.
    ///
    /// - Parameters:
    ///     - entityTag: Tag to use for querying entities.
    public func entityWithTag(_ entityTag: String) -> GlideEntity? {
        return entities.first {
            $0.tag == entityTag
        }
    }
    
    /// Get all the entities with given tag.
    ///
    /// - Parameters:
    ///     - entityTag: Tag to use for querying entities.
    public func entitiesWithTag(_ entityTag: String) -> [GlideEntity] {
        return entities.filter {
            $0.tag == entityTag
        }
    }
    
    // MARK: - Camera focus
    
    /// Call this function to focus the camera on a specified area in the scene.
    /// Scale of the camera will be automatically arranged to fit the area in the camera.
    ///
    /// - Parameters:
    ///     - frame: Frame in the scene that the camera should focus in the next frame.
    /// Pass `nil` if the camera should no more focus on a frame.
    public func focusCamera(onFrame frame: TiledRect?) {
        if let frame = frame {
            cameraEntity.component(ofType: CameraComponent.self)?.focusFrame = frame.rect(with: tileSize)
        } else {
            cameraEntity.component(ofType: CameraComponent.self)?.focusFrame = nil
        }
    }
    
    /// Call this function to focus the camera on a specified area in the scene.
    /// Scale of the camera will be automatically arranged to fit the area in the camera.
    ///
    /// - Parameters:
    ///     - position: Position in the scene that the camera should focus in the next frame.
    /// Pass `nil` if the camera should no more focus on a frame.
    public func focusCamera(onPosition position: TiledPoint?) {
        if let position = position {
            cameraEntity.component(ofType: CameraComponent.self)?.focusPosition = position.point(with: tileSize)
        } else {
            cameraEntity.component(ofType: CameraComponent.self)?.focusPosition = nil
        }
    }
    
    // MARK: - Speech bubbles
    
    /// Call this function to start the flow of the speeches of a conversation.
    /// After calling this function provided template entities in the `Speech` objects will be
    /// initialized and added to the scene in accordance with the flow.
    ///
    /// - Parameters:
    ///     - conversation: Conversation to start the flow for.
    public func startFlowForConversation(_ conversation: Conversation) {
        conversationFlowControllerEntity.component(ofType: ConversationFlowControllerComponent.self)?.conversation = conversation
    }
    
    // MARK: - End scene
    
    /// Informs `glideSceneDelegate` of this scene to end the scene.
    ///
    /// - Parameters:
    ///     - reason: A predefined reason for ending the scene if any.
    ///     - context: Additional information to be used in context of ending the scene.
    public func endScene(reason: GlideScene.EndReason?, context: [String: Any]? = nil) {
        glideSceneDelegate?.glideSceneDidEnd(self, reason: reason, context: context)
    }
    
    // MARK: - Update cycle
    
    var currentTime: TimeInterval = 0
    
    open override func update(_ currentTime: TimeInterval) {
        self.currentTime = currentTime
        
        Input.shared.update()
        
        if Input.shared.isButtonPressed("Pause") {
            isPaused = !isPaused
            return
        }
        
        if wasPaused {
            lastUpdateTime = currentTime
            wasPaused = false
        }
        
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        
        let deltaTime = currentTime - lastUpdateTime
        
        entitiesSnapshot = entities
        
        updateEntities(currentTime: currentTime, deltaTime: deltaTime)
        
        resolveCollisionsAndNotifyContacts()
        
        updateEntityPositions()
        
        updateCamera(currentTime: currentTime, deltaTime: deltaTime)
        
        updateEntitiesAfterCameraUpdate(deltaTime: deltaTime)
        
        layoutEntitiesIfNeeded()
    }
    
    private func updateEntities(currentTime: TimeInterval, deltaTime: TimeInterval) {
        let entitiesToUpdate = entitiesSnapshot.filter {
            guard $0.shouldBeUpdated else {
                return false
            }
            guard isEntityInSight($0) else {
                return false
            }
            return true
        }.sorted { (left, right) -> Bool in
            if left.component(ofType: SnappableComponent.self) != nil {
                return true
            } else if right.component(ofType: SnappableComponent.self) != nil {
                return false
            }
            return true
        }
        
        let snappables = entitiesToUpdate.filter { $0.component(ofType: SnappableComponent.self) != nil }
        snappables.forEach {
            $0.internal_update(currentTime: currentTime, deltaTime: currentTime - lastUpdateTime)
        }
        let nonSnappables = entitiesToUpdate.filter { $0.component(ofType: SnappableComponent.self) == nil }
        
        nonSnappables.forEach {
            $0.internal_update(currentTime: currentTime, deltaTime: currentTime - lastUpdateTime)
        }
        
        entitiesSnapshot.forEach {
            if entitiesToUpdate.contains($0) == false {
                $0.internal_didSkipUpdate()
            } else {
                $0.internal_resetStates(currentTime: currentTime, deltaTime: deltaTime)
            }
        }
    }
    
    private func resolveCollisionsAndNotifyContacts() {
        let allEntitiesToUpdate = entitiesSnapshot.filter {
            guard $0.shouldBeUpdated else {
                return false
            }
            guard isEntityInSight($0) else {
                return false
            }
            return true
        }
        collisionsController.update(entities: allEntitiesToUpdate)
        notifyContacts()
        collisionsController.resetContacts()
    }
    
    private func notifyContacts() {
        notifyEnteredAndStayedContacts()
        notifyExitedContacts()
    }
    
    private func updateEntityPositions() {
        entitiesSnapshot.forEach {
            guard $0.shouldBeUpdated else {
                return
            }
            guard $0.transform.usesProposedPosition else {
                return
            }
            guard isEntityInSight($0) else {
                return
            }
            $0.transform.updateNodePosition($0.transform.proposedPosition)
        }
    }
    
    private func updateCamera(currentTime: TimeInterval, deltaTime: TimeInterval) {
        let cameraComponent = cameraEntity.component(ofType: CameraComponent.self)
        
        let focusTransformsForCamera = entitiesSnapshot.filter {
            $0.isCameraFocusable
        }.map { $0.transform }
        cameraComponent?.focusTransforms = focusTransformsForCamera
        cameraEntity.internal_update(currentTime: currentTime, deltaTime: deltaTime)
        cameraEntity.internal_resetStates(currentTime: currentTime, deltaTime: deltaTime)
    }
    
    private func updateEntitiesAfterCameraUpdate(deltaTime: TimeInterval) {
        guard let cameraComponent = cameraEntity.component(ofType: CameraComponent.self) else {
            return
        }
        
        entitiesSnapshot.forEach {
            guard $0.shouldBeUpdated else {
                return
            }
            guard isEntityInSight($0) else {
                return
            }
            
            $0.internal_updateAfterCameraUpdate(deltaTime: deltaTime, cameraComponent: cameraComponent)
        }
    }
    
    private func layoutEntitiesIfNeeded() {
        (entitiesSnapshot + [cameraEntity]).forEach {
            guard isEntityInSight($0) else {
                return
            }
            
            $0.internal_layout(scene: self, previousSceneSize: previousSceneSize)
        }
    }
    
    open override func didEvaluateActions() {
        let entitiesToEvaluateActions = entitiesSnapshot.filter {
            guard $0.shouldBeUpdated else {
                return false
            }
            guard isEntityInSight($0) else {
                return false
            }
            return true
        }
        
        entitiesToEvaluateActions.forEach {
            $0.internal_sceneDidEvaluateActions()
        }
    }
    
    open override func didFinishUpdate() {
        let entitiesToFinishUpdate = entitiesSnapshot.filter {
            guard isEntityInSight($0) else {
                return false
            }
            return true
        }
        
        entitiesToFinishUpdate.forEach {
            $0.internal_didFinishUpdate()
        }
        
        finish()
    }
    
    private func finish() {
        let removedEntities = cleanUpEntities()
        
        respawnEntities(removedEntities: removedEntities)
        
        Input.shared.reset()
        
        previousSceneSize = size
        
        lastUpdateTime = currentTime
    }
    
    private func cleanUpEntities() -> [GlideEntity] {
        var removedEntities: [GlideEntity] = []
        entitiesSnapshot.filter { $0.canBeRemoved && entities.contains($0) }.forEach { entityToBeRemoved in
            
            if let removedEntity = finishEntity(entityToBeRemoved,
                                                killIfPossible: false) {
                removedEntities.append(removedEntity)
            }
        }
        
        collisionsController.cleanReferencedComponents()
        
        return removedEntities
    }
    
    private func respawnEntities(removedEntities: [GlideEntity]) {
        
        let respawnResult = respawnRemovedEntities(removedEntities: removedEntities)
        
        let playableEntities = entitiesSnapshot.filter {
            $0.component(ofType: PlayableCharacterComponent.self) != nil
        }
        guard playableEntities.isEmpty == false else {
            endScene(reason: .hasNoMorePlayableEntities)
            return
        }
        
        if respawnResult.isAnyPlayableEntityRespawned {
            respawnEntitiesWithRestartCheckpointIndexGreaterThan(checkpointIndex: respawnResult.indexOfLastCheckpointReached)
        }
    }
    
    // MARK: - Scene boundaries
    
    /// Checks whether the entity is inside camera bounds or within a reasonable distance
    /// from camera bounds.
    private func isEntityInSight(_ entity: GlideEntity) -> Bool {
        guard let transformNodeParent = entity.transform.node.parent else {
            return true
        }
        guard internalEntities.contains(entity) == false else {
            return true
        }
        guard entity.component(ofType: CameraFollowerComponent.self) == nil else {
            return true
        }
        guard let camera = (cameraEntity.component(ofType: CameraComponent.self))?.cameraNode else {
            return true
        }
        guard entity.transform.nestedParentNode != zPositionContainerNode(with: GlideZPositionContainer.camera) else {
            return true
        }
        
        let offset: CGFloat = size.width
        let sightFrame = CGRect(x: -size.width / 2.0 - offset,
                                y: -size.height / 2.0 - offset,
                                width: size.width + (offset * 2.0),
                                height: size.height + (offset * 2.0))
        
        if let collider = entity.component(ofType: ColliderComponent.self) {
            let colliderFrame = collider.colliderFrameInScene
            let convertedOrigin = convert(colliderFrame.origin, to: camera)
            let convertedColliderFrame = CGRect(origin: convertedOrigin, size: colliderFrame.size)
            
            if sightFrame.intersects(convertedColliderFrame) {
                return true
            }
        } else {
            let transformPosition = entity.transform.node.position
            let convertedPosition = transformNodeParent.convert(transformPosition, to: camera)
            let accumulatedFrame = convertedPosition.centeredFrame(withSize: entity.transform.node.calculateAccumulatedFrame().size)
            
            if sightFrame.intersects(accumulatedFrame) {
                return true
            }
        }
        
        return false
    }
    
    // MARK: - Contacts
    
    private func notifyOriginalObjectForEnteredAndStayedContacts(contactContext: ContactContext,
                                                                 state: CollisionsController.ContactState) {
        let contact = contactContext.contactForCollider
        for component in contact.collider.entity?.components ?? [] {
            if let colliderResponder = component as? GlideComponent {
                switch state {
                case .entered:
                    if contactContext.isCollision {
                        colliderResponder.handleNewCollision(contact)
                    } else {
                        colliderResponder.handleNewContact(contact)
                    }
                case .stayed:
                    if contactContext.isCollision {
                        colliderResponder.handleExistingCollision(contact)
                    } else {
                        colliderResponder.handleExistingContact(contact)
                    }
                }
            }
        }
    }
    
    private func notifyOtherObjectForEnteredAndStayedContacts(contactContext: ContactContext,
                                                              state: CollisionsController.ContactState) {
        guard let contactForOther = contactContext.contactForOtherObject else {
            return
        }
        
        for component in contactForOther.collider.entity?.components ?? [] {
            if let colliderResponder = component as? GlideComponent {
                switch state {
                case .entered:
                    if contactContext.isCollision {
                        colliderResponder.handleNewCollision(contactForOther)
                    } else {
                        colliderResponder.handleNewContact(contactForOther)
                    }
                case .stayed:
                    if contactContext.isCollision {
                        colliderResponder.handleExistingCollision(contactForOther)
                    } else {
                        colliderResponder.handleExistingContact(contactForOther)
                    }
                }
            }
        }
    }
    
    private func notifyEnteredAndStayedContacts() {
        for contact in collisionsController.contacts {
            guard let state = collisionsController.stateForContact(contact) else {
                continue
            }
            
            notifyOriginalObjectForEnteredAndStayedContacts(contactContext: contact, state: state)
            notifyOtherObjectForEnteredAndStayedContacts(contactContext: contact, state: state)
        }
    }
    
    private func notifyExitedContacts() {
        for contactContext in collisionsController.exitContacts {
            let contact = contactContext.contactForCollider
            for component in contact.collider.entity?.components ?? [] {
                if let colliderResponder = component as? GlideComponent {
                    if contactContext.isCollision {
                        colliderResponder.handleFinishedCollision(contact)
                    } else {
                        colliderResponder.handleFinishedContact(contact)
                    }
                }
            }
            
            if let contactForOther = contactContext.contactForOtherObject {
                for component in contactForOther.collider.entity?.components ?? [] {
                    if let colliderResponder = component as? GlideComponent {
                        if contactContext.isCollision {
                            colliderResponder.handleFinishedCollision(contactForOther)
                        } else {
                            colliderResponder.handleFinishedContact(contactForOther)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Clean up
    
    @discardableResult
    private func finishEntity(_ entity: GlideEntity,
                              killIfPossible: Bool,
                              isForcedRemove: Bool = true) -> GlideEntity? {
        guard let index = entities.firstIndex(where: { $0 === entity }) else {
            return nil
        }
        
        if killIfPossible, let healthComponent = entity.component(ofType: HealthComponent.self) {
            healthComponent.kill()
        } else if isForcedRemove || entity.canBeRemoved {
            
            entity.internal_prepareForRemoval()
            entity.transform.node.removeFromParent()
            
            for childNode in entity.transform.node.children {
                if let childEntity = childNode.entity as? GlideEntity, childEntity != entity {
                    childEntity.transform.node.removeFromParent()
                    entities.removeAll { $0 === childEntity }
                }
            }
            
            let removedEntity = entity
            entities.remove(at: index)
            return removedEntity
        }
        
        return nil
    }
    
    // MARK: - Private
    
    private var previousSceneSize: CGSize = .zero
    private var didInitialize: Bool = false
    
    private var lastUpdateTime: TimeInterval = 0
    
    private var wasPaused: Bool = false
    
    var entities: [GlideEntity] = []
    var entitiesSnapshot: [GlideEntity] = []
    private var internalEntities: [GlideEntity] = []
    
    private let collisionsController: CollisionsController
    var contactTestMap: [UInt32: UInt32] = [:]
    
    private var checkpointIdsAndRespawnCallbacks: [(String, () -> GlideEntity)] = []
    
    private lazy var defaultContainerNode: SKNode = {
        let node = SKNode()
        node.name = zPositionContainerNodeName(GlideZPositionContainer.default)
        return node
    }()
    
    #if DEBUG
    private lazy var debugContainerNode: SKNode = {
        let node = SKNode()
        node.name = zPositionContainerNodeName(GlideZPositionContainer.debug)
        return node
    }()
    #endif
    
    private var appWillResignActiveObservation: Any?
    private var appDidBecomeActiveObservation: Any?
    
    private func registerForNotifications() {
        appWillResignActiveObservation = NotificationCenter.default.addObserver(forName: Application.willResignActiveNotification,
                                                                                object: nil,
                                                                                queue: nil) { [weak self] _ in
                                                                                    guard self?.shouldPauseWhenAppIsInBackground == true else {
                                                                                        return
                                                                                    }
                                                                                    self?.isPaused = true
        }
        
        // Pausing also in app did become active, because on iOS, scene is automatically set
        // to `isPaused` = `false` when the app becomes active.
        appDidBecomeActiveObservation = NotificationCenter.default.addObserver(forName: Application.didBecomeActiveNotification,
                                                                               object: nil,
                                                                               queue: nil) { [weak self] _ in
                                                                                guard self?.shouldPauseWhenAppIsInBackground == true else {
                                                                                    return
                                                                                }
                                                                                self?.isPaused = true
        }
    }
    
    private func initializeIfNeeded() {
        if didInitialize == false {
            didInitialize = true
            
            setupScene()
            initializeCamera()
        }
    }
    
    private func initializeCamera() {
        cameraEntity.internal_didMoveToScene(self)
        cameraEntity.internal_layout(scene: self, previousSceneSize: size)
        
        let cameraComponent = cameraEntity.component(ofType: CameraComponent.self)
        let playableTransforms = entities.filter {
            $0.component(ofType: PlayableCharacterComponent.self) != nil
            }.map { $0.transform }
        cameraComponent?.setCameraPosition(to: playableTransforms)
    }
    
    private func addEntity(_ entity: GlideEntity, in zPositionContainerNode: SKNode) {
        guard entities.contains(entity) == false else {
            return
        }
        guard entity.component(ofType: CameraComponent.self) == nil else {
            fatalError("Adding entities with `CameraComponent` is currently not supported.")
        }
        
        if entity.component(ofType: PlayableCharacterComponent.self) != nil {
            entities.insert(entity, at: 0)
        } else {
            entities.append(entity)
        }
        
        if let respawnOnRestartComponent = entity.component(ofType: RespawnAtCheckpointOnRestartComponent.self) {
            checkpointIdsAndRespawnCallbacks.append((respawnOnRestartComponent.checkpointId, respawnOnRestartComponent.respawnedEntity))
        }
        
        entity.transform.node.removeFromParent()
        zPositionContainerNode.addChild(entity.transform.node)
        
        entity.internal_didMoveToScene(self)
    }
    
    private func respawnRemovedEntities(removedEntities: [GlideEntity]) -> (isAnyPlayableEntityRespawned: Bool, indexOfLastCheckpointReached: Int) {
        var indexOfLastCheckpointReached: Int = 0
        var isAnyPlayableEntityRespawned = false
        for removedEntity in removedEntities {
            
            let respawnableEntityComponent = removedEntity.components.first { $0 is RespawnableEntityComponent } as? RespawnableEntityComponent
            
            guard let numberOfRespawnsLeft = respawnableEntityComponent?.numberOfRespawnsLeft else {
                continue
            }
            
            guard numberOfRespawnsLeft > 0 else {
                continue
            }
            
            if let respawned = respawnableEntityComponent?.respawnedEntity?(numberOfRespawnsLeft) {
                
                let lastPassedCheckpoint = removedEntity.component(ofType: CheckpointRecognizerComponent.self)?.passedCheckpoints.last
                
                if
                    removedEntity.component(ofType: PlayableCharacterComponent.self) != nil,
                    let lastPassedCheckpoint = lastPassedCheckpoint
                {
                    isAnyPlayableEntityRespawned = true
                    
                    if let checkpointIndex = indexOfCheckpoint(with: lastPassedCheckpoint.id) {
                        indexOfLastCheckpointReached = max(checkpointIndex, indexOfLastCheckpointReached)
                    }
                }
                
                addEntity(respawned)
                respawned.component(ofType: CheckpointRecognizerComponent.self)?.numberOfRespawnsLeft = numberOfRespawnsLeft - 1
            }
        }
        
        return (isAnyPlayableEntityRespawned, indexOfLastCheckpointReached)
    }
    
    private func respawnEntitiesWithRestartCheckpointIndexGreaterThan(checkpointIndex: Int) {
        for entity in entities {
            if let restartComponent = entity.component(ofType: RespawnAtCheckpointOnRestartComponent.self) {
                if let indexOfEntityCheckpoint = indexOfCheckpoint(with: restartComponent.checkpointId) {
                    if indexOfEntityCheckpoint >= checkpointIndex {
                        removeEntity(entity)
                    }
                }
            }
        }
        
        let callbacksCopy = checkpointIdsAndRespawnCallbacks
        checkpointIdsAndRespawnCallbacks = []
        
        for callback in callbacksCopy {
            if let indexOfEntityCheckpoint = indexOfCheckpoint(with: callback.0) {
                if indexOfEntityCheckpoint >= checkpointIndex {
                    let respawnedEntity = callback.1()
                    addEntity(respawnedEntity)
                }
            }
        }
    }
    
    deinit {
        if let observation = appWillResignActiveObservation {
            NotificationCenter.default.removeObserver(observation)
        }
        if let observation = appDidBecomeActiveObservation {
            NotificationCenter.default.removeObserver(observation)
        }
    }
}
