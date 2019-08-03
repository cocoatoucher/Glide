//
//  InfiniteSpriteScrollerComponent.swift
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

/// Component that repeats its entity's sprite node on a given axis and automatically
/// scrolls through those repeated nodes with a given speed if desired. End result
/// looks like sprite node of the entity is scrolling in an infinite fashion. This
/// is useful for animating background layers of game levels to create some parallax
/// effects.
///
/// Required components: `SpriteNodeComponent`.
public final class InfiniteSpriteScrollerComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 390
    
    public enum ScrollAxis {
        case horizontal
        case vertical
    }
    
    /// Supported axis for infinite scrolling.
    public let scrollAxis: ScrollAxis
    
    /// Speed for automatic scrolling.
    public let autoScrollSpeed: CGFloat
    
    // MARK: - Initialize
    
    /// Create an infinite scroller component.
    ///
    /// - Parameters:
    ///     - scrollAxis: Supported axis for infinite scrolling.
    ///     - autoScrollSpeed: Speed for automatic scrolling.
    public init(scrollAxis: ScrollAxis, autoScrollSpeed: CGFloat = 0.0) {
        self.scrollAxis = scrollAxis
        self.autoScrollSpeed = autoScrollSpeed
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func start() {
        guard let scene = scene else {
            return
        }
        populateNodes(scene: scene)
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        scrollSprite(deltaTime: seconds)
    }
    
    // MARK: - Private
    
    private var centerNode: SKSpriteNode?
    private var leftOrTopNode: SKSpriteNode?
    private var rightOrBottomNode: SKSpriteNode?
    
    private func populateNodes(scene: GlideScene) {
        guard let spriteNodeComponent = entity?.component(ofType: SpriteNodeComponent.self) else {
            return
        }
        
        let mainNode = spriteNodeComponent.spriteNode
        
        if leftOrTopNode != mainNode {
            leftOrTopNode?.removeFromParent()
            leftOrTopNode = nil
        }
        if rightOrBottomNode != mainNode {
            rightOrBottomNode?.removeFromParent()
            rightOrBottomNode = nil
        }
        if centerNode != mainNode {
            centerNode?.removeFromParent()
            centerNode = nil
        }
        
        if let nodeCopy = mainNode.copy() as? SKSpriteNode {
            centerNode = nodeCopy
            transform?.node.addChild(nodeCopy)
        }
        
        if let nodeCopy = mainNode.copy() as? SKSpriteNode {
            leftOrTopNode = nodeCopy
            transform?.node.addChild(nodeCopy)
        }
        if let nodeCopy = mainNode.copy() as? SKSpriteNode {
            rightOrBottomNode = nodeCopy
            transform?.node.addChild(nodeCopy)
        }
        
        layoutNodes()
    }
    
    private func layoutNodes() {
        guard
            let centerNode = centerNode,
            let leftOrTopNode = leftOrTopNode,
            let rightOrBottomNode = rightOrBottomNode
        else {
            return
        }
        
        switch scrollAxis {
        case .horizontal:
            leftOrTopNode.position = centerNode.position - CGPoint(x: leftOrTopNode.size.width, y: 0.0)
            rightOrBottomNode.position = centerNode.position + CGPoint(x: rightOrBottomNode.size.width, y: 0.0)
        case .vertical:
            leftOrTopNode.position = centerNode.position - CGPoint(x: 0.0, y: leftOrTopNode.size.height)
            rightOrBottomNode.position = centerNode.position + CGPoint(x: 0.0, y: rightOrBottomNode.size.height)
        }
    }
    
    private func scrollSprite(deltaTime seconds: TimeInterval) {
        guard let scene = scene else {
            return
        }
        guard let cameraComponent = scene.cameraEntity.component(ofType: CameraComponent.self) else {
            return
        }
        guard let centerNode = centerNode else {
            return
        }
        
        var newPosition = centerNode.position
        newPosition.x += autoScrollSpeed * CGFloat(seconds)
        centerNode.position = newPosition
        layoutNodes()
        
        moveLeftOrTopNodeToRightOrBottomIfNeeded(camera: cameraComponent.cameraNode, scene: scene)
        moveRightOrBottomNodeToLeftOrTopIfNeeded(camera: cameraComponent.cameraNode, scene: scene)
    }
    
    private func moveLeftOrTopNodeToRightOrBottomIfNeeded(camera: SKCameraNode, scene: SKScene) {
        guard
            let currentRightOrBottomNode = rightOrBottomNode,
            let currentLeftOrTopNode = leftOrTopNode,
            let currentCenterNode = centerNode,
            let parent = currentLeftOrTopNode.parent
        else {
            return
        }
        
        let positionInCamera = camera.convert(currentLeftOrTopNode.position, from: parent)
        let leftmostFrameInCamera = positionInCamera.centeredFrame(withSize: currentLeftOrTopNode.size)
        
        switch scrollAxis {
        case .horizontal:
            guard leftmostFrameInCamera.maxX < -(scene.size.width / 2) else {
                return
            }
            
            currentLeftOrTopNode.position = currentRightOrBottomNode.position + CGPoint(x: currentLeftOrTopNode.size.width, y: 0.0)
        case .vertical:
            guard leftmostFrameInCamera.minY > scene.size.height / 2 else {
                return
            }
            
            currentLeftOrTopNode.position = currentRightOrBottomNode.position - CGPoint(x: 0.0, y: currentLeftOrTopNode.size.height)
        }
        
        rightOrBottomNode = currentLeftOrTopNode
        centerNode = currentRightOrBottomNode
        leftOrTopNode = currentCenterNode
    }
    
    private func moveRightOrBottomNodeToLeftOrTopIfNeeded(camera: SKCameraNode, scene: SKScene) {
        guard
            let currentLeftOrTopNode = leftOrTopNode,
            let currentRightOrBottomNode = rightOrBottomNode,
            let currentCenterNode = centerNode,
            let parent = currentRightOrBottomNode.parent
        else {
            return
        }
        
        let positionInCamera = camera.convert(currentRightOrBottomNode.position, from: parent)
        let rightmostFrameInCamera = positionInCamera.centeredFrame(withSize: currentRightOrBottomNode.size)
        
        switch scrollAxis {
        case .horizontal:
            guard rightmostFrameInCamera.minX > scene.size.width / 2 else {
                return
            }
            
            currentRightOrBottomNode.position = currentLeftOrTopNode.position - CGPoint(x: currentRightOrBottomNode.size.width, y: 0.0)
        case .vertical:
            guard rightmostFrameInCamera.maxX < -(scene.size.width / 2) else {
                return
            }
            
            currentRightOrBottomNode.position = currentLeftOrTopNode.position + CGPoint(x: 0.0, y: currentRightOrBottomNode.size.height)
        }
        
        leftOrTopNode = currentRightOrBottomNode
        centerNode = currentLeftOrTopNode
        rightOrBottomNode = currentCenterNode
    }
}

extension InfiniteSpriteScrollerComponent: NodeLayoutableComponent {
    public func layout(scene: GlideScene, previousSceneSize: CGSize) {
        guard scene.size != previousSceneSize else {
            return
        }
        populateNodes(scene: scene)
    }
}
