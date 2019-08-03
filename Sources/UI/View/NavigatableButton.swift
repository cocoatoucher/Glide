//
//  NavigatableButton.swift
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

#if os(OSX)
import AppKit
#else
import UIKit
#endif

/// Button that adopts to navigatable element protocol.
public class NavigatableButton: View, NavigatableElement {
    
    // MARK: - Navigatable Element
    
    public weak var upElement: NavigatableElement?
    public weak var downElement: NavigatableElement?
    public weak var leftElement: NavigatableElement?
    public weak var rightElement: NavigatableElement?
    
    public weak var parentElement: NavigatableElement?
    public weak var firstResponderChild: NavigatableElement?
    public var childElements: [NavigatableElement] = []
    
    public var isFocusedElement: Bool = false {
        didSet {
            configureFocused()
        }
    }
    
    /// View that renders contents for this button.
    public var contentView: (NavigatableButtonContentView & View)? {
        didSet {
            for subview in contentContainerView.subviews {
                subview.removeFromSuperview()
            }
            
            if let contentView = contentView {
                contentView.isUserInteractionEnabled = false
                contentView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(contentView)
                NSLayoutConstraint.activate([
                    contentView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor),
                    contentView.topAnchor.constraint(equalTo: contentContainerView.topAnchor),
                    contentView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor),
                    contentView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor)
                    ])
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        wantsLayer = true
        configureFocused()
        
        contentContainerView.isUserInteractionEnabled = false
        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentContainerView)
        NSLayoutConstraint.activate([
            contentContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentContainerView.topAnchor.constraint(equalTo: topAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        
        #if os(iOS)
        configureTouchButton()
        
        inputMethodDidChangeObservation = NotificationCenter.default.addObserver(forName: .InputMethodDidChange, object: nil, queue: nil) { [weak self] _ in
            self?.configureTouchButton()
        }
        #elseif os(OSX)
        configureAsClickInput()
        #endif
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        wantsLayer = true
        configureFocused()
    }
    
    public func animateSelect(completion: @escaping () -> Void) {
        contentView?.animateSelect(completion: completion)
    }
    
    // MARK: - Private
    
    private var contentContainerView = View()
    
    private func configureFocused() {
        contentView?.isFocusedElement = isFocusedElement
    }
    
    #if os(iOS)
    private var inputMethodDidChangeObservation: Any?
    
    private lazy var touchButton: Button = {
        let button = Button()
        button.isExclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func configureTouchButton() {
        if Input.shared.inputMethod.isTouchesEnabled {
            guard touchButton.superview == nil else {
                return
            }
            insertSubview(touchButton, at: 0)
            NSLayoutConstraint.activate([
                touchButton.leadingAnchor.constraint(equalTo: leadingAnchor),
                touchButton.topAnchor.constraint(equalTo: topAnchor),
                touchButton.trailingAnchor.constraint(equalTo: trailingAnchor),
                touchButton.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
            touchButton.addTarget(self, action: #selector(onTouchUpInside), for: .touchUpInside)
            touchButton.addTarget(self, action: #selector(onTouchDown), for: .touchDown)
            touchButton.addTarget(self, action: #selector(onTouchDown), for: .touchDragEnter)
            touchButton.addTarget(self, action: #selector(onTouchDown), for: .touchDragInside)
            touchButton.addTarget(self, action: #selector(onTouchUp), for: .touchDragOutside)
            touchButton.addTarget(self, action: #selector(onTouchUp), for: .touchDragExit)
            touchButton.addTarget(self, action: #selector(onTouchUp), for: .touchUpInside)
            touchButton.addTarget(self, action: #selector(onTouchUp), for: .touchUpOutside)
            touchButton.addTarget(self, action: #selector(onTouchUp), for: .touchCancel)
        } else {
            touchButton.removeFromSuperview()
            touchButton.removeTarget(self, action: #selector(onTouchUpInside), for: .touchUpInside)
            touchButton.removeTarget(self, action: #selector(onTouchDown), for: .touchDown)
            touchButton.removeTarget(self, action: #selector(onTouchDown), for: .touchDragEnter)
            touchButton.removeTarget(self, action: #selector(onTouchDown), for: .touchDragInside)
            touchButton.removeTarget(self, action: #selector(onTouchUp), for: .touchDragOutside)
            touchButton.removeTarget(self, action: #selector(onTouchUp), for: .touchDragExit)
            touchButton.removeTarget(self, action: #selector(onTouchUp), for: .touchUpInside)
            touchButton.removeTarget(self, action: #selector(onTouchUp), for: .touchUpOutside)
            touchButton.removeTarget(self, action: #selector(onTouchUp), for: .touchCancel)
        }
    }
    
    @objc func onTouchDown(sender: UIButton) {
        handleTouchOrClickDown()
    }
    
    @objc func onTouchUp(sender: UIButton) {
        handleTouchOrClickUp()
    }
    
    @objc func onTouchUpInside(sender: Button) {
        handleTouchOrClickSuccess()
    }
    
    #elseif os(OSX)
    
    private var button = Button()
    
    private func configureAsClickInput() {
        let customCell = CustomButtonCell()
        button.cell = customCell
        button.translatesAutoresizingMaskIntoConstraints = false
        button.title = ""
        button.bezelStyle = .texturedSquare
        button.isBordered = false
        button.wantsLayer = true
        button.layer?.backgroundColor = NSColor.clear.cgColor
        button.target = self
        button.action = #selector(onClick)
        sendSubview(toBack: button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        
        customCell.highlightCallback = { [weak self] flag in
            if flag {
                self?.handleTouchOrClickDown()
            } else {
                self?.handleTouchOrClickUp()
            }
        }
    }
    
    @objc func onClick() {
        handleTouchOrClickSuccess()
    }
    #endif
    
    private func handleTouchOrClickDown() {
        owningViewController?.focus(on: self)
        contentView?.isTouchedDown = true
    }
    
    private func handleTouchOrClickUp() {
        contentView?.isTouchedDown = false
    }
    
    private func handleTouchOrClickSuccess() {
        owningViewController?.focus(on: self)
        owningViewController?.performSelect(focusedChild: self)
    }
    
    deinit {
        #if os(iOS)
        if let observation = inputMethodDidChangeObservation {
            NotificationCenter.default.removeObserver(observation)
        }
        #endif
    }
}

#if os(OSX)
class CustomButtonCell: NSButtonCell {
    var highlightCallback: ((Bool) -> Void)?
    
    override func highlight(_ flag: Bool, withFrame cellFrame: NSRect, in controlView: NSView) {
        highlightCallback?(flag)
    }
}
#endif
