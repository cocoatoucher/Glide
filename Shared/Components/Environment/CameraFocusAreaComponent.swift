//
//  CameraFocusAreaComponent.swift
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

import GameplayKit

/// Component that makes an entity trigger its scene's camera to zoom on a specified area
/// when contacted with other entities which have `CameraFocusAreaRecognizerComponent`.
public final class CameraFocusAreaComponent: GKComponent, GlideComponent {
    
    /// Frame of the zoom area that will be zoomed when this `CameraFocusAreaComponent`
    /// is triggered.
    public let zoomArea: TiledRect
    
    // MARK: - Initialize
    
    /// Create a camera focus area component.
    ///
    /// - Parameters:
    ///     - zoomArea: Frame of the zoom area that will be zoomed when this
    /// `CameraFocusAreaComponent` is triggered.
    public init(zoomArea: TiledRect) {
        self.zoomArea = zoomArea
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CameraFocusAreaComponent {
    public func handleNewContact(_ contact: Contact) {
        if contact.otherObject.colliderComponent?.entity?.component(ofType: CameraFocusAreaRecognizerComponent.self) != nil {
            scene?.focusCamera(onFrame: zoomArea)
        }
    }
    
    public func handleFinishedContact(_ contact: Contact) {
        if contact.otherObject.colliderComponent?.entity?.component(ofType: CameraFocusAreaRecognizerComponent.self) != nil {
            scene?.focusCamera(onFrame: nil)
        }
    }
}
