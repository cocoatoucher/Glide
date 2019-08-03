//
//  NavigatableButtonScrollView.swift
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

/// Scroll view that stacks its navigatable views in a given orientation.
class NavigatableButtonScrollView: View {
    
    var pageChangedHandler: ((_ currentPage: Int) -> Void)?
    
    private(set) var stackViewTopConstraint: NSLayoutConstraint?
    private(set) var stackViewLeadingConstraint: NSLayoutConstraint?
    
    #if os(iOS)
    var isTouchScroll: Bool = false {
        didSet {
            setupStackOrScrollView()
        }
    }
    #endif
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        #if os(iOS)
        isTouchScroll = Input.shared.inputMethod.isTouchesEnabled
        setupStackOrScrollView()
        
        inputMethodDidChangeObservation = NotificationCenter.default.addObserver(forName: .InputMethodDidChange, object: nil, queue: nil) { _ in
            self.isTouchScroll = Input.shared.inputMethod.isTouchesEnabled
        }
        #else
        setupStackView()
        #endif
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButtons(_ buttons: [NavigatableButton],
                    orientation: StackViewOrientation,
                    spacing: CGFloat,
                    numberOfButtonsPerPage: Int) {
        self.buttons.forEach { button in
            button.removeFromSuperview()
        }
        
        self.buttons = buttons
        stackView.orientationAndAxis = orientation
        self.numberOfButtonsPerPage = numberOfButtonsPerPage
        stackView.spacing = spacing
        
        buttons.forEach { stackView.addArrangedSubview($0) }
        
        updateOrientation()
    }
    
    func updateOrientation() {
        var pageWidthOrHeight: CGFloat
        switch stackView.orientationAndAxis {
        case .horizontal:
            pageWidthOrHeight = bounds.width
        case .vertical:
            pageWidthOrHeight = bounds.height
        }
        
        guard pageWidthOrHeight > 0 else {
            return
        }
        
        NSLayoutConstraint.deactivate(stackViewConstraints)
        stackViewConstraints = []
        
        #if os(iOS)
        if isTouchScroll {
            layoutScrollView()
        } else {
            layoutStackView()
        }
        #else
        layoutStackView()
        #endif
        NSLayoutConstraint.activate(stackViewConstraints)
        
        layoutButtons(pageWidthOrHeight: pageWidthOrHeight)
    }
    
    // MARK: - Private
    
    private lazy var stackView: StackView = {
        let stackView = StackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        #if os(OSX)
        stackView.alignment = NSLayoutConstraint.Attribute.width
        #else
        stackView.alignment = .fill
        #endif
        return stackView
    }()
    
    private var buttons: [NavigatableButton] = []
    private var numberOfButtonsPerPage: Int = 0
    
    private var stackViewConstraints: [NSLayoutConstraint] = []
    
    #if os(iOS)
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var placeholderViews: [View] = []
    #endif
    
    private func setupStackView() {
        stackView.removeFromSuperview()
        addSubview(stackView)
        updateOrientation()
    }
    
    private func layoutStackView() {
        let topConstraint = stackView.topAnchor.constraint(equalTo: topAnchor)
        stackViewTopConstraint = topConstraint
        stackViewConstraints.append(topConstraint)
        let leadingConstraint = stackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        stackViewLeadingConstraint = leadingConstraint
        stackViewConstraints.append(leadingConstraint)
        
        switch stackView.orientationAndAxis {
        case .horizontal:
            stackViewConstraints.append(stackView.bottomAnchor.constraint(equalTo: bottomAnchor))
        case .vertical:
            stackViewConstraints.append(stackView.trailingAnchor.constraint(equalTo: trailingAnchor))
        }
    }
    
    private func layoutButtons(pageWidthOrHeight: CGFloat) {
        let totalSpacingBetweenButtons = stackView.spacing * CGFloat(numberOfButtonsPerPage - 1)
        let preferredButtonWidth = (pageWidthOrHeight - totalSpacingBetweenButtons) / CGFloat(numberOfButtonsPerPage)
        let buttonSize: CGFloat = max(preferredButtonWidth, 0)
        
        buttons.forEach { button in
            let widthAndHeightConstraints = button.constraints.filter {
                $0.firstItem === button &&
                    ($0.firstAttribute == NSLayoutConstraint.Attribute.width ||
                        $0.firstAttribute == NSLayoutConstraint.Attribute.height) }
            NSLayoutConstraint.deactivate(widthAndHeightConstraints)
            
            stackView.setCustomSpacing(stackView.spacing, after: button)
            if let index = buttons.firstIndex(of: button) {
                if index % numberOfButtonsPerPage == numberOfButtonsPerPage - 1 {
                    stackView.setCustomSpacing(0.0, after: button)
                }
            }
            
            switch stackView.orientationAndAxis {
            case .horizontal:
                NSLayoutConstraint.activate([
                    button.widthAnchor.constraint(equalToConstant: buttonSize)
                    ])
                #if os(OSX)
                NSLayoutConstraint.activate([
                    button.topAnchor.constraint(equalTo: stackView.topAnchor),
                    button.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
                    ])
                #endif
            case .vertical:
                NSLayoutConstraint.activate([
                    button.heightAnchor.constraint(equalToConstant: buttonSize)
                    ])
                #if os(OSX)
                NSLayoutConstraint.activate([
                    button.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
                    button.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
                    ])
                #endif
            }
        }
        
        #if os(iOS)
        setupPlaceholderViewsIfNeeded(buttonSize: buttonSize)
        #endif
    }
    
    #if os(iOS)
    private var inputMethodDidChangeObservation: Any?
    
    private func setupStackOrScrollView() {
        if isTouchScroll {
            setupScrollView()
        } else {
            setupStackView()
        }
    }
    
    private func setupScrollView() {
        scrollView.delegate = nil
        scrollView.removeFromSuperview()
        stackView.removeFromSuperview()
        
        scrollView.delegate = self
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        
        updateOrientation()
    }
    
    private func layoutScrollView() {
        switch stackView.orientationAndAxis {
        case .horizontal:
            scrollView.alwaysBounceHorizontal = true
            scrollView.alwaysBounceVertical = false
            stackViewConstraints.append(stackView.topAnchor.constraint(equalTo: topAnchor))
            stackViewConstraints.append(stackView.bottomAnchor.constraint(equalTo: bottomAnchor))
            stackViewConstraints.append(stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor))
            stackViewConstraints.append(stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor))
        case .vertical:
            scrollView.alwaysBounceHorizontal = false
            scrollView.alwaysBounceVertical = true
            stackViewConstraints.append(stackView.leadingAnchor.constraint(equalTo: leadingAnchor))
            stackViewConstraints.append(stackView.trailingAnchor.constraint(equalTo: trailingAnchor))
            stackViewConstraints.append(stackView.topAnchor.constraint(equalTo: scrollView.topAnchor))
            stackViewConstraints.append(stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor))
        }
    }
    
    private func setupPlaceholderViewsIfNeeded(buttonSize: CGFloat) {
        for view in placeholderViews {
            view.removeFromSuperview()
        }
        
        guard isTouchScroll else {
            return
        }
        
        guard buttons.count % numberOfButtonsPerPage > 0 else {
            return
        }
        let numberOfPlaceholders = numberOfButtonsPerPage - (buttons.count % numberOfButtonsPerPage)
        placeholderViews = []
        for _ in 0 ..< numberOfPlaceholders {
            let placeholderView = NavigatableButtonPlaceholderView()
            placeholderView.translatesAutoresizingMaskIntoConstraints = false
            placeholderViews.append(placeholderView)
            stackView.addArrangedSubview(placeholderView)
            switch stackView.orientationAndAxis {
            case .horizontal:
                NSLayoutConstraint.activate([
                    placeholderView.widthAnchor.constraint(equalToConstant: buttonSize)
                    ])
            case .vertical:
                NSLayoutConstraint.activate([
                    placeholderView.heightAnchor.constraint(equalToConstant: buttonSize)
                    ])
            }
        }
    }
    #endif
    
    deinit {
        #if os(iOS)
        if let observation = inputMethodDidChangeObservation {
            NotificationCenter.default.removeObserver(observation)
        }
        #endif
    }
}

#if os(iOS)
extension NavigatableButtonScrollView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch stackView.orientationAndAxis {
        case .horizontal:
            let currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
            pageChangedHandler?(currentPage)
        case .vertical:
            let currentPage = Int(scrollView.contentOffset.y / scrollView.bounds.height)
            pageChangedHandler?(currentPage)
        }
    }
}
#endif
