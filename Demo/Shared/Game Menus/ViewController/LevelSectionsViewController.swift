//
//  LevelSectionsViewController.swift
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

class LevelSectionsViewController: NavigatableViewController {
    
    let viewModel: LevelSectionsViewModel
    
    lazy var logoLayoutGuide: LayoutGuide = {
        return LayoutGuide()
    }()
    lazy var accessoriesLayoutGuide: LayoutGuide = {
        return LayoutGuide()
    }()
    var sectionsLayoutGuide = LayoutGuide()
    
    lazy var modalContainerView: View = {
        let view = View()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsLayer = true
        view.cornerRadius = 4.0
        view.clipsToBounds = true
        return view
    }()
    
    private var negativeSideObserver: NSKeyValueObservation?
    lazy var negativeSideIndicatorView: PageIndicatorView = {
        let view = PageIndicatorView(direction: .up)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var positiveSideObserver: NSKeyValueObservation?
    lazy var positiveSideIndicatorView: PageIndicatorView = {
        let view = PageIndicatorView(direction: .down)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var overlayView: OverlayView = {
        let view = OverlayView()
        view.autoresizingMask = [View.AutoresizingMask.flexibleWidth, View.AutoresizingMask.flexibleHeight]
        return view
    }()
    
    lazy var logoImageView: ImageView = {
        let view = ImageView(image: Image(imageLiteralResourceName: "glide_logo_transparent"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var sectionInfoLabel: Label = {
        let label = Label()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.descriptionBodyTextFont(ofSize: descriptionBodyFontSize)
        label.textAlignment = .right
        return label
    }()
    
    lazy var sectionsScrollViewController: NavigatableButtonScrollViewController = {
        let viewController = NavigatableButtonScrollViewController(orientation: .vertical, buttons: sectionButtons, buttonSpacing: 20.0, numberOfButtonsPerPage: 5)
        return viewController
    }()
    
    lazy var creditsButton: NavigatableButton = {
        let button = NavigatableButton(frame: .zero)
        button.contentView = ActionButtonContentView(title: "Credits")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var quitGameButton: NavigatableButton = {
        let button = NavigatableButton(frame: .zero)
        button.contentView = ActionButtonContentView(title: "Quit game")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var sectionButtons: [NavigatableButton] {
        return viewModel.sectionViewModels.map { viewModel in
            let button = NavigatableButton(frame: .zero)
            let sectionView = LevelSectionView(viewModel: viewModel)
            button.contentView = sectionView
            return button
        }
    }
    
    var nextPageObservation: Any?
    var previousPageObservation: Any?
    
    init(viewModel: LevelSectionsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sections"
        
        setupViews()
        setupNavigationElements()
    }
    
    func setupViews() {
        guard let universalView = view as? View else {
            return
        }
        universalView.backgroundColor = Color.mainBackgroundColor
        
        view.addLayoutGuide(logoLayoutGuide)
        view.addSubview(logoImageView)
        
        view.addLayoutGuide(sectionsLayoutGuide)
        view.addSubview(negativeSideIndicatorView)
        view.addSubview(positiveSideIndicatorView)
        
        view.addLayoutGuide(accessoriesLayoutGuide)
        view.addSubview(sectionInfoLabel)
        view.addSubview(creditsButton)
        #if os(OSX)
        view.addSubview(quitGameButton)
        #endif
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        guard let universalView = view as? View else {
            return
        }
        
        NSLayoutConstraint.activate([
            logoLayoutGuide.topAnchor.constraint(equalTo: universalView.safeAreaTopAnchor),
            logoLayoutGuide.leadingAnchor.constraint(equalTo: universalView.safeAreaLeadingAnchor),
            logoLayoutGuide.trailingAnchor.constraint(equalTo: sectionsLayoutGuide.leadingAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 256.0),
            logoImageView.heightAnchor.constraint(equalToConstant: 256.0),
            logoImageView.centerXAnchor.constraint(equalTo: logoLayoutGuide.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: logoLayoutGuide.centerYAnchor),
            
            accessoriesLayoutGuide.topAnchor.constraint(equalTo: logoLayoutGuide.bottomAnchor),
            accessoriesLayoutGuide.leadingAnchor.constraint(equalTo: universalView.safeAreaLeadingAnchor, constant: 20.0),
            accessoriesLayoutGuide.trailingAnchor.constraint(equalTo: sectionsLayoutGuide.leadingAnchor, constant: -20.0),
            accessoriesLayoutGuide.heightAnchor.constraint(equalTo: universalView.safeAreaHeightAnchor, multiplier: 0.2),
            accessoriesLayoutGuide.bottomAnchor.constraint(equalTo: universalView.safeAreaBottomAnchor
            ),
            
            sectionInfoLabel.trailingAnchor.constraint(equalTo: accessoriesLayoutGuide.trailingAnchor),
            sectionInfoLabel.leadingAnchor.constraint(greaterThanOrEqualTo: accessoriesLayoutGuide.leadingAnchor),
            sectionInfoLabel.bottomAnchor.constraint(equalTo: accessoriesLayoutGuide.bottomAnchor, constant: -20.0),
            
            creditsButton.centerXAnchor.constraint(equalTo: logoImageView.centerXAnchor),
            creditsButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: -20.0)
            ])
        #if os(OSX)
        NSLayoutConstraint.activate([
            quitGameButton.centerXAnchor.constraint(equalTo: creditsButton.centerXAnchor),
            quitGameButton.topAnchor.constraint(equalTo: creditsButton.bottomAnchor, constant: 20.0)
            ])
        #endif
        
        NSLayoutConstraint.activate([
            negativeSideIndicatorView.leadingAnchor.constraint(equalTo: sectionsLayoutGuide.leadingAnchor),
            negativeSideIndicatorView.topAnchor.constraint(equalTo: universalView.safeAreaTopAnchor),
            negativeSideIndicatorView.trailingAnchor.constraint(equalTo: sectionsLayoutGuide.trailingAnchor),
            negativeSideIndicatorView.heightAnchor.constraint(equalToConstant: 50.0),
            sectionsLayoutGuide.topAnchor.constraint(equalTo: negativeSideIndicatorView.bottomAnchor),
            sectionsLayoutGuide.trailingAnchor.constraint(equalTo: universalView.safeAreaTrailingAnchor),
            sectionsLayoutGuide.widthAnchor.constraint(equalTo: universalView.safeAreaWidthAnchor, multiplier: 0.5),
            positiveSideIndicatorView.topAnchor.constraint(equalTo: sectionsLayoutGuide.bottomAnchor),
            positiveSideIndicatorView.leadingAnchor.constraint(equalTo: sectionsLayoutGuide.leadingAnchor),
            positiveSideIndicatorView.trailingAnchor.constraint(equalTo: sectionsLayoutGuide.trailingAnchor),
            positiveSideIndicatorView.bottomAnchor.constraint(equalTo: universalView.safeAreaBottomAnchor),
            positiveSideIndicatorView.heightAnchor.constraint(equalToConstant: 50.0)
            ])
    }
    
    func setupNavigationElements() {
        sectionsScrollViewController.selectHandler = { [weak self, weak sectionsScrollViewController] _ in
            
            guard let self = self else {
                return
            }
            
            if let focusedButton = sectionsScrollViewController?.focusedButton {
                if let sectionView = focusedButton.contentView as? LevelSectionView {
                    self.displayLevels(sectionView.viewModel, fromButton: focusedButton)
                }
            }
        }
        
        addNavigatableChild(sectionsScrollViewController, with: sectionsLayoutGuide)
        
        negativeSideObserver = sectionsScrollViewController.observe(\.hasPagesOnNegativeSide, options: [.new]) { [weak self] (_, change) in
            self?.negativeSideIndicatorView.isAnimating = change.newValue == true
        }
        positiveSideObserver = sectionsScrollViewController.observe(\.hasPagesOnPositiveSide, options: [.new]) { [weak self] (_, change) in
            self?.positiveSideIndicatorView.isAnimating = change.newValue == true
        }
        
        negativeSideIndicatorView.isAnimating = sectionsScrollViewController.hasPagesOnNegativeSide == true
        positiveSideIndicatorView.isAnimating = sectionsScrollViewController.hasPagesOnPositiveSide == true
        
        nextPageObservation = NotificationCenter.default.addObserver(forName: .NavigatableButtonScrollViewDidScrollToNextPage, object: sectionsScrollViewController, queue: nil) { [weak self] _ in
            self?.positiveSideIndicatorView.animateSelect()
        }
        previousPageObservation = NotificationCenter.default.addObserver(forName: .NavigatableButtonScrollViewDidScrollToPreviousPage,
                                                                         object: sectionsScrollViewController,
                                                                         queue: nil) { [weak self] _ in
                                                                            self?.negativeSideIndicatorView.animateSelect()
        }
        
        #if os(OSX)
        append(children: [creditsButton, quitGameButton])
        #else
        append(children: [creditsButton])
        #endif
        
        creditsButton.rightElement = sectionsScrollViewController
        sectionsScrollViewController.leftElement = creditsButton
        
        #if os(OSX)
        quitGameButton.rightElement = sectionsScrollViewController
        creditsButton.downElement = quitGameButton
        quitGameButton.upElement = creditsButton
        #endif
    }
    
    func displayLevels(_ sectionViewModel: SingleLevelSectionViewModel, fromButton: NavigatableButton) {
        view.addSubview(modalContainerView)
        NSLayoutConstraint.activate([
            modalContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modalContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            modalContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            modalContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
            ])
        let viewController = SingleLevelSectionViewController(viewModel: sectionViewModel)
        viewController.cancelHandler = { [weak self] _ in
            guard let self = self else { return }
            self.hideLevels()
        }
        
        displayOverlay()
        addNavigatableModalChild(viewController, in: modalContainerView)
    }
    
    func hideLevels() {
        hideOverlay()
        modalContainerView.removeFromSuperview()
        removeNavigatableModalChild()
    }
    
    func displayOverlay() {
        overlayView.frame = view.bounds
        view.addSubview(overlayView)
        (view as? View)?.bringSubviewToFront(modalContainerView)
    }
    
    func hideOverlay() {
        overlayView.removeFromSuperview()
    }
    
    override func didFocus(on element: NavigatableElement) {
        sectionInfoLabel.text = nil
        
        if let sectionButton = element as? NavigatableButton {
            if let index = sectionsScrollViewController.buttons.firstIndex(of: sectionButton) {
                let sectionViewModel = viewModel.sectionViewModels[index]
                sectionInfoLabel.text = sectionViewModel.section.info
            }
        }
    }
    
    override func didSelect(focusedChild: NavigatableElement?, context: Any?) {
        if focusedChild === creditsButton {
            let creditsViewController = CreditsViewController()
            AppDelegate.shared.containerViewController?.placeContentViewController(creditsViewController)
        } else if focusedChild === quitGameButton {
            #if os(OSX)
            NSApp.terminate(self)
            #endif
        }
    }
    
    deinit {
        if let observation = nextPageObservation {
            NotificationCenter.default.removeObserver(observation)
        }
        if let observation = previousPageObservation {
            NotificationCenter.default.removeObserver(observation)
        }
    }
}
