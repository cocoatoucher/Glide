//
//  DisplayLinkObserver.swift
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
import QuartzCore

#if os(OSX)
private func displayLinkCallback(displayLink: CVDisplayLink,
                                 _ now: UnsafePointer<CVTimeStamp>,
                                 _ outputTime: UnsafePointer<CVTimeStamp>,
                                 _ flagsIn: CVOptionFlags,
                                 _ flagsOut: UnsafeMutablePointer<CVOptionFlags>,
                                 _ displayLinkContext: UnsafeMutableRawPointer?) -> CVReturn {
    unsafeBitCast(displayLinkContext, to: DisplayLinkObserver.self).update()
    return kCVReturnSuccess
}
#endif

class DisplayLinkObserver {
    var updateHandler: () -> Void = {}
    #if os(OSX)
    private var displayLink: CVDisplayLink?
    #else
    private var displayLink: CADisplayLink?
    #endif
    
    func start() {
        #if os(OSX)
        CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
        
        guard let displayLink = displayLink else {
            return
        }
        
        let opaqueSelf = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        CVDisplayLinkSetOutputCallback(displayLink, displayLinkCallback, opaqueSelf)
        CVDisplayLinkStart(displayLink)
        #else
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink?.add(to: .main, forMode: .common)
        #endif
    }
    
    func stop() {
        guard let displayLink = displayLink else {
            return
        }
        
        #if os(OSX)
        CVDisplayLinkStop(displayLink)
        self.displayLink = nil
        #else
        displayLink.remove(from: .main, forMode: .common)
        self.displayLink = nil
        #endif
    }
    
    @objc func update() {
        #if os(OSX)
        DispatchQueue.main.async(execute: updateHandler)
        #else
        updateHandler()
        #endif
    }
    
    deinit {
        guard let displayLink = displayLink else { return }
        #if os(OSX)
        CVDisplayLinkStop(displayLink)
        #else
        displayLink.remove(from: .main, forMode: .common)
        #endif
    }
}
