//
//  TiledRect.swift
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

import CoreGraphics

/// Rectangle in tile units.
public struct TiledRect: Equatable {
    public var origin: TiledPoint
    public var size: TiledSize
    
    public init(origin: TiledPoint, size: TiledSize) {
        self.origin = origin
        self.size = size
    }
}

extension TiledRect: CustomStringConvertible {
    public var description: String {
        return "origin: \(origin), size: \(size)"
    }
}

extension TiledRect {
    
    /// Returns the CGRect equivalent of the current rect
    /// calculated with given tile size.
    public func rect(with tileSize: CGSize) -> CGRect {
        return CGRect(x: CGFloat(origin.x) * tileSize.width,
                      y: CGFloat(origin.y) * tileSize.height,
                      width: CGFloat(size.width) * tileSize.width,
                      height: CGFloat(size.height) * tileSize.height)
    }
}
