//
//  View.swift
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
import AppKit.NSView
public typealias ViewType = NSView
#else
import UIKit.UIView
public typealias ViewType = UIView
#endif

open class View: ViewType {
    #if os(OSX)
    open var userInteractionEnabled: Bool {
        return true
    }
    
    open override func viewDidMoveToWindow() {
        didMoveToWindow()
    }
    
    open func didMoveToWindow() {
        super.viewDidMoveToWindow()
    }
    
    open override func viewDidMoveToSuperview() {
        didMoveToSuperview()
    }
    
    open func didMoveToSuperview() {
        super.viewDidMoveToSuperview()
    }
    
    open override func layout() {
        layoutSubviews()
    }
    
    open func layoutSubviews() {
        super.layout()
    }
    
    open var backgroundColor: Color? {
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
        }
        get {
            if let color = layer?.backgroundColor {
                return Color(cgColor: color)
            }
            return nil
        }
    }
    
    open var borderColor: Color? {
        set {
            layer?.borderColor = newValue?.cgColor
        }
        get {
            if let color = layer?.borderColor {
                return Color(cgColor: color)
            }
            return nil
        }
    }
    
    open var borderWidth: CGFloat {
        set {
            layer?.borderWidth = newValue
        }
        get {
            return layer?.borderWidth ?? 0
        }
    }
    
    open var cornerRadius: CGFloat {
        set {
            layer?.cornerRadius = newValue
        }
        get {
            return layer?.cornerRadius ?? 0
        }
    }
    
    open var isUserInteractionEnabled: Bool {
        set {
            // Does nothing
        }
        get {
            return userInteractionEnabled
        }
    }
    
    public func bringSubviewToFront(_ view: NSView) {
        addSubview(view, positioned: .above, relativeTo: nil)
    }
    
    public func sendSubview(toBack view: NSView) {
        addSubview(view, positioned: .below, relativeTo: nil)
    }
    
    open var clipsToBounds: Bool {
        set {
            layer?.masksToBounds = newValue
        }
        get {
            return layer?.masksToBounds ?? false
        }
    }
    
    open var safeAreaLeadingAnchor: NSLayoutXAxisAnchor {
        return leadingAnchor
    }
    
    open var safeAreaTrailingAnchor: NSLayoutXAxisAnchor {
        return trailingAnchor
    }
    
    open var safeAreaTopAnchor: NSLayoutYAxisAnchor {
        return topAnchor
    }
    
    open var safeAreaBottomAnchor: NSLayoutYAxisAnchor {
        return bottomAnchor
    }
    
    open var safeAreaCenterXAnchor: NSLayoutXAxisAnchor {
        return centerXAnchor
    }
    
    open var safeAreaCenterYAnchor: NSLayoutYAxisAnchor {
        return centerYAnchor
    }
    
    open var safeAreaWidthAnchor: NSLayoutDimension {
        return widthAnchor
    }
    
    open var safeAreaHeightAnchor: NSLayoutDimension {
        return heightAnchor
    }
    
    open func addAnimationToLayer(_ animation: CAAnimation, forKey animationKey: String?) {
        layer?.add(animation, forKey: animationKey)
    }
    
    open func removeAllAnimationsFromLayer() {
        layer?.removeAllAnimations()
    }
    
    #else
    open var wantsLayer: Bool {
        set {
            // Does nothing
        }
        get {
            return true
        }
    }
    
    open var borderColor: Color? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            if let color = layer.borderColor {
                return Color(cgColor: color)
            }
            return nil
        }
    }
    
    open var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    open var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    open var safeAreaLeadingAnchor: NSLayoutXAxisAnchor {
        return safeAreaLayoutGuide.leadingAnchor
    }
    
    open var safeAreaTrailingAnchor: NSLayoutXAxisAnchor {
        return safeAreaLayoutGuide.trailingAnchor
    }
    
    open var safeAreaTopAnchor: NSLayoutYAxisAnchor {
        return safeAreaLayoutGuide.topAnchor
    }
    
    open var safeAreaBottomAnchor: NSLayoutYAxisAnchor {
        return safeAreaLayoutGuide.bottomAnchor
    }
    
    open var safeAreaCenterXAnchor: NSLayoutXAxisAnchor {
        return safeAreaLayoutGuide.centerXAnchor
    }
    
    open var safeAreaCenterYAnchor: NSLayoutYAxisAnchor {
        return safeAreaLayoutGuide.centerYAnchor
    }
    
    open var safeAreaWidthAnchor: NSLayoutDimension {
        return safeAreaLayoutGuide.widthAnchor
    }
    
    open var safeAreaHeightAnchor: NSLayoutDimension {
        return safeAreaLayoutGuide.heightAnchor
    }
    
    open func addAnimationToLayer(_ animation: CAAnimation, forKey animationKey: String?) {
        layer.add(animation, forKey: animationKey)
    }
    
    open func removeAllAnimationsFromLayer() {
        layer.removeAllAnimations()
    }
    #endif
}

#if os(OSX)
extension View.AutoresizingMask {
    public static var flexibleWidth: View.AutoresizingMask {
        return width
    }
    
    public static var flexibleHeight: View.AutoresizingMask {
        return height
    }
}
#endif
