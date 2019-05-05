//
//  DebuggableComponent.swift
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

/// When adopted, an entity can manage its debug elements(e.g. debug nodes)
/// in a more structured way.
/// Note that functionality related to this component is only enabled if `DEBUG`
/// flag is on during compile time.
public protocol DebuggableComponent {
    
    /// `true` if the debug mode is enabled for the type of the component.
    static var isDebugEnabled: Bool { get set }
    
    /// `true` if the debug mode is enabled for this component.
    /// Debug mode might have been enabled for the component even when this
    /// value is `false`, because debug mode can be enabled for the type of
    /// the component as well.
    var isDebugEnabled: Bool { get set }
    
    /// Called in the update loop to update properties of the debug elements.
    /// This can be positions of your debug nodes if there are any.
    /// This is also the place to set the parent of your debug nodes
    /// if they don't have an existing parent.
    /// Don't call this method directly.
    func updateDebugElements()
    
    /// This is the place where the debug elements should be cleaned up.
    /// For example your debug nodes should be removed from their parents.
    /// Don't call this method directly.
    func cleanDebugElements()
}

extension DebuggableComponent {
    
    /// `true` if the debug elements should be updated for this component.
    public var shouldUpdateDebugElements: Bool {
        return isDebugEnabled || type(of: self).isDebugEnabled
    }
    
    /// Convenience for creating a distinct name for debug nodes.
    ///
    /// - Parameters:
    ///     - suffix: Suffix to append to the name of the debug element.
    public func debugElementName(with suffix: String) -> String {
        return "\(debugElementNamePrefix).\(suffix)"
    }
    
    // MARK: - Internal
    
    /// Convenience for creating a distinct name for debug nodes.
    var debugElementNamePrefix: String {
        return "\(type(of: self)).debug"
    }
}
