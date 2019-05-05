//
//  NavigatableViewController.swift
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

import GameController
#if os(OSX)
import AppKit
#else
import UIKit
#endif

/// View controller that controls multiple views which adopt `NavigatableElement`.
open class NavigatableViewController: GCEventViewController, NavigatableElement {
    
    // MARK: - NavigatableElement
    
    public weak var upElement: NavigatableElement?
    public weak var downElement: NavigatableElement?
    public weak var leftElement: NavigatableElement?
    public weak var rightElement: NavigatableElement?
    
    public weak var parentElement: NavigatableElement?
    public weak var firstResponderChild: NavigatableElement?
    public var childElements: [NavigatableElement] = []
    
    public var isFocusedElement: Bool = false
    
    public var selectHandler: ((_ context: Any?) -> Void)?
    public var cancelHandler: ((_ context: Any?) -> Void)?
    
    /// Child view controller that's being displayed modally.
    public private(set) var modalChild: NavigatableViewController?
    
    #if os(OSX)
    open override func loadView() {
        let responderView = ResponderView()
        view = responderView
    }
    #elseif os(tvOS) && targetEnvironment(simulator)
    open override func loadView() {
        let responderView = ResponderView()
        responderView.addGestureRecognizers()
        view = responderView
    }
    #else
    open override func loadView() {
        view = View()
    }
    #endif
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        #if os(iOS)
        inputMethodDidChangeObservation = NotificationCenter.default.addObserver(forName: .InputMethodDidChange, object: nil, queue: nil) { [weak self] _ in
            if Input.shared.inputMethod.isTouchesEnabled {
                self?.stopUpdates()
            } else {
                self?.startUpdatesIfNeeded()
            }
        }
        #endif
        
        displayLinkObserver.updateHandler = { [weak self] in
            guard let self = self else {
                return
            }
            
            guard self.isAnimatingInput == false else {
                return
            }
            
            self.currentTime = Date().timeIntervalSinceReferenceDate
            
            Input.shared.update()
            
            let navigationEvent = self.currentNavigationEvent()
            
            if let viewController = self.focusedChild?.owningViewController {
                viewController.update(currentTime: self.currentTime, navigationEvent: navigationEvent)
            } else {
                self.update(currentTime: self.currentTime, navigationEvent: navigationEvent)
            }
            
            Input.shared.reset()
        }
    }
    
    #if os(OSX)
    open override func viewDidAppear() {
        super.viewDidAppear()
        
        startUpdatesIfNeeded()
    }
    
    open override func viewWillDisappear() {
        super.viewWillDisappear()
        
        stopUpdates()
    }
    
    #else
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startUpdatesIfNeeded()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopUpdates()
    }
    #endif
    
    /// Called when an element is focused.
    /// Implementation of `super` does nothing.
    /// Don't call this method directly.
    open func didFocus(on element: NavigatableElement) { }
    
    /// Called when next page input is triggered while focused on a given child.
    /// Implementation of `super` does nothing.
    /// Don't call this method directly.
    open func didPerformNavigateToNextPage(focusedChild: NavigatableElement? = nil) { }
    
    /// Called when previous page input is triggered while focused on a given child.
    /// Implementation of `super` does nothing.
    /// Don't call this method directly.
    open func didPerformNavigateToPreviousPage(focusedChild: NavigatableElement? = nil) { }
    
    /// Called before selection a given child with animation after a select input is triggered.
    /// Implementation of `super` does nothing.
    /// Don't call this method directly.
    open func willSelect(focusedChild: NavigatableElement? = nil, context: Any? = nil) { }
    
    /// Called after selecting a given child after a select input is triggered.
    /// Implementation of `super` does nothing.
    /// Don't call this method directly.
    open func didSelect(focusedChild: NavigatableElement? = nil, context: Any? = nil) { }
    
    /// Called after a cancel input is triggered. Perform any animations in this method and
    /// call completion block at the end of the animation.
    /// Implementation of `super` only calls completion block.
    /// Don't call this method directly.
    open func animateCancel(completion: @escaping () -> Void) {
        completion()
    }
    
    // MARK: - Modal child
    
    /// Displays a child navigatable view controller modally on this view controller.
    /// Does nothing if the view controller already has a modal child.
    ///
    /// Add a non modal navigatable child view controller in a given container view.
    ///
    /// - Parameters:
    ///     - childViewController: Navigatable child view controller modally display
    /// in this view controller.
    ///     - containerView: A subview of this view controller's view to contain the
    /// modal child view controller.
    public func addNavigatableModalChild(_ childViewController: NavigatableViewController, in containerView: View) {
        guard modalChild == nil else {
            return
        }
        
        modalChild = childViewController
        stopUpdates()
        defocus()
        addChild(childViewController, in: containerView)
    }
    
    /// Stops displaying current modal child navigatable view controller on this view controller.
    public func removeNavigatableModalChild() {
        guard let lastModalChild = modalChild else {
            return
        }
        
        lastModalChild.removeFromParent()
        lastModalChild.view.removeFromSuperview()
        
        modalChild = nil
        
        startUpdatesIfNeeded()
    }
    
    /// Add a non modal navigatable child view controller in a given container view.
    ///
    /// - Parameters:
    ///     - childViewController: Navigatable child view controller to embed in this
    /// view controller.
    ///     - containerView: A subview of this view controller's view to contain the
    /// child view controller.
    ///     - parentElement: Optional parent navigatable element to contain the child
    /// view controller as a child navigatable. If `nil`, current view controller will
    /// become the parent navigatable element of the child view controller. Default
    /// value is `nil`.
    public func addNavigatableChild(_ childViewController: NavigatableViewController,
                                    in containerView: View,
                                    parentElement: NavigatableElement? = nil) {
        addChild(childViewController, in: containerView)
        if parentElement == nil {
            append(children: [childViewController])
        } else {
            parentElement?.append(children: [childViewController])
        }
    }
    
    /// Add a non modal navigatable child view controller with a given layout guide.
    ///
    /// - Parameters:
    ///     - childViewController: Navigatable child view controller to embed in this
    /// view controller.
    ///     - layoutGuide: A layout guide of this view controller's view to layout the
    /// child view controller.
    ///     - parentElement: Optional parent navigatable element to contain the child
    /// view controller as a child navigatable. If `nil`, current view controller will
    /// become the parent navigatable element of the child view controller. Default
    /// value is `nil`.
    public func addNavigatableChild(_ childViewController: NavigatableViewController,
                                    with layoutGuide: LayoutGuide,
                                    parentElement: NavigatableElement? = nil) {
        addChild(childViewController, with: layoutGuide)
        if parentElement == nil {
            append(children: [childViewController])
        } else {
            parentElement?.append(children: [childViewController])
        }
    }
    
    /// Remove a non modal navigatable child view controller from this view controller's
    /// embedded child view controllers.
    ///
    /// - Parameters:
    ///     - childViewController: Navigatable child view controller to remove.
    public func removeNavigatableChild(_ childViewController: NavigatableViewController) {
        if childViewController == modalChild {
            fatalError("A modal child should be removed with `removeNavigatableModalChild()`")
        }
        
        guard children.contains(childViewController) else {
            return
        }
        
        childViewController.removeFromParent()
        childViewController.view.removeFromSuperview()
        if childViewController.parentElement == nil {
            remove(children: [childViewController])
        } else {
            parentElement?.remove(children: [childViewController])
        }
        focus()
    }
    
    /// Focuses on a given element.
    public func focus(on element: NavigatableElement) {
        defocus()
        element.focus()
    }
    
    /// Performs a selection with the given child and context.
    public func performSelect(focusedChild: NavigatableElement? = nil, context: Any? = nil) {
        guard updatingViewController?.isAnimatingInput != true else {
            return
        }
        
        if let focusedChild = focusedChild {
            willSelect(focusedChild: focusedChild, context: context)
            updatingViewController?.isAnimatingInput = true
            focusedChild.animateSelect { [weak self] in
                self?.updatingViewController?.isAnimatingInput = false
                self?.didSelect(focusedChild: focusedChild, context: context)
                self?.selectHandler?(context)
            }
        } else {
            didSelect(context: context)
            selectHandler?(context)
        }
    }
    
    /// Performs a cancel with the given context.
    public func performCancel(context: Any? = nil) {
        updatingViewController?.isAnimatingInput = true
        animateCancel { [weak self] in
            self?.updatingViewController?.isAnimatingInput = false
            self?.cancelHandler?(context)
        }
    }
    
    // MARK: - Private
    
    private(set) var currentTime: TimeInterval = 0
    private var isAnimatingInput: Bool = false
    private let displayLinkObserver = DisplayLinkObserver()
    private var lastPressTimes: [String: TimeInterval] = [:]
    
    #if os(iOS)
    private var inputMethodDidChangeObservation: Any?
    #endif
    
    private func startUpdatesIfNeeded() {
        guard modalChild == nil else {
            return
        }
        
        #if os(iOS)
        if Input.shared.inputMethod.isTouchesEnabled {
            return
        }
        #endif
        
        guard parentElement == nil else {
            return
        }
        
        Input.shared.flushInputs()
        lastPressTimes = [:]
        #if os(OSX)
        NSApp.keyWindow?.makeFirstResponder(view)
        #endif
        displayLinkObserver.start()
        if let firstResponder = nestedFirstResponder {
            focus(on: firstResponder)
        }
    }
    
    private func stopUpdates() {
        displayLinkObserver.stop()
    }
    
    private func update(currentTime: TimeInterval, navigationEvent: NavigationEvent) {
        evaluateNavigationEvent(navigationEvent)
    }
    
    enum NavigationEvent: Equatable {
        case none
        case left
        case right
        case up
        case down
        case nextPage
        case previousPage
        case submit
        case cancel
    }
    
    private func currentNavigationEvent() -> NavigationEvent {
        if isInputProfilePressedOrHoldDown("MenuLeft") {
            lastPressTimes["MenuLeft"] = currentTime
            return .left
        } else if isInputProfilePressedOrHoldDown("MenuRight") {
            lastPressTimes["MenuRight"] = currentTime
            return .right
        } else if isInputProfilePressedOrHoldDown("MenuUp") {
            lastPressTimes["MenuUp"] = currentTime
            return .up
        } else if isInputProfilePressedOrHoldDown("MenuDown") {
            lastPressTimes["MenuDown"] = currentTime
            return .down
        } else if isInputProfilePressedOrHoldDown("MenuNextPage") {
            lastPressTimes["MenuNextPage"] = currentTime
            return .nextPage
        } else if isInputProfilePressedOrHoldDown("MenuPreviousPage") {
            lastPressTimes["MenuPreviousPage"] = currentTime
            return .previousPage
        } else if Input.shared.isButtonPressed("Submit") {
            return .submit
        } else if Input.shared.isButtonPressed("Cancel") {
            return .cancel
        }
        return .none
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    private func evaluateNavigationEvent(_ navigationEvent: NavigationEvent) {
        if let focusedChild = focusedChild, navigationEvent == .left {
            if let leftElement = focusedChild.nestedLeftElement() {
                focus(on: leftElement)
            }
        } else if let focusedChild = focusedChild, navigationEvent == .right {
            if let rightElement = focusedChild.nestedRightElement() {
                focus(on: rightElement)
            }
        } else if let focusedChild = focusedChild, navigationEvent == .up {
            if let upElement = focusedChild.nestedUpElement() {
                focus(on: upElement)
            }
        } else if let focusedChild = focusedChild, navigationEvent == .down {
            if let downElement = focusedChild.nestedDownElement() {
                focus(on: downElement)
            }
        } else if let focusedChild = focusedChild, navigationEvent == .nextPage {
            performNavigateToNextPage(focusedChild: focusedChild)
        } else if let focusedChild = focusedChild, navigationEvent == .previousPage {
            performNavigateToPreviousPage(focusedChild: focusedChild)
        } else if navigationEvent == .submit {
            performSelect(focusedChild: focusedChild)
        } else if navigationEvent == .cancel {
            performCancel()
        }
    }
    
    private func isInputProfilePressedOrHoldDown(_ inputProfile: String) -> Bool {
        if Input.shared.isButtonPressed(inputProfile) {
            return true
        }
        let result = Input.shared.isButtonHoldDown(inputProfile)
        guard let lastPressTime = lastPressTimes[inputProfile] else {
            return result
        }
        
        return result && currentTime - lastPressTime > 0.5
    }
    
    private func performNavigateToNextPage(focusedChild: NavigatableElement? = nil) {
        didPerformNavigateToNextPage()
    }
    
    private func performNavigateToPreviousPage(focusedChild: NavigatableElement? = nil) {
        didPerformNavigateToPreviousPage()
    }
    
    deinit {
        #if os(iOS)
        if let observation = inputMethodDidChangeObservation {
            NotificationCenter.default.removeObserver(observation)
        }
        #endif
    }
}
