//
//  SingleLevelSectionViewController.swift
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

class SingleLevelSectionViewController: NavigatableViewController {
    
    let viewModel: SingleLevelSectionViewModel
    
    var containerLayoutGuide: LayoutGuide = {
        let layoutGuide = LayoutGuide()
        return layoutGuide
    }()
    
    lazy var backButton: NavigatableButton = {
        let button = NavigatableButton()
        button.contentView = ActionButtonContentView(title: "Back")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var negativeSideObserver: NSKeyValueObservation?
    lazy var negativeSideIndicatorView: PageIndicatorView = {
        let view = PageIndicatorView(direction: .left)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var positiveSideObserver: NSKeyValueObservation?
    lazy var positiveSideIndicatorView: PageIndicatorView = {
        let view = PageIndicatorView(direction: .right)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var levelInfoLabel: Label = {
        let label = Label()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.descriptionBodyTextFont(ofSize: descriptionBodyFontSize)
        label.textAlignment = .left
        label.maximumNumberOfLines = 1
        label.text = " "
        label.setContentHuggingPriority(LayoutConstraint.Priority.required, for: LayoutConstraint.Orientation.vertical)
        label.setContentCompressionResistancePriority(LayoutConstraint.Priority.required, for: LayoutConstraint.Orientation.vertical)
        return label
    }()
    
    lazy var levelScrollViewController: NavigatableButtonScrollViewController = {
        let levelScrollViewController = NavigatableButtonScrollViewController(orientation: .horizontal, buttons: sectionButtons, buttonSpacing: 20.0, numberOfButtonsPerPage: 4)
        return levelScrollViewController
    }()
    
    var sectionButtons: [NavigatableButton] {
        return viewModel.levelThumbViewModels.map { viewModel in
            let button = NavigatableButton(frame: .zero)
            let sectionView = LevelThumbView(viewModel: viewModel)
            button.contentView = sectionView
            return button
        }
    }
    
    var nextPageObservation: Any?
    var previousPageObservation: Any?
    
    init(viewModel: SingleLevelSectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Levels"
        
        setupViews()
        setupNavigationElements()
    }
    
    func setupViews() {
        (view as? View)?.backgroundColor = Color.hudBackgroundColor
        
        view.addSubview(backButton)
        view.addLayoutGuide(containerLayoutGuide)
        view.addSubview(negativeSideIndicatorView)
        view.addSubview(positiveSideIndicatorView)
        view.addSubview(levelInfoLabel)
        
        backButton.setContentCompressionResistancePriority(LayoutConstraint.Priority.required, for: LayoutConstraint.Orientation.vertical)
        
        NSLayoutConstraint.activate([
            negativeSideIndicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            negativeSideIndicatorView.topAnchor.constraint(equalTo: containerLayoutGuide.topAnchor),
            negativeSideIndicatorView.bottomAnchor.constraint(equalTo: containerLayoutGuide.bottomAnchor),
            negativeSideIndicatorView.widthAnchor.constraint(equalToConstant: 50.0),
            
            positiveSideIndicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            positiveSideIndicatorView.topAnchor.constraint(equalTo: containerLayoutGuide.topAnchor),
            positiveSideIndicatorView.bottomAnchor.constraint(equalTo: containerLayoutGuide.bottomAnchor),
            positiveSideIndicatorView.widthAnchor.constraint(equalToConstant: 50.0),
            
            backButton.topAnchor.constraint(equalTo: view.topAnchor),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerLayoutGuide.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10.0),
            containerLayoutGuide.leadingAnchor.constraint(equalTo: negativeSideIndicatorView.trailingAnchor),
            containerLayoutGuide.bottomAnchor.constraint(equalTo: levelInfoLabel.topAnchor, constant: -20.0),
            containerLayoutGuide.trailingAnchor.constraint(equalTo: positiveSideIndicatorView.leadingAnchor),
            
            levelInfoLabel.leadingAnchor.constraint(equalTo: negativeSideIndicatorView.trailingAnchor),
            levelInfoLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10.0)
            ])
        
        #if os(iOS)
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: 50.0)
            ])
        #endif
    }
    
    func setupNavigationElements() {
        levelScrollViewController.selectHandler = { [weak self, weak levelScrollViewController] _ in
            guard let self = self else {
                return
            }
            
            if let levelView = levelScrollViewController?.focusedButton?.contentView as? LevelThumbView {
                self.launchLevel(levelView.viewModel.level)
            }
        }
        
        append(children: [backButton])
        backButton.downElement = levelScrollViewController
        levelScrollViewController.upElement = backButton
        
        addNavigatableChild(levelScrollViewController, with: containerLayoutGuide)
        
        firstResponderChild = levelScrollViewController
        
        levelScrollViewController.cancelHandler = { [weak self] _ in
            self?.cancelAfterHighlightingBackButton()
        }
        
        negativeSideObserver = levelScrollViewController.observe(\.hasPagesOnNegativeSide, options: [.new]) { [weak self] (_, change) in
            self?.negativeSideIndicatorView.isAnimating = change.newValue == true
        }
        positiveSideObserver = levelScrollViewController.observe(\.hasPagesOnPositiveSide, options: [.new]) { [weak self] (_, change) in
            self?.positiveSideIndicatorView.isAnimating = change.newValue == true
        }
        
        negativeSideIndicatorView.isAnimating = levelScrollViewController.hasPagesOnNegativeSide == true
        positiveSideIndicatorView.isAnimating = levelScrollViewController.hasPagesOnPositiveSide == true
        
        nextPageObservation = NotificationCenter.default.addObserver(forName: .NavigatableButtonScrollViewDidScrollToNextPage, object: levelScrollViewController, queue: nil) { [weak self] _ in
            self?.positiveSideIndicatorView.animateSelect()
        }
        previousPageObservation = NotificationCenter.default.addObserver(forName: .NavigatableButtonScrollViewDidScrollToPreviousPage, object: levelScrollViewController, queue: nil) { [weak self] _ in
            self?.negativeSideIndicatorView.animateSelect()
        }
    }
    
    func launchLevel(_ level: Level) {
        let gameViewController = GameViewController(level: level)
        AppDelegate.shared.containerViewController?.placeContentViewController(gameViewController)
        gameViewController.startLevel(level)
    }
    
    override func didSelect(focusedChild: NavigatableElement?, context: Any?) {
        if focusedChild === backButton {
            self.cancelHandler?(nil)
        }
    }
    
    func cancelAfterHighlightingBackButton() {
        animateCancel { [weak self] in
            self?.cancelHandler?(nil)
        }
    }
    
    override func animateCancel(completion: @escaping () -> Void) {
        backButton.animateSelect {
            completion()
        }
    }
    
    override func didFocus(on element: NavigatableElement) {
        levelInfoLabel.text = " "
        
        if let levelButton = element as? NavigatableButton {
            if let index = levelScrollViewController.buttons.firstIndex(of: levelButton) {
                let levelViewModel = viewModel.levelThumbViewModels[index]
                levelInfoLabel.text = levelViewModel.levelInfo
            }
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
