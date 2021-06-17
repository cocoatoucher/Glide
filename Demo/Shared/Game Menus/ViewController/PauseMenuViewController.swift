//
//  PauseMenuViewController.swift
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

protocol PauseMenuViewControllerDelegate: AnyObject {
    func pauseMenuViewControllerDidSelectResume(_ pauseMenuViewController: PauseMenuViewController)
    func pauseMenuViewControllerDidSelectRestart(_ pauseMenuViewController: PauseMenuViewController)
    func pauseMenuViewControllerDidSelectMainMenu(_ pauseMenuViewController: PauseMenuViewController)
}

class PauseMenuViewController: NavigatableViewController {
    
    weak var delegate: PauseMenuViewControllerDelegate?
    
    lazy var logoImageView: ImageView = {
        let view = ImageView(image: Image(imageLiteralResourceName: "glide_logo_transparent"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var containerView: View = {
        let view = View()
        view.backgroundColor = Color.hudBackgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsLayer = true
        view.cornerRadius = 4.0
        view.clipsToBounds = true
        return view
    }()
    var buttonsContainerLayoutGuide: LayoutGuide = {
        let layoutGuide = LayoutGuide()
        return layoutGuide
    }()
    
    lazy var overlayView: OverlayView = {
        let view = OverlayView()
        view.autoresizingMask = [View.AutoresizingMask.flexibleWidth, View.AutoresizingMask.flexibleHeight]
        return view
    }()
    
    let displaysResume: Bool
    
    init(displaysResume: Bool) {
        self.displaysResume = displaysResume
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pause"
        
        setupViews()
        setupNavigationElements()
    }
    
    func setupViews() {
        overlayView.frame = view.bounds
        view.addSubview(overlayView)
        
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        
        view.addSubview(logoImageView)
        view.addLayoutGuide(buttonsContainerLayoutGuide)
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 128.0),
            logoImageView.heightAnchor.constraint(equalToConstant: 128.0),
            logoImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20.0),
            logoImageView.bottomAnchor.constraint(equalTo: buttonsContainerLayoutGuide.topAnchor),
            
            buttonsContainerLayoutGuide.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            buttonsContainerLayoutGuide.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            buttonsContainerLayoutGuide.topAnchor.constraint(equalTo: logoImageView.bottomAnchor),
            buttonsContainerLayoutGuide.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
    }
    
    func setupNavigationElements() {
        let buttonsViewController = NavigatablePopoverViewController()
        if displaysResume {
            buttonsViewController.addAction(contentView: PopoverActionButtonContentView(title: "Resume")) { [weak self] in
                guard let self = self else {
                    return
                }
                self.delegate?.pauseMenuViewControllerDidSelectResume(self)
            }
        }
        buttonsViewController.addAction(contentView: PopoverActionButtonContentView(title: "Restart")) { [weak self] in
            guard let self = self else {
                return
            }
            self.delegate?.pauseMenuViewControllerDidSelectRestart(self)
        }
        buttonsViewController.addAction(contentView: PopoverActionButtonContentView(title: "Main Menu")) { [weak self] in
            guard let self = self else {
                return
            }
            self.delegate?.pauseMenuViewControllerDidSelectMainMenu(self)
        }
        
        addNavigatableChild(buttonsViewController, with: buttonsContainerLayoutGuide)
        
        firstResponderChild = buttonsViewController
    }
}
