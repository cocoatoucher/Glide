//
//  SelectionButtonContentView.swift
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

import GlideEngine
#if os(OSX)
import AppKit
#else
import UIKit
#endif

class SelectionButtonContentView: View, NavigatableButtonContentView {
    
    var safeAreaGuide = LayoutGuide()
    var selectAnimationCompletion: (() -> Void)?
    
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                selectedView = CheckmarkSelectedView(frame: .zero)
            } else {
                selectedView = nil
            }
        }
    }
    var isFocusedElement: Bool = false {
        didSet {
            if isFocusedElement {
                if Input.shared.inputMethod.shouldDisplayFocusOnUI {
                    focusAnimationView = NavigationFocusAnimationView(frame: .zero)
                }
            } else {
                focusAnimationView = nil
            }
        }
    }
    
    var focusAnimationView: NavigationFocusAnimationView? {
        didSet {
            if let oldView = oldValue {
                oldView.removeFromSuperview()
            }
            
            if let newView = focusAnimationView {
                newView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(newView)
                if let selectedView = selectedView {
                    bringSubviewToFront(selectedView)
                }
                NSLayoutConstraint.activate([
                    newView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3.0),
                    newView.topAnchor.constraint(equalTo: topAnchor, constant: 3.0),
                    newView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3.0),
                    newView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3.0)
                    ])
            }
        }
    }
    var selectedView: CheckmarkSelectedView? {
        didSet {
            if let oldView = oldValue {
                oldView.removeFromSuperview()
            }
            
            if let newView = selectedView {
                newView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(newView)
                NSLayoutConstraint.activate([
                    newView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    newView.topAnchor.constraint(equalTo: topAnchor)
                    ])
            }
        }
    }
    
    var isTouchedDown: Bool = false {
        didSet {
            if isTouchedDown {
                backgroundColor = Color.touchHighlightColor
            } else {
                backgroundColor = normalBackgroundColor
            }
        }
    }
    
    let normalBackgroundColor: Color
    
    var inputMethodDidChangeObservation: Any?
    
    init(normalBackgroundColor: Color) {
        self.normalBackgroundColor = normalBackgroundColor
        super.init(frame: .zero)
        backgroundColor = normalBackgroundColor
        addLayoutGuide(safeAreaGuide)
        NSLayoutConstraint.activate([
            safeAreaGuide.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6.0),
            safeAreaGuide.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6.0),
            safeAreaGuide.topAnchor.constraint(equalTo: topAnchor, constant: 6.0),
            safeAreaGuide.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6.0)
            ])
        
        #if os(iOS)
        inputMethodDidChangeObservation = NotificationCenter.default.addObserver(forName: .InputMethodDidChange, object: nil, queue: nil) { [weak self] _ in
            if Input.shared.inputMethod.shouldDisplayFocusOnUI == false {
                self?.focusAnimationView = nil
            }
        }
        #endif
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateSelect(completion: @escaping () -> Void) {
        
        focusAnimationView = nil
        
        var repeatCount = 2
        #if os(iOS)
        if Input.shared.inputMethod.isTouchesEnabled {
            repeatCount = 1
        }
        #endif
        
        let animation = CAAnimation.backgroundColorAnimation(from: backgroundColor ?? normalBackgroundColor,
                                                             to: Color.selectionAnimationDarkerBlueColor,
                                                             middleColor: Color.selectionAnimationBlueColor,
                                                             repeatCount: repeatCount)
        animation.delegate = self
        selectAnimationCompletion = completion
        
        addAnimationToLayer(animation, forKey: "bgColor")
    }
    
    deinit {
        if let observation = inputMethodDidChangeObservation {
            NotificationCenter.default.removeObserver(observation)
        }
    }
}

extension SelectionButtonContentView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        #if os(OSX)
        layer?.removeAllAnimations()
        #else
        layer.removeAllAnimations()
        #endif
        selectAnimationCompletion?()
        selectAnimationCompletion = nil
    }
}
