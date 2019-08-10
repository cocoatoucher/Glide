//
//  GameViewController.swift
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

#if os(OSX)
import AppKit
#else
import UIKit
#endif
import GlideEngine
import SpriteKit
import GameController

/// Subclasses GCEventViewController in order to prevent Apple Remote menu button
/// to take the app to the background
class GameViewController: GCEventViewController {
    
    let level: Level
    var scene: BaseLevelScene?
    var overlayViewController: NavigatableViewController?
    
    init(level: Level) {
        self.level = level
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = SKView()
        #if os(iOS)
        self.view.isMultipleTouchEnabled = true
        #endif
    }
    
    #if os(OSX)
    override func viewWillAppear() {
        super.viewWillAppear()
        
        NSApp.keyWindow?.makeFirstResponder(self.view)
    }
    
    override func flagsChanged(with event: NSEvent) {
        self.scene?.flagsChanged(with: event)
    }
    #endif
    
    func startLevel(_ level: Level) {
        loadTextureAtlases(for: level)
    }
    
    // MARK: - Private
    
    private func loadTextureAtlases(for level: Level) {
        
        let decorationTilesAtlas = SKTextureAtlas(named: "Decoration Tiles Sprite Atlas")
        
        SKTextureAtlas.preloadTextureAtlases([decorationTilesAtlas]) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.displayLevel(decorationTilesAtlas: decorationTilesAtlas)
            }
        }
    }
    
    private func displayLevel(decorationTilesAtlas: SKTextureAtlas) {
        var tileMaps: SceneTileMaps
        if level.isSKS == true {
            let sks = SKScene(fileNamed: self.level.file)
            guard let collisionTileMap = sks?.childNode(withName: "CollidableGround") as? SKTileMapNode else {
                fatalError("Couldn't load the level file")
            }
            var decorationTileMaps: [SKTileMapNode] = []
            if let decorationTileMap = sks?.childNode(withName: "Decoration") as? SKTileMapNode {
                decorationTileMap.removeFromParent()
                decorationTileMaps.append(decorationTileMap)
            }
            collisionTileMap.removeFromParent()
            tileMaps = SceneTileMaps(collisionTileMap: collisionTileMap, decorationTileMaps: decorationTileMaps)
        } else {
            let loader = TiledMapEditorSceneLoader(fileName: self.level.file,
                                                   bundle: Bundle.main,
                                                   collisionTilesTextureAtlas: nil,
                                                   decorationTilesTextureAtlas: decorationTilesAtlas)
            guard let sceneTileMaps = loader.tileMaps else {
                fatalError("Couldn't load the level file \(self.level.file)")
            }
            tileMaps = sceneTileMaps
        }
        
        guard let view = self.view as? SKView else {
            return
        }
        
        guard let cls = NSClassFromString("Glide_Demo.\(self.level.scene)") as? BaseLevelScene.Type else {
            return
        }
        
        let baseLevelScene = cls.init(levelName: self.level.name, tileMaps: tileMaps)
        
        // Set the scale mode to scale to fit the window
        baseLevelScene.scaleMode = .resizeFill
        view.ignoresSiblingOrder = true
        
        // Present the scene
        view.presentScene(baseLevelScene)
        self.scene = baseLevelScene
        baseLevelScene.glideSceneDelegate = self
        
        #if DEBUG
        view.showsFPS = true
        view.showsNodeCount = true
        #endif
        
        #if os(OSX)
        NSApp.keyWindow?.makeFirstResponder(self.view)
        #endif
    }
    
    private func displayPauseMenu(on scene: GlideScene, displaysResume: Bool) {
        guard overlayViewController == nil else {
            return
        }
        
        let pauseViewController = PauseMenuViewController(displaysResume: displaysResume)
        self.overlayViewController = pauseViewController
        pauseViewController.delegate = self
        addChild(pauseViewController)
        pauseViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pauseViewController.view)
        NSLayoutConstraint.activate([
            pauseViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pauseViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pauseViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pauseViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        pauseViewController.cancelHandler = { [weak self] _ in
            self?.hidePauseMenu()
            scene.isPaused = false
        }
    }
    
    private func hidePauseMenu() {
        if let overlay = overlayViewController, overlay is PauseMenuViewController {
            overlay.view.removeFromSuperview()
            overlay.removeFromParent()
            self.overlayViewController = nil
        }
    }
}

extension GameViewController: GlideSceneDelegate {
    
    func glideScene(_ scene: GlideScene, didChangePaused paused: Bool) {
        if paused {
            displayPauseMenu(on: scene, displaysResume: true)
        } else {
            hidePauseMenu()
        }
    }
    
    func glideSceneDidEnd(_ scene: GlideScene, reason: GlideScene.EndReason?, context: [String: Any]?) {
        scene.isPaused = true
        displayPauseMenu(on: scene, displaysResume: false)
    }
    
    func removeOverlay() {
        overlayViewController?.removeFromParent()
        overlayViewController?.view.removeFromSuperview()
        overlayViewController = nil
    }
}

extension GameViewController: PauseMenuViewControllerDelegate {
    func pauseMenuViewControllerDidSelectResume(_ pauseMenuViewController: PauseMenuViewController) {
        removeOverlay()
        
        scene?.isPaused = false
    }
    
    func pauseMenuViewControllerDidSelectRestart(_ pauseMenuViewController: PauseMenuViewController) {
        removeOverlay()
        
        loadTextureAtlases(for: level)
    }
    
    func pauseMenuViewControllerDidSelectMainMenu(_ pauseMenuViewController: PauseMenuViewController) {

        let viewModel = LevelSectionsViewModel()
        let levelSectionsViewController = LevelSectionsViewController(viewModel: viewModel)
        AppDelegate.shared.containerViewController?.placeContentViewController(levelSectionsViewController)
    }
}
