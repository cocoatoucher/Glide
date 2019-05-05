//
//  ResponderView.swift
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
import Foundation
#else
import UIKit
#endif

public class ResponderView: View {
    #if os(OSX)
    public override func keyDown(with event: NSEvent) {
        InputResponder.keyDown(with: event)
    }
    
    public override func keyUp(with event: NSEvent) {
        InputResponder.keyUp(with: event)
    }
    
    open override func flagsChanged(with event: NSEvent) {
        InputResponder.flagsChanged(with: event)
    }
    
    open override func mouseDown(with event: NSEvent) {
        InputResponder.mouseDown(with: event)
    }
    
    open override func mouseUp(with event: NSEvent) {
        InputResponder.mouseUp(with: event)
    }
    
    public override var canBecomeKeyView: Bool {
        return true
    }
    #elseif os(tvOS) && targetEnvironment(simulator)
    func addGestureRecognizers() {
        
        let playPauseTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedPlayPause(recognizer:)))
        playPauseTapRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.playPause.rawValue)]
        addGestureRecognizer(playPauseTapRecognizer)
        
        let menuTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedMenu(recognizer:)))
        menuTapRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        addGestureRecognizer(menuTapRecognizer)
        
        let selectTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedSelect(recognizer:)))
        selectTapRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.select.rawValue)]
        addGestureRecognizer(selectTapRecognizer)
        
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedRight(recognizer:)))
        swipeRightRecognizer.direction = .right
        addGestureRecognizer(swipeRightRecognizer)
        
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedLeft(recognizer:)))
        swipeLeftRecognizer.direction = .left
        addGestureRecognizer(swipeLeftRecognizer)
        
        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedUp(recognizer:)))
        swipeUpRecognizer.direction = .up
        addGestureRecognizer(swipeUpRecognizer)
        
        let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedDown(recognizer:)))
        swipeDownRecognizer.direction = .down
        addGestureRecognizer(swipeDownRecognizer)
    }
    
    @objc func tappedPlayPause(recognizer: UITapGestureRecognizer) {
        Input.shared.addKey(KeyCode.controller1ButtonA, removeAtNextUpdate: true)
    }
    
    @objc func tappedMenu(recognizer: UITapGestureRecognizer) {
        Input.shared.addKey(KeyCode.controller1Menu, removeAtNextUpdate: true)
    }
    
    @objc func tappedSelect(recognizer: UITapGestureRecognizer) {
        Input.shared.addKey(KeyCode.controller1ButtonA, removeAtNextUpdate: true)
    }
    
    @objc func swipedRight(recognizer: UISwipeGestureRecognizer) {
        Input.shared.addKey(KeyCode.controller1DpadRight, removeAtNextUpdate: true)
    }
    
    @objc func swipedLeft(recognizer: UISwipeGestureRecognizer) {
        Input.shared.addKey(KeyCode.controller1DpadLeft, removeAtNextUpdate: true)
    }
    
    @objc func swipedUp(recognizer: UISwipeGestureRecognizer) {
        Input.shared.addKey(KeyCode.controller1DpadUp, removeAtNextUpdate: true)
    }
    
    @objc func swipedDown(recognizer: UISwipeGestureRecognizer) {
        Input.shared.addKey(KeyCode.controller1DpadDown, removeAtNextUpdate: true)
    }
    #endif
}
