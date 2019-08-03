//
//  TiledGeometry.swift
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

// MARK: - Point

/// Point in tile units.
public struct TiledPoint: Equatable {
    public var x: Int
    public var y: Int
    
    public init(_ x: Int, _ y: Int) {
        self.init(x: x, y: y)
    }
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

extension TiledPoint {
    public static var zero: TiledPoint {
        return TiledPoint(0, 0)
    }
}

extension TiledPoint: CustomStringConvertible {
    public var description: String {
        return "x: \(x), y: \(y)"
    }
}

extension CGPoint {
    
    /// Returns the tiled point equivalent of the current point
    /// calculated with given tile size.
    public func tiledPoint(with tileSize: CGSize) -> TiledPoint {
        return TiledPoint(Int(x / tileSize.width),
                          Int(y / tileSize.height))
    }
}

extension TiledPoint {
    
    /// Returns the CGPoint equivalent of the current point
    /// calculated with given tile size.
    public func point(with tileSize: CGSize) -> CGPoint {
        return CGPoint(x: CGFloat(x) * tileSize.width,
                       y: CGFloat(y) * tileSize.height)
    }
    
    /// Returns a 1x1 tile frame with the current point at its origin
    /// calculated with given tile size.
    public func singleTiledRect(with tileSize: CGSize) -> CGRect {
        return CGRect(x: CGFloat(x) * tileSize.width,
                      y: CGFloat(y) * tileSize.height,
                      width: tileSize.width,
                      height: tileSize.height)
    }
}

/// Adds fields of two tiled points and returns new fields as a new tiled point.
public func + (left: TiledPoint, right: TiledPoint) -> TiledPoint {
    return TiledPoint(left.x + right.x, left.y + right.y)
}

/// Substracts the fields of a tiled point from another and returns new fields as
/// a new tiled point.
public func - (left: TiledPoint, right: TiledPoint) -> TiledPoint {
    return TiledPoint(x: left.x - right.x, y: left.y - right.y)
}

// MARK: - Size

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

extension CGSize {
    
    /// Returns the tiled size equivalent of the current size
    /// calculated with given tile size.
    public func tiledSize(with tileSize: CGSize) -> TiledSize {
        return TiledSize(width: Int(width / tileSize.width),
                         height: Int(height / tileSize.height))
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

// MARK: - Rect

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

extension CGRect {
    
    /// Returns the tiled rect equivalent of the current rect
    /// calculated with given tile size.
    public func tiledRect(with tileSize: CGSize) -> TiledRect {
        return TiledRect(origin: origin.tiledPoint(with: tileSize),
                         size: size.tiledSize(with: tileSize))
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

// MARK: - Range

/// Range in tile units.
public struct TiledRange {
    let left: Int
    let right: Int
    let top: Int
    let bottom: Int
}
