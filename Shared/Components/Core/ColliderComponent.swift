//
//  ColliderComponent.swift
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

/// Component that handles the collisions and controls the collider box of an entity.
public final class ColliderComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 950
    
    /// Value used to check for non-collision contacts with other objects.
    public let categoryMask: CategoryMask
    /// `true` if component is enabled. Entity won't collide with other objects and
    /// won't non-collision contacts if the value of this property is set to `false`.
    /// Default value is `true`.
    public var isEnabled: Bool = true
    
    /// Size of the collider box.
    /// It's not supported to set this after initializing the collider component
    /// if the entity has one of the components below:
    /// - `SnapperComponent`
    /// - `ColliderTileHolderComponent`
    public var size: CGSize {
        didSet {
            if entity?.component(ofType: SnapperComponent.self) != nil {
                fatalError("Can't set collider size on the go for an entity with `SnapperComponent`")
            }
            if entity?.component(ofType: ColliderTileHolderComponent.self) != nil {
                fatalError("Can't set collider size on the go for an entity with `ColliderTileHolderComponent`")
            }
        }
    }
    
    /// Position of the collider box.
    public var offset: CGPoint {
        didSet {
            if entity?.component(ofType: SnapperComponent.self) != nil {
                fatalError("Can't set collider offset on the go for an entity with `SnapperComponent`")
            }
            if entity?.component(ofType: ColliderTileHolderComponent.self) != nil {
                fatalError("Can't set collider offset on the go for an entity with `ColliderTileHolderComponent`")
            }
        }
    }
    
    /// Locations of collider points on the bottom left and top left of the collider box.
    public let leftHitPointsOffsets: (bottom: CGFloat, top: CGFloat)
    /// Locations of collider points on the bottom right and top right of the collider box.
    public let rightHitPointsOffsets: (bottom: CGFloat, top: CGFloat)
    /// Locations of collider points on the top left and top right of the collider box.
    public let topHitPointsOffsets: (left: CGFloat, right: CGFloat)
    /// Locations of collider points on the bottom left and bottom right of the collider box.
    public let bottomHitPointsOffsets: (left: CGFloat, right: CGFloat)
    
    // MARK: - States
    
    /// `true` if the collider's right side was contacting a collidable object in the last frame.
    public private(set) var didPushRightWall: Bool = false
    /// `true` if the collider's right side is contacting a collidable object in the current frame.
    public private(set) var pushesRightWall: Bool = false
    
    /// `true` if the collider's left side was contacting a collidable object in the last frame.
    public private(set) var didPushLeftWall: Bool = false
    /// `true` if the collider's left side is contacting a collidable object in the current frame.
    public private(set) var pushesLeftWall: Bool = false
    
    /// `true` if the collider's bottom was contacting a collidable object in the last frame.
    public internal(set) var wasOnGround: Bool = false
    /// `true` if the collider's top is contacting a collidable object in the current frame.
    public private(set) var onGround: Bool = false
    
    /// `true` if the collider's top was contacting a collidable object in the last frame.
    public private(set) var wasAtCeiling: Bool = false
    /// `true` if the collider's top is contacting a collidable object in the current frame.
    public private(set) var atCeiling: Bool = false
    
    /// `true` if the collider applied a virtual force towards the ground in the last frame.
    public internal(set) var didPushDown: Bool = false
    /// `true` if the collider applies a virtual force towards the ground in the current frame.
    public var pushesDown: Bool = false
    
    /// `true` if the collider was contacting a gap in the collision map of the scene
    /// in the last frame.
    public private(set) var wasOnGap: Bool = false
    /// `true` if the collider is contacting a gap in the collision map of the scene
    /// in the current frame.
    public internal(set) var onGap: Bool = false
    
    /// `true` if the collider was contacting a corner jump area in the collision map of
    /// the scene in the last frame.
    public internal(set) var wasOnCornerJump: Bool = false
    /// `true` if the collider is contacting a corner jump area in the collision map of
    /// the scene in the last frame.
    public internal(set) var onCornerJump: Bool = false
    
    /// `true` if the collider is contacting a slope tile in the collision map of
    /// the scene in the last frame.
    public private(set) var wasOnSlope: Bool = false
    /// `true` if the collider is contacting a slope tile in the collision map of
    /// the scene in the current frame.
    public internal(set) var onSlope: Bool = false
    /// Information about slope tile group that the collider is contacting in the current frame.
    public internal(set) var slopeContext: SlopeContext?
    
    /// `true` if the collider was contacting a right side jump wall tile in the last frame.
    public private(set) var didPushRightJumpWall: Bool = false
    /// `true` if the collider is contacting a right side jump wall tile in the current frame.
    public internal(set) var pushesRightJumpWall: Bool = false
    /// `true` if the collider is contacting a left side jump wall tile in the current frame.
    public private(set) var didPushLeftJumpWall: Bool = false
    /// `true` if the collider is contacting a left side jump wall tile in the current frame.
    public internal(set) var pushesLeftJumpWall: Bool = false
    
    /// `true` if the the bottom of the collider was not touching anywhere in the last frame.
    public private(set) var wasOnAir: Bool = false
    /// `true` if the the bottom of the collider if not touching anywhere in the current frame.
    public var isOnAir: Bool {
        return onGround == false && onSlope == false
    }
    
    /// `true` if the entity was destroyed as a result of unresolved collision in the last frame.
    /// e.g. top and bottom hit points collide at the same time.
    public private(set) var wasKilledByCollision: Bool = false
    /// `true` if the entity is destroyed as a result of unresolved collision in the current frame.
    /// e.g. top and bottom hit points collide at the same time.
    public private(set) var isKilledByCollision: Bool = false
    
    /// `true` if the entity was outside of collision map of the scene in the last frame.
    public private(set) var wasOutsideCollisionMapBounds: Bool = false
    /// `true` if the entity is outside of collision map of the scene in the current frame.
    public internal(set) var isOutsideCollisionMapBounds: Bool = false
    
    /// Create a collider component.
    ///
    /// - Parameters:
    ///     - categoryMask: Mask to establish and check for non-collision contacts
    /// with other entities.
    ///     - size: Size of the collider box.
    ///     - offset: Positon of the collider box.
    ///     - leftHitPointsOffsets: Locations of collider points on the bottom left
    /// and top left of the collider box.
    ///     - rightHitPointsOffsets: Locations of collider points on the bottom left
    /// and top left of the collider box.
    ///     - topHitPointsOffsets: Locations of collider points on the top left and
    /// top right of the collider box.
    ///     - bottomHitPointsOffsets: Locations of collider points on the bottom left
    /// and bottom right of the collider box.
    public init(categoryMask: CategoryMask,
                size: CGSize,
                offset: CGPoint,
                leftHitPointsOffsets: (bottom: CGFloat, top: CGFloat),
                rightHitPointsOffsets: (bottom: CGFloat, top: CGFloat),
                topHitPointsOffsets: (left: CGFloat, right: CGFloat),
                bottomHitPointsOffsets: (left: CGFloat, right: CGFloat)) {
        self.categoryMask = categoryMask
        self.size = size
        self.sizeInEffect = size
        self.offset = offset
        self.leftHitPointsOffsets = leftHitPointsOffsets
        self.rightHitPointsOffsets = rightHitPointsOffsets
        self.topHitPointsOffsets = topHitPointsOffsets
        self.bottomHitPointsOffsets = bottomHitPointsOffsets
        
        super.init()
        
        if sizeInEffect.width > 0 {
            assert(topHitPointsOffsets.left + topHitPointsOffsets.right + 2 <= sizeInEffect.width)
            assert(bottomHitPointsOffsets.left + bottomHitPointsOffsets.right + 2 <= sizeInEffect.width)
        }
        if sizeInEffect.height > 0 {
            assert(leftHitPointsOffsets.bottom + leftHitPointsOffsets.top + 2 <= sizeInEffect.height)
            assert(rightHitPointsOffsets.bottom + rightHitPointsOffsets.top + 2 <= sizeInEffect.height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func didUpdate(deltaTime seconds: TimeInterval) {
        if shouldBeKilledByCollision {
            isKilledByCollision = true
        }
    }
    
    public func finishGroundContact() {
        onSlope = false
    }
    
    // MARK: - Private
    
    private var sizeInEffect: CGSize
    var discardsCornerJump: Bool = false
    
    var shouldBeKilledByCollision: Bool {
        return (atCeiling && onGround) || (pushesLeftWall && pushesRightWall)
    }
    
    func applyContactSides(_ contactSides: [ContactSide]) {
        for contactSide in contactSides {
            switch contactSide {
            case .top:
                atCeiling = true
            case .bottom:
                onGround = true
            case .left:
                pushesLeftWall = true
            case .right:
                pushesRightWall = true
            case .unspecified:
                break
            }
        }
    }
    
    /// Frame of the collider box at current transform position.
    var colliderFrame: CGRect {
        guard let transform = transform else {
            return .zero
        }
        return colliderFrame(at: transform.node.position)
    }
    
    /// Frame of the collider box converted to screen coordinates.
    var colliderFrameInScene: CGRect {
        guard let transform = transform else {
            return colliderFrame
        }
        guard let nodeParent = transform.node.parent else {
            return colliderFrame
        }
        guard let scene = nodeParent.scene else {
            return colliderFrame
        }
        let parentTranslation = (nodeParent.entity as? GlideEntity)?.transform.currentTranslation ?? .zero
        let convertedPosition = scene.convert(transform.node.position + parentTranslation, from: nodeParent)
        
        return colliderFrame(at: convertedPosition)
    }
    
    /// Frames of left side hit points.
    func leftHitPoints(at position: CGPoint) -> (CGRect, CGRect) {
        var bottom = CGRect.zero
        bottom.origin.x = position.x - sizeInEffect.width / 2 + offset.x
        bottom.origin.y = position.y - sizeInEffect.height / 2 + leftHitPointsOffsets.bottom + offset.y
        bottom.size.width = 1
        bottom.size.height = 1
        
        var top = CGRect.zero
        top.origin.x = position.x - sizeInEffect.width / 2 + offset.x
        top.origin.y = position.y + sizeInEffect.height / 2 - leftHitPointsOffsets.top - 1 + offset.y
        top.size.width = 1
        top.size.height = 1
        
        return (bottom, top)
    }
    
    /// Frames of right side hit points.
    func rightHitPoints(at position: CGPoint) -> (CGRect, CGRect) {
        var bottom = CGRect.zero
        bottom.origin.x = position.x + sizeInEffect.width / 2 - 1 + offset.x
        bottom.origin.y = position.y - sizeInEffect.height / 2 + rightHitPointsOffsets.bottom + offset.y
        bottom.size.width = 1
        bottom.size.height = 1
        
        var top = CGRect.zero
        top.origin.x = position.x + sizeInEffect.width / 2 - 1 + offset.x
        top.origin.y = position.y + sizeInEffect.height / 2 - rightHitPointsOffsets.top - 1 + offset.y
        top.size.width = 1
        top.size.height = 1
        
        return (bottom, top)
    }
    
    /// Frames of bottom side hit points.
    func bottomHitPoints(at position: CGPoint) -> (CGRect, CGRect) {
        var left = CGRect.zero
        left.origin.x = position.x - sizeInEffect.width / 2 + bottomHitPointsOffsets.left + offset.x
        left.origin.y = position.y - sizeInEffect.height / 2 + offset.y
        left.size.width = 1
        left.size.height = 1
        
        var right = CGRect.zero
        right.origin.x = position.x + sizeInEffect.width / 2 - bottomHitPointsOffsets.right - 1 + offset.x
        right.origin.y = position.y - sizeInEffect.height / 2 + offset.y
        right.size.width = 1
        right.size.height = 1
        
        return (left, right)
    }
    
    /// Frames of top side hit points.
    func topHitPoints(at position: CGPoint) -> (CGRect, CGRect) {
        var left = CGRect.zero
        left.origin.x = position.x - sizeInEffect.width / 2 + topHitPointsOffsets.left + offset.x
        left.origin.y = position.y + sizeInEffect.height / 2 - 1 + offset.y
        left.size.width = 1
        left.size.height = 1
        
        var right = CGRect.zero
        right.origin.x = position.x + sizeInEffect.width / 2 - topHitPointsOffsets.right - 1 + offset.x
        right.origin.y = position.y + sizeInEffect.height / 2 - 1 + offset.y
        right.size.width = 1
        right.size.height = 1
        
        return (left, right)
    }
    
    /// Get all hit points relative to a given point
    ///
    /// - Parameters:
    ///     - position: Reference position for calculating hit point frames.
    /// For example, collisions controller uses the proposed position of entities as reference position.
    func hitPoints(at position: CGPoint) -> HitPoints {
        return HitPoints(top: topHitPoints(at: position),
                         left: leftHitPoints(at: position),
                         bottom: bottomHitPoints(at: position),
                         right: rightHitPoints(at: position))
    }
    
    /// Frame of collider box at a given reference position
    ///
    /// - Parameters:
    ///     - position: Reference position for calculating collider box frame.
    func colliderFrame(at position: CGPoint) -> CGRect {
        return CGRect(x: position.x - sizeInEffect.width / 2 + offset.x,
                      y: position.y - sizeInEffect.height / 2 + offset.y,
                      width: sizeInEffect.width,
                      height: sizeInEffect.height)
    }
    
    /// `true` if collider's category mask has a defined contact test relation with the given
    /// category mask
    func shouldContactTest(otherCategoryMask: CategoryMask) -> Bool {
        return scene?.canHaveContact(between: categoryMask, and: otherCategoryMask) ?? false
    }
    
    // MARK: - Debuggable
    public static var isDebugEnabled: Bool = false
    public var isDebugEnabled: Bool = false
    
    lazy var colliderFrameDebugNode: SKSpriteNode = {
        let colliderFrameDebugNodeName = debugElementName(with: "frame")
        let debugNode = SKSpriteNode(texture: nil, size: sizeInEffect)
        debugNode.color = Color.orange.withAlphaComponent(0.3)
        debugNode.name = colliderFrameDebugNodeName
        return debugNode
    }()
}

extension ColliderComponent: StateResettingComponent {
    public func resetStates() {
        wasOnGround = onGround
        didPushRightWall = pushesRightWall
        didPushLeftWall = pushesLeftWall
        wasAtCeiling = atCeiling
        wasOnSlope = onSlope
        didPushRightJumpWall = pushesRightJumpWall
        didPushLeftJumpWall = pushesLeftJumpWall
        wasOnCornerJump = onCornerJump
        wasOnAir = isOnAir
        wasOnGap = onGap
        didPushDown = pushesDown
        
        onGround = false
        pushesLeftWall = false
        pushesRightWall = false
        atCeiling = false
        onSlope = false
        pushesRightJumpWall = false
        pushesLeftJumpWall = false
        onCornerJump = false
        discardsCornerJump = false
        onGap = false
        pushesDown = false
        
        wasKilledByCollision = isKilledByCollision
        wasOutsideCollisionMapBounds = isOutsideCollisionMapBounds
        
        sizeInEffect = size
    }
}

extension ColliderComponent: UpdateControllingComponent {
    /// Collider stops updates of entity when there is an unresolved collision
    public var shouldEntityBeUpdated: Bool {
        return isKilledByCollision == false && isOutsideCollisionMapBounds == false
    }
}
