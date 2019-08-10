//
//  LevelThumbView.swift
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

import SpriteKit
import GlideEngine
#if os(OSX)
import AppKit
#else
import UIKit
#endif

class LevelThumbView: SelectionButtonContentView {
    
    let viewModel: LevelThumbViewModel
    let label = Label()
    let imageView = ImageView()
    
    init(viewModel: LevelThumbViewModel) {
        self.viewModel = viewModel
        super.init(normalBackgroundColor: Color.levelThumbBackgroundColor)
        
        imageView.image = Image(named: "level_thumb")
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        label.setContentHuggingPriority(LayoutConstraint.Priority.defaultLow, for: LayoutConstraint.Orientation.vertical)
        label.setContentHuggingPriority(LayoutConstraint.Priority.defaultLow, for: LayoutConstraint.Orientation.horizontal)
        label.setContentCompressionResistancePriority(LayoutConstraint.Priority.defaultLow, for: LayoutConstraint.Orientation.vertical)
        label.setContentCompressionResistancePriority(LayoutConstraint.Priority.defaultLow, for: LayoutConstraint.Orientation.horizontal)
        
        #if !os(OSX)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.clipsToBounds = true
        #endif
        imageView.setContentHuggingPriority(LayoutConstraint.Priority.defaultLow, for: LayoutConstraint.Orientation.vertical)
        imageView.setContentHuggingPriority(LayoutConstraint.Priority.defaultLow, for: LayoutConstraint.Orientation.horizontal)
        imageView.setContentCompressionResistancePriority(LayoutConstraint.Priority.defaultLow, for: LayoutConstraint.Orientation.vertical)
        imageView.setContentCompressionResistancePriority(LayoutConstraint.Priority.defaultLow, for: LayoutConstraint.Orientation.horizontal)
        
        label.text = viewModel.levelName
        #if os(iOS)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.3
        #endif
        label.font = Font.subheaderTextFont(ofSize: levelTitleFontSize)
        label.textColor = Color.defaultTextColor
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.maximumNumberOfLines = 0
        addSubview(label)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 5.0),
            imageView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: safeAreaGuide.heightAnchor, multiplier: 0.6),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            label.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -5.0),
            label.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 5.0),
            label.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -5.0)
            ])
    }
}
