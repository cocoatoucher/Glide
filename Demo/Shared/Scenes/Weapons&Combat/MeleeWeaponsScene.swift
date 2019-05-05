//
//  MeleeWeaponsScene.swift
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
import GameplayKit

class MeleeWeaponsScene: BaseLevelScene {
    
    override func setupScene() {
        super.setupScene()
        
        #if os(iOS)
        let touchButtonComponent = additionalTouchButtonEntity.component(ofType: TouchButtonComponent.self)
        touchButtonComponent?.input = .profiles([(name: "Player1_Shoot", isNegative: false)])
        touchButtonComponent?.normalTexture = SKTexture(nearestFilteredImageName: "touchbutton_shoot")
        touchButtonComponent?.highlightedTexture = SKTexture(nearestFilteredImageName: "touchbutton_shoot_hl")
        shouldDisplayAdditionalTouchButton = true
        #elseif os(tvOS)
        Input.shared.removeInputProfilesNamed("Player1_Shoot")
        let player1ShootProfile = InputProfile(name: "Player1_Shoot") { profile in
            profile.positiveKeys = [.e, .mouse0, .controller1ButtonX, .controller1ButtonY]
        }
        Input.shared.addInputProfile(player1ShootProfile)
        #endif
        
        mapContact(between: DemoCategoryMask.crate, and: DemoCategoryMask.weapon)
        
        addEntity(crateEntity(at: TiledPoint(13, 10)))
        addEntity(crateEntity(at: TiledPoint(16, 10)))
        addEntity(crateEntity(at: TiledPoint(19, 10)))
        addEntity(crateEntity(at: TiledPoint(22, 10)))
        
        addEntity(playerEntity)
        
        addEntity(weaponEntity)
        weaponEntity.transform.parentTransform = playerEntity.transform
        
        setupTips()
    }
    
    lazy var playerEntity: GlideEntity = {
        let entity = SimplePlayerEntity(initialNodePosition: defaultPlayerStartLocation, playerIndex: 0)

        let attackingPlayerComponent = AttackingPlayerComponent()
        entity.addComponent(attackingPlayerComponent)

        return entity
    }()
    
    lazy var weaponEntity: GlideEntity = {
        let entity = MeleeWeaponEntity(initialNodePosition: .zero, playerIndex: 0)
        return entity
    }()
    
    func crateEntity(at position: TiledPoint) -> GlideEntity {
        return DemoEntityFactory.crateEntity(size: CGSize(width: 24, height: 24),
                                             bottomLeftPosition: position,
                                             tileSize: tileSize)
    }
    
    func setupTips() {
        #if os(OSX)
        let tipEntity = GameplayTipEntity(initialNodePosition: TiledPoint(5, 12).point(with: tileSize),
                                          text: "Use the keyboard (e) or left mouse button or connect a game controller (Y) to use the sword.",
                                          frameWidth: 240.0)
        addEntity(tipEntity)
        #elseif os(iOS)
        
        var tipWidth: CGFloat = 200.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            tipWidth = 180.0
        }
        
        let tipEntity = GameplayTipEntity(initialNodePosition: TiledPoint(5, 12).point(with: tileSize),
                                          text: "Use the touch button for the sword.",
                                          frameWidth: tipWidth)
        addEntity(tipEntity)
        #elseif os(tvOS)
        
        let tipEntity = GameplayTipEntity(initialNodePosition: TiledPoint(5, 14).point(with: tileSize),
                                          text: "Use (play) on remote or connect a game controller for the sword.",
                                          frameWidth: 350.0)
        addEntity(tipEntity)
        #endif
    }
    
    deinit {
        #if os(tvOS)
        Input.shared.removeInputProfilesNamed("Player1_Shoot")
        let player1ShootProfile = InputProfile(name: "Player1_Shoot") { profile in
            profile.positiveKeys = [.e, .mouse0, .controller1ButtonY]
        }
        Input.shared.addInputProfile(player1ShootProfile)
        #endif
    }
}
