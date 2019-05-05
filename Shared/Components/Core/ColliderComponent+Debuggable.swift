//
//  ColliderComponent+Debuggable.swift
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

import SpriteKit

extension ColliderComponent: DebuggableComponent {
    func addOrUpdateHitPointDebugNode(with name: String, index: Int, hitPoint: CGPoint) {
        let nodeName = debugElementName(with: "\(name)_\(index)")
        
        var result: SKSpriteNode
        
        defer {
            result.position = hitPoint + CGPoint(x: 0.5, y: 0.5)
        }
        
        if let existingNode = transform?.node.childNode(withName: nodeName) as? SKSpriteNode {
            result = existingNode
            return
        }
        
        let debugNodeSize = CGSize(width: 1, height: 1)
        let debugNode = SKSpriteNode(texture: nil, size: debugNodeSize)
        debugNode.name = nodeName
        debugNode.color = Color.cyan
        transform?.node.addChild(debugNode)
        result = debugNode
    }
    
    func removeHitPointDebugNode(with name: String) {
        let nodeName0 = debugElementName(with: "\(name)_0")
        transform?.node.childNode(withName: nodeName0)?.removeFromParent()
        let nodeName1 = debugElementName(with: "\(name)_1")
        transform?.node.childNode(withName: nodeName1)?.removeFromParent()
    }
    
    public func updateDebugElements() {
        if colliderFrameDebugNode.parent == nil {
            transform?.node.addChild(colliderFrameDebugNode)
        }
        
        colliderFrameDebugNode.position = offset
        
        drawDebugSpritesFor(leftHitPoints(at: .zero), debugSpriteName: "leftHitPoints")
        drawDebugSpritesFor(rightHitPoints(at: .zero), debugSpriteName: "rightHitPoints")
        drawDebugSpritesFor(bottomHitPoints(at: .zero), debugSpriteName: "bottomHitPoints")
        drawDebugSpritesFor(topHitPoints(at: .zero), debugSpriteName: "topHitPoints")
    }
    
    func drawDebugSpritesFor(_ hitPoints: (CGRect, CGRect), debugSpriteName: String) {
        addOrUpdateHitPointDebugNode(with: debugSpriteName, index: 0, hitPoint: hitPoints.0.origin)
        addOrUpdateHitPointDebugNode(with: debugSpriteName, index: 1, hitPoint: hitPoints.1.origin)
    }
    
    public func cleanDebugElements() {
        colliderFrameDebugNode.removeFromParent()
        removeHitPointDebugNode(with: "leftHitPoints")
        removeHitPointDebugNode(with: "rightHitPoints")
        removeHitPointDebugNode(with: "bottomHitPoints")
        removeHitPointDebugNode(with: "topHitPoints")
    }
}
