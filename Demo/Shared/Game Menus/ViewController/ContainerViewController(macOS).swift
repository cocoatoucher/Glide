//
//  ContainerViewController.swift
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

import AppKit
import GameController
import GlideEngine

class ContainerView: NSView {
    // Cursor hiding
    var trackingArea: NSTrackingArea?
    
    override open func updateTrackingAreas() {
        if let trackingArea = trackingArea {
            self.removeTrackingArea(trackingArea)
        }
        let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .mouseMoved, .activeInKeyWindow]
        trackingArea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
        if let trackingArea = trackingArea {
            self.addTrackingArea(trackingArea)
        }
    }
    
    override open func mouseMoved(with event: NSEvent) {
        NSCursor.hide()
    }
}

class ContainerViewController: GCEventViewController {
    
    @IBOutlet weak var containerView: View?
    var contentViewController: NSViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentViewController = children.first
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        NSCursor.hide()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        contentViewController = children.first
        
        goToFullScreen()
    }
    
    func goToFullScreen() {
        guard let mainScreen = NSScreen.main else {
            return
        }
        
        var presentationOptions = NSApplication.PresentationOptions()
        presentationOptions.insert(.hideDock)
        presentationOptions.insert(.hideMenuBar)
        presentationOptions.insert(.disableAppleMenu)
        presentationOptions.insert(.disableProcessSwitching)
        presentationOptions.insert(.disableSessionTermination)
        presentationOptions.insert(.disableHideApplication)
        presentationOptions.insert(.autoHideToolbar)
        
        let optionsDictionary = [NSView.FullScreenModeOptionKey.fullScreenModeApplicationPresentationOptions: presentationOptions.rawValue]
        
        self.view.enterFullScreenMode(mainScreen, withOptions: optionsDictionary)
    }
    
    func placeContentViewController(_ viewController: NSViewController) {
        if let contentViewController = contentViewController {
            contentViewController.view.removeFromSuperview()
            contentViewController.removeFromParent()
        }
        
        if let containerView = containerView {
            self.contentViewController = viewController
            addChild(viewController, in: containerView)
        }
    }
    
}
