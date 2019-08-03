//
//  CreditsViewController.swift
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

import GlideEngine
#if os(OSX)
import AppKit
#else
import UIKit
#endif

class CreditsViewController: NavigatableViewController {
    
    lazy var backButton: NavigatableButton = {
        let button = NavigatableButton()
        button.contentView = ActionButtonContentView(title: "Back")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var label: Label = {
        let label = Label()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.maximumNumberOfLines = 0
        label.font = Font.headerTextFont(ofSize: menuHeaderFontSize)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let universalView = view as? View else {
            return
        }
        
        universalView.backgroundColor = Color.mainBackgroundColor
        label.text =
        """
        Just an example navigation screen...
        cocoatoucher
        © 2019
        """
        
        view.addSubview(label)
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: universalView.safeAreaCenterXAnchor),
            label.centerYAnchor.constraint(equalTo: universalView.safeAreaCenterYAnchor),
            backButton.trailingAnchor.constraint(equalTo: universalView.safeAreaTrailingAnchor, constant: -20.0),
            backButton.topAnchor.constraint(equalTo: universalView.safeAreaTopAnchor, constant: 20.0)
            ])
        
        append(children: [backButton])
        
        cancelHandler = { [weak self] context in
            self?.handleCancel()
        }
    }
    
    override func didSelect(focusedChild: NavigatableElement?, context: Any?) {
        if focusedChild === backButton {
            handleCancel()
        }
    }
    
    private func handleCancel() {
        let viewModel = LevelSectionsViewModel()
        let mainMenu = LevelSectionsViewController(viewModel: viewModel)
        AppDelegate.shared.containerViewController?.placeContentViewController(mainMenu)
    }
    
    override func animateCancel(completion: @escaping () -> Void) {
        backButton.animateSelect {
            completion()
        }
    }
}
