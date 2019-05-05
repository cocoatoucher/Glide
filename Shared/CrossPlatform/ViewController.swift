//
//  ViewController.swift
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
import AppKit.NSViewController
public typealias ViewControllerType = NSViewController
#else
import UIKit.UIViewController
public typealias ViewControllerType = UIViewController
#endif

extension ViewControllerType {
    public func addChild(_ childViewController: ViewControllerType, in containerView: View) {
        addChild(childViewController)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        childViewController.view.frame = containerView.bounds
        containerView.addSubview(childViewController.view)
        NSLayoutConstraint.activate([
            childViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            childViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            childViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            childViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
    }
    
    public func addChild(_ childViewController: ViewControllerType, with layoutGuide: LayoutGuide) {
        addChild(childViewController)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(childViewController.view)
        NSLayoutConstraint.activate([
            childViewController.view.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            childViewController.view.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            childViewController.view.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            childViewController.view.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)
            ])
    }
}
