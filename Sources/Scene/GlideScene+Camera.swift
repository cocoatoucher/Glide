//
//  GlideScene+Camera.swift
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

import SpriteKit

extension GlideScene {
    
    /// Call this function to focus the camera on a specified area in the scene.
    /// Scale of the camera will be automatically arranged to fit the area in the camera.
    ///
    /// - Parameters:
    ///     - frame: Frame in the scene that the camera should focus in the next frame.
    /// Pass `nil` if the camera should no more focus on a frame.
    public func focusCamera(onFrame frame: TiledRect?) {
        if let frame = frame {
            cameraEntity.component(ofType: CameraComponent.self)?.focusFrame = frame.rect(with: tileSize)
        } else {
            cameraEntity.component(ofType: CameraComponent.self)?.focusFrame = nil
        }
    }
    
    /// Call this function to focus the camera on a specified area in the scene.
    /// Scale of the camera will be automatically arranged to fit the area in the camera.
    ///
    /// - Parameters:
    ///     - position: Position in the scene that the camera should focus in the next frame.
    /// Pass `nil` if the camera should no more focus on a frame.
    public func focusCamera(onPosition position: TiledPoint?) {
        if let position = position {
            cameraEntity.component(ofType: CameraComponent.self)?.focusPosition = position.point(with: tileSize)
        } else {
            cameraEntity.component(ofType: CameraComponent.self)?.focusPosition = nil
        }
    }
    
}
