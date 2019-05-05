//
//  NavigatableButtonScrollViewController.swift
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

public extension Notification.Name {
    static let NavigatableButtonScrollViewDidScrollToNextPage = Notification.Name("NavigatableButtonScrollViewDidScrollToNextPage")
    static let NavigatableButtonScrollViewDidScrollToPreviousPage = Notification.Name("NavigatableButtonScrollViewDidScrollToPreviousPage")
}

/// Navigatable view controller with scrollable navigatable buttons.
open class NavigatableButtonScrollViewController: NavigatableViewController {
    
    /// Navigatable buttons displayed and controller by this scroll view controller.
    public private(set) var buttons: [NavigatableButton] = [] {
        didSet {
            navigatableScrollView.setButtons(buttons,
                                             orientation: orientation,
                                             spacing: buttonSpacing,
                                             numberOfButtonsPerPage: numberOfButtonsPerPage)
            updateButtonStack()
        }
    }
    
    /// Navigatable button which currently has the focus.
    public var focusedButton: NavigatableButton? {
        return focusedChild as? NavigatableButton
    }
    
    /// Number of pages this view controller's scroll view contains.
    public private(set) var numberOfPages: Int = 0 {
        didSet {
            updateSideIndicators()
        }
    }
    
    /// Currently visible page index of this view controller's scroll view.
    public private(set) var currentPage: Int = 0 {
        didSet {
            updateSideIndicators()
            updateCurrentPage()
        }
    }
    
    /// `true` if `currentPage` is bigger than 0.
    @objc dynamic public private(set) var hasPagesOnNegativeSide: Bool = false
    
    /// `true` if `currentPage` is smaller than `numberOfPages - 1`.
    @objc dynamic public private(set) var hasPagesOnPositiveSide: Bool = false
    
    /// Layout orientation for this view controller's buttons.
    public let orientation: StackViewOrientation
    
    /// Desired space between this view controller's buttons.
    public let buttonSpacing: CGFloat
    
    /// Number of buttons to display per each page of this view controller's scroll view.
    public let numberOfButtonsPerPage: Int
    
    // MARK: - Initialize
    
    /// Create a navigatable button scroll view controller.
    ///
    /// - Parameters:
    ///     - orientation: Layout orientation for this view controller's buttons.
    ///     - buttons: Navigatable buttons displayed and controller by this scroll view
    /// controller.
    ///     - buttonSpacing: Desired space between this view controller's buttons.
    ///     - numberOfButtonsPerPage: Number of buttons to display per each page of this
    /// view controller's scroll view.
    public init(orientation: StackViewOrientation,
                buttons: [NavigatableButton],
                buttonSpacing: CGFloat,
                numberOfButtonsPerPage: Int) {
        self.orientation = orientation
        self.buttons = buttons
        self.numberOfButtonsPerPage = numberOfButtonsPerPage
        self.buttonSpacing = buttonSpacing
        super.init(nibName: nil, bundle: nil)
        
        removeAllChildren()
        append(children: buttons)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func loadView() {
        view = View()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(navigatableScrollView)
        NSLayoutConstraint.activate([
            navigatableScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            navigatableScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigatableScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            navigatableScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
        navigatableScrollView.setButtons(buttons,
                                         orientation: orientation,
                                         spacing: buttonSpacing,
                                         numberOfButtonsPerPage: numberOfButtonsPerPage)
    }
    
    #if os(OSX)
    open override func viewDidLayout() {
        super.viewDidLayout()
        
        navigatableScrollView.updateOrientation()
        updateButtonStack()
    }
    
    #else
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        navigatableScrollView.updateOrientation()
        updateButtonStack()
    }
    #endif
    
    /// Adds a new navigatable button to be displayed in this view controller's scroll view.
    func addButton(_ button: NavigatableButton) {
        buttons.append(button)
        focus(on: button)
    }
    
    /// Removes the navigatable button at given index from the list of buttons of this view
    /// controller.
    func removeButton(at index: Int) {
        buttons.remove(at: index)
        isFocusedElement = true
    }
    
    /// Scrolls to previous page if possible.
    public func scrollToPreviousPage() {
        scrollToPage(currentPage - 1)
    }
    
    /// Scrolls to next page if possible.
    public func scrollToNextPage() {
        scrollToPage(currentPage + 1)
    }
    
    /// Scrolls to the last page if possible.
    public func goToLastPage() {
        scrollToPage(numberOfPages - 1)
    }
    
    /// Scrolls to specified page if possible.
    /// Does nothing if page is out of bounds.
    public func scrollToPage(_ page: Int) {
        guard page >= 0 else {
            return
        }
        guard page <= numberOfPages - 1 else {
            return
        }
        currentPage = page
        focus(on: buttons[currentPage * numberOfButtonsPerPage])
    }
    
    open override func didFocus(on element: NavigatableElement) {
        guard let button = buttons.filter({ $0.focusedChild != nil || $0.isFocusedElement }).first else {
            return
        }
        guard let buttonIndex = buttons.firstIndex(of: button) else {
            return
        }
        
        self.currentPage = Int(ceil(CGFloat(buttonIndex / numberOfButtonsPerPage)))
    }
    
    open override func didPerformNavigateToNextPage(focusedChild: NavigatableElement? = nil) {
        scrollToNextPage()
        NotificationCenter.default.post(name: .NavigatableButtonScrollViewDidScrollToNextPage, object: self)
    }
    
    open override func didPerformNavigateToPreviousPage(focusedChild: NavigatableElement? = nil) {
        scrollToPreviousPage()
        NotificationCenter.default.post(name: .NavigatableButtonScrollViewDidScrollToPreviousPage, object: self)
    }
    
    // MARK: - Private
    
    private var isAnimating: Bool = false
    private var animatingToConstant: CGFloat = 0
    
    private lazy var navigatableScrollView: NavigatableButtonScrollView = {
        let view = NavigatableButtonScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.pageChangedHandler = { [weak self] currentPage in
            self?.currentPage = currentPage
        }
        return view
    }()
    
    private func updateSideIndicators() {
        hasPagesOnNegativeSide = currentPage > 0 && numberOfPages > 1
        hasPagesOnPositiveSide = currentPage < numberOfPages - 1
    }
    
    private func updateCurrentPage() {
        #if os(iOS)
        guard navigatableScrollView.isTouchScroll == false else {
            return
        }
        #endif
        
        var finalOffset: CGFloat
        switch orientation {
        case .horizontal:
            finalOffset = -CGFloat(currentPage) * navigatableScrollView.bounds.size.width
        case .vertical:
            finalOffset = -CGFloat(currentPage) * navigatableScrollView.bounds.size.height
        }
        
        if finalOffset != animatingToConstant {
            #if os(OSX)
            NSAnimationContext.current.duration = 0.2
            isAnimating = true
            animatingToConstant = finalOffset
            
            NSAnimationContext.runAnimationGroup({ _ in
                switch orientation {
                case .horizontal:
                    navigatableScrollView.stackViewLeadingConstraint?.animator().constant = finalOffset
                case .vertical:
                    navigatableScrollView.stackViewTopConstraint?.animator().constant = finalOffset
                }
            }, completionHandler: {
                self.isAnimating = false
            })
            #endif
        }
        
        #if !os(OSX)
        switch orientation {
        case .horizontal:
            navigatableScrollView.stackViewLeadingConstraint?.constant = finalOffset
        case .vertical:
            navigatableScrollView.stackViewTopConstraint?.constant = finalOffset
        }
        
        navigatableScrollView.setNeedsUpdateConstraints()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.navigatableScrollView.layoutIfNeeded()
        }, completion: { _ in
            self.isAnimating = false
        })
        #endif
    }
    
    private func updateButtonStack() {
        buttons.forEach { button in
            button.rightElement = nil
            button.leftElement = nil
            button.upElement = nil
            button.downElement = nil
        }
        
        for (index, button) in buttons.enumerated() where index + 1 < buttons.count {
            let nextButton = buttons[index + 1]
            switch orientation {
            case .horizontal:
                button.rightElement = nextButton
                nextButton.leftElement = button
            case .vertical:
                button.downElement = nextButton
                nextButton.upElement = button
            }
        }
        
        removeAllChildren()
        append(children: buttons)
        
        numberOfPages = Int(ceil(Double(buttons.count) / Double(numberOfButtonsPerPage)))
        if currentPage >= numberOfPages {
            goToLastPage()
        }
    }
}
