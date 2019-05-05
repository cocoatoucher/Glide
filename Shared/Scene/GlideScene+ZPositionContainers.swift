//
//  GlideScene+ZPositionContainers.swift
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

extension GlideScene {
    
    func constructZPositionContainerNodes() {
        var zPosition: CGFloat = 1000
        for container in zPositionContainers {
            if container is GlideZPositionContainer {
                fatalError("Order container name is reserved: \(container)")
            }
            let node = SKNode()
            node.name = zPositionContainerNodeName(container)
            node.zPosition = zPosition
            addChild(node)
            zPosition += 1000
        }
    }
    
    func zPositionContainerNode(with zPositionContainer: ZPositionContainer) -> SKNode? {
        let container = childNode(withName: zPositionContainerNodeName(zPositionContainer))
        if zPositionContainer.rawValue == GlideZPositionContainer.camera.rawValue {
            if let camera = container?.children.first(where: { $0 is SKCameraNode }) {
                return camera
            }
        }
        return container
    }
    
    func zPositionContainerNodeName(_ zPositionContainer: ZPositionContainer) -> String {
        return "Glide.ZPositionContainer.\(zPositionContainer.rawValue)"
    }
}
