//
//  TransformNodeComponent.swift
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

/// Enumeration that's used to indicate the horizontal direction in 2d space
extension TransformNodeComponent {
    public enum HeadingDirection {
        case left
        case right
        
        public static prefix func ! (lhs: HeadingDirection) -> HeadingDirection {
            switch lhs {
            case .left:
                return .right
            case .right:
                return .left
            }
        }
    }
}

/// Component that defines the position and direction properties of an entity
/// via rendering a container node on the scene for its entity's other nodes.
public final class TransformNodeComponent: GKSKNodeComponent, GlideComponent {
    
    public static let componentPriority: Int = 1000
    
    /// Value that indicates the node position that the transform was initialized with.
    public let initialPosition: CGPoint
    
    /// Position of the node in the last frame.
    public private(set) var previousPosition: CGPoint = .zero
    
    /// Position of the node in the current frame.
    public var currentPosition: CGPoint {
        get {
            return node.position
        }
        set {
            guard usesProposedPosition == false || scene == nil else {
                fatalError("Can't set position directly for the transform which set 'usesProposedPosition' to true")
            }
            updateNodePosition(newValue)
        }
    }
    
    /// Value that is used to propose a position for the transform's node.
    /// In each update cycle this value is evaluated and maybe modified by
    /// collisions controller to determine the final position of the node.
    public var proposedPosition: CGPoint = .zero {
        willSet {
            guard usesProposedPosition == true || transformNode.canSetPosition == true else {
                fatalError("Can't set proposed position for the transform which set 'usesProposedPosition' to false")
            }
        }
    }
    
    /// List of proposed positions that the entity should pass through its
    /// final proposed position.
    public internal(set) var intermediaryProposedPositions: [CGPoint]?
    
    /// Value that determines whether the transform should change position
    /// using its proposed position.
    /// Set this to `false` if you want to manually adjust the position of the transform.
    /// Default value is `true`.
    public var usesProposedPosition: Bool = true
    
    /// Vector value of the diff between current and proposed position values.
    public var currentTranslation: CGVector {
        return CGVector(dx: proposedPosition.x - currentPosition.x, dy: proposedPosition.y - currentPosition.y)
    }
    
    /// Transform node component for the parent entity.
    /// This removes the node from current parent when set to a new value including `nil`.
    public var parentTransform: TransformNodeComponent? {
        didSet {
            node.removeFromParent()
            parentTransform?.node.addChild(node)
        }
    }
    
    public private(set) var previousHeadingDirection: HeadingDirection = .right
    
    /// The direction the transform is heading to.
    /// Can be used by other components to determine the rendered scale.
    public var headingDirection: HeadingDirection = .right {
        didSet {
            previousHeadingDirection = oldValue
        }
    }
    
    // MARK: - Initializer
    
    /// Create a transform node component at the given position.
    ///
    /// - Parameters:
    ///     - initialNodePosition: The position where the node should be placed at start.
    ///     - positionOffset: Offset for the node this transform's position from the given
    /// `initialNodePosition`.
    public init(initialNodePosition: CGPoint,
                positionOffset: CGPoint = .zero) {
        self.initialPosition = initialNodePosition + positionOffset
        self.transformNode = TransformNode()
        super.init(node: transformNode)
        updateNodePosition(self.initialPosition)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Reverses the current heading direction to its opposite value.
    public func changeDirection() {
        headingDirection = !headingDirection
    }
    
    /// Whether an action with the `displacementActionKey` is running on the transform.
    public var isRunningDisplacementAction: Bool {
        return node.action(forKey: displacementActionKey) != nil
    }
    
    /// Starts running an action with `displacementActionKey`.
    /// Within the time frame that action is running, updating node position to
    /// proposed position is postponed until `sceneDidEvaluateActions()` is called.
    /// The reason is to not interfere with the action.
    public func runDisplacementAction(_ action: SKAction) {
        guard isRunningDisplacementAction == false else {
            return
        }
        node.run(action, withKey: displacementActionKey)
    }
    
    // MARK: - Private
    
    /// Actual node that this component owns.
    private var transformNode: TransformNode
    
    private let displacementActionKey = "glide.transform.action.displacement"
    
    var nestedParentNode: SKNode? {
        var currentTransform = self
        var currentParent = parentTransform
        while let parent = currentParent {
            currentTransform = parent
            currentParent = parent.parentTransform
        }
        return currentTransform.node.parent
    }
    
    /// Updates the node position to the given position.
    func updateNodePosition(_ position: CGPoint) {
        previousPosition = node.position
        if isRunningDisplacementAction {
            return
        }
        transformNode.canSetPosition = true
        node.position = CGPoint(x: position.x.glideRound, y: position.y.glideRound)
        proposedPosition = node.position
        transformNode.canSetPosition = false
    }
    
    // MARK: - Debuggable
    
    public static var isDebugEnabled: Bool = false
    
    public var isDebugEnabled: Bool = false
    
    private lazy var debugNode: SKSpriteNode = {
        let debugNodeName = debugElementName(with: "\(node.name ?? "")")
        let debugSprite = SKSpriteNode(color: .red, size: CGSize(width: 4, height: 4))
        debugSprite.name = debugNodeName
        return debugSprite
    }()
}

extension TransformNodeComponent: ActionsEvaluatorComponent {
    func sceneDidEvaluateActions() {
        if isRunningDisplacementAction {
            proposedPosition = node.position
        }
    }
}

extension TransformNodeComponent {
    
    /// Transform node components of entities that has this transform as parent.
    public var children: [TransformNodeComponent] {
        return node.children.compactMap {
            if
                let glideEntity = $0.entity as? GlideEntity,
                glideEntity.transform.parentTransform == self
            {
                return glideEntity.transform
            }
            return nil
        }
    }
    
    /// Returns the first found component of given type within child transforms.
    ///
    /// - Parameters:
    ///     - componentClass: Type of the component.
    public func componentInChildren<ComponentType>(ofType componentClass: ComponentType.Type)
        -> ComponentType? where ComponentType: GKComponent {
            for childTransform in children {
                if let component = childTransform.entity?.component(ofType: ComponentType.self) {
                    return component
                }
            }
            return nil
    }
    
    /// Returns the first child with the given name.
    ///
    /// - Parameters:
    ///     - name: Name of the desired child's transform node.
    public func child(with name: String) -> TransformNodeComponent? {
        for childTransform in children where name == childTransform.node.name {
            return childTransform
        }
        return nil
    }
}

extension TransformNodeComponent: DebuggableComponent {
    public func updateDebugElements() {
        if debugNode.parent == nil {
            node.addChild(debugNode)
        }
    }
    
    public func cleanDebugElements() {
        debugNode.removeFromParent()
    }
}

extension TransformNodeComponent {
    
    /// Node type that is used internally for transform node components.
    /// This type of node prevents setting the node position directly.
    fileprivate class TransformNode: SKNode {
        
        /// `true` if it is allowed to set a position for this node.
        var canSetPosition: Bool = false
        
        override var position: CGPoint {
            didSet {
                guard canSetPosition else {
                    fatalError("Use 'currentPosition' instead of setting position directly on node")
                }
            }
        }
    }
}
