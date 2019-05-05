//
//  Image.swift
//  glide
//
//  Based on https://github.com/soffes/X
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

#if os(OSX)
import AppKit.NSImage
public typealias Image = NSImage

extension Image {
    public var cgImage: CGImage! {
        return cgImage(forProposedRect: nil, context: nil, hints: nil)
    }
    
    // Optional to match UIImage
    public convenience init?(cgImage: CGImage) {
        self.init(cgImage: cgImage, size: .zero)
    }
}
#else
import UIKit.UIImage
public typealias Image = UIImage
#endif

#if os(iOS) || os(tvOS)
extension Image {
    public convenience init?(named name: String, in bundle: Bundle?) {
        self.init(named: name, in: bundle, compatibleWith: nil)
    }
}
#endif // OS X version implemented in Objective-C. watchOS version isn’t possible. 😭
