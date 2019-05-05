//
//  LevelSectionView.swift
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

class LevelSectionView: SelectionButtonContentView {
    
    let viewModel: SingleLevelSectionViewModel
    let label = Label()
    let imageView = ImageView()
    
    init(viewModel: SingleLevelSectionViewModel) {
        self.viewModel = viewModel
        super.init(normalBackgroundColor: .clear)
        
        label.text = viewModel.section.name
        label.maximumNumberOfLines = 1
        #if os(iOS)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.3
        #endif
        label.font = Font.headerTextFont(ofSize: menuHeaderFontSize)
        label.textColor = Color.defaultTextColor
        imageView.image = Image(imageLiteralResourceName: "star")
        
        imageView.setContentCompressionResistancePriority(LayoutConstraint.Priority.required, for: LayoutConstraint.Orientation.horizontal)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 10.0),
            imageView.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
            imageView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaGuide.topAnchor),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaGuide.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10.0),
            label.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: safeAreaGuide.trailingAnchor, constant: -10)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
