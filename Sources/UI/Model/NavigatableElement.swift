//
//  NavigatableElement.swift
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

import Foundation

/// Protocol to adopt for custom navigatable view classes.
public protocol NavigatableElement: class {
    /// Navigatable sibling element that's positioned above this element.
    var upElement: NavigatableElement? { get set }
    /// Navigatable sibling element that's positioned below this element.
    var downElement: NavigatableElement? { get set }
    /// Navigatable sibling element that's positioned on the left side this element.
    var leftElement: NavigatableElement? { get set }
    /// Navigatable sibling element that's positioned on the right side this element.
    var rightElement: NavigatableElement? { get set }
    
    /// Navigatable element that references this element as a child.
    var parentElement: NavigatableElement? { get set }
    /// Child element that responds first to focus events for this element.
    var firstResponderChild: NavigatableElement? { get set }
    /// Child elements of this element.
    var childElements: [NavigatableElement] { get set }
    
    /// `true` if the element should be in focused state. Use this flag
    /// to visually update your custom views which adopt this protocol.
    var isFocusedElement: Bool { get set }
    
    /// Implement this method to perform selection of the element in an
    /// animated way. `completion` block should be called at the end of
    /// the animations or immediately if there are no animations.
    /// Don't call this method directly.
    func animateSelect(completion: @escaping () -> Void)
}

extension NavigatableElement {
    
    /// Returns sibling element positioned above this element found via
    /// recursively looking up all the way through parent elements' siblings
    /// until a matching sibling is found.
    func nestedUpElement() -> NavigatableElement? {
        if let upElement = upElement {
            return upElement
        }
        return parentElement?.nestedUpElement()
    }
    
    /// Returns sibling element positioned below this element found via
    /// recursively looking up all the way through parent elements' siblings
    /// until a matching sibling is found.
    func nestedDownElement() -> NavigatableElement? {
        if let downElement = downElement {
            return downElement
        }
        return parentElement?.nestedDownElement()
    }
    
    /// Returns sibling element positioned on the left of this element found
    /// via recursively looking up all the way through parent elements siblings
    /// until a matching sibling is found.
    func nestedLeftElement() -> NavigatableElement? {
        if let leftElement = leftElement {
            return leftElement
        }
        return parentElement?.nestedLeftElement()
    }
    
    /// Returns sibling element positioned on the right of this element found
    /// via recursively looking up all the way through parent elements siblings
    /// until a matching sibling is found.
    func nestedRightElement() -> NavigatableElement? {
        if let rightElement = rightElement {
            return rightElement
        }
        return parentElement?.nestedRightElement()
    }
    
    public func animateSelect(completion: @escaping () -> Void) {
    }
    
    /// Returns currently focused child found via recursively looking up children
    /// and their children.
    public var focusedChild: NavigatableElement? {
        for child in childElements {
            if child.isFocusedElement {
                return child
            }
            if let focusedInChildren = child.focusedChild {
                return focusedInChildren
            }
        }
        return nil
    }
    
    /// First navigatable parent that is a `NavigatableViewController` and doesn't have
    /// a parent element. That is recursively looked up through parent hierarchy.
    /// Updating view controller is the one which receives input events and updates
    /// its focused child view controller for these events.
    public var updatingViewController: NavigatableViewController? {
        if let selfAsViewNavigatableViewController = self as? NavigatableViewController, parentElement == nil {
            return selfAsViewNavigatableViewController
        }
        return parentElement?.updatingViewController
    }
    
    /// First navigatable parent that is a `NavigatableViewController` recursively looked up.
    public var owningViewController: NavigatableViewController? {
        if let selfAsViewNavigatableViewController = self as? NavigatableViewController {
            return selfAsViewNavigatableViewController
        }
        return parentElement?.owningViewController
    }
    
    /// Focuses on the first responder child. That method is recursively called all the way
    /// down the child hierarchy.
    public func focus() {
        let firstResponder = nestedFirstResponder
        if self === firstResponder {
            isFocusedElement = true
            
            var parentViewController = owningViewController
            parentViewController?.didFocus(on: self)
            while let parent = parentViewController, parentViewController != nil {
                parentViewController = parent.parentElement?.owningViewController
                parent.didFocus(on: self)
            }
            
            // Update first responder of the parent on each focus.
            var parent = parentElement
            parent?.firstResponderChild = self
            while let currentParent = parent {
                currentParent.parentElement?.firstResponderChild = currentParent
                parent = currentParent.parentElement
            }
        } else {
            firstResponder?.focus()
        }
    }
    
    /// Stop focusing on this element or the focused element in child hierarchy that is
    /// recursively found.
    public func defocus() {
        isFocusedElement = false
        for child in childElements {
            child.defocus()
        }
    }
    
    /// Adds new elements to the children list of this element.
    public func append(children: [NavigatableElement]) {
        childElements.append(contentsOf: children)
        children.forEach { $0.parentElement = self }
    }
    
    /// Removes all children of this element.
    public func removeAllChildren() {
        childElements.forEach { $0.parentElement = nil }
        childElements = []
    }
    
    /// Removes given children from this element's children list.
    public func remove(children: [NavigatableElement]) {
        var didRemoveFocusedChild: Bool = false
        children.forEach { child in
            if let index = childElements.firstIndex(where: { $0 === child }) {
                if child === focusedChild {
                    didRemoveFocusedChild = true
                }
                childElements.remove(at: index)
            }
        }
        children.forEach { $0.parentElement = nil }
        if didRemoveFocusedChild {
            firstResponderChild = children.first
        }
    }
    
    /// First found first responder for this entity recursively found among
    /// children hierarchy.
    public var nestedFirstResponder: NavigatableElement? {
        if let firstResponderChild = firstResponderChild {
            return firstResponderChild.nestedFirstResponder
        }
        if let firstChild = childElements.first {
            return firstChild.nestedFirstResponder
        }
        return self
    }
}
