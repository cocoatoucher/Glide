//
//  TiledSize.swift
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

/// Size in tile units.
public struct TiledSize: Equatable {
    public var width: Int
    public var height: Int
    
    public init(_ width: Int, _ height: Int) {
        self.init(width: width, height: height)
    }
    
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}

extension TiledSize: CustomStringConvertible {
    public var description: String {
        return "width: \(width), height: \(height)"
    }
}

extension TiledSize {
    
    /// Returns the CGSize equivalent of the current size
    /// calculated with given tile size.
    public func size(with tileSize: CGSize) -> CGSize {
        return CGSize(width: CGFloat(width) * tileSize.width,
                      height: CGFloat(height) * tileSize.height)
    }
    
    /// Returns the CGPoint equivalent of the current size
    /// calculated with given tile size.
    public func toPoint(with tileSize: CGSize) -> CGPoint {
        return CGPoint(x: CGFloat(width) * tileSize.width,
                       y: CGFloat(height) * tileSize.height)
    }
}
