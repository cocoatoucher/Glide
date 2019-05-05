//
//  DemoTileSet.swift
//  glide Demo
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

class DemoTileSet {
    static func horizontalPlatformsTileSet() -> SKTileSet {
        var tileGroups: [SKTileGroup] = []
        tileGroups.append(DemoTileSet.tileGroup(with: "plat_left"))
        tileGroups.append(DemoTileSet.tileGroup(with: "plat_middle"))
        tileGroups.append(DemoTileSet.tileGroup(with: "plat_right"))
        return SKTileSet(tileGroups: tileGroups)
    }
    
    static func verticalPlatformsTileSet() -> SKTileSet {
        var tileGroups: [SKTileGroup] = []
        tileGroups.append(DemoTileSet.tileGroup(with: "plat_top"))
        tileGroups.append(DemoTileSet.tileGroup(with: "plat_middle_vertical"))
        tileGroups.append(DemoTileSet.tileGroup(with: "plat_bottom"))
        return SKTileSet(tileGroups: tileGroups)
    }
    
    static func tileGroup(with textureName: String) -> SKTileGroup {
        let texture = SKTexture(imageNamed: textureName)
        texture.filteringMode = .nearest
        let tileDefinition = SKTileDefinition(texture: texture)
        let tileGroup = SKTileGroup(tileDefinition: tileDefinition)
        return tileGroup
    }
}
