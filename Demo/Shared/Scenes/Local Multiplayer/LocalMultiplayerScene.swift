//
//  LocalMultiplayerScene.swift
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
import SpriteKit

class LocalMultiplayerScene: BaseLevelScene {
    
    override func setupScene() {
        super.setupScene()
        
        #if os(tvOS)
        Input.shared.removeInputProfilesNamed("Player1_Shoot")
        let player1ShootProfile = InputProfile(name: "Player1_Shoot") { profile in
            profile.positiveKeys = [.e, .mouse0, .controller1ButtonX, .controller1ButtonY]
        }
        Input.shared.addInputProfile(player1ShootProfile)
        #endif
        
        mapContact(between: DemoCategoryMask.weapon, and: DemoCategoryMask.crate)
        
        addPlayerEntity(at: defaultPlayerStartLocation, playerIndex: 0)
        
        let otherPlayerStartLocation = defaultPlayerStartLocation + TiledPoint(2, 0).point(with: tileSize)
        addPlayerEntity(at: otherPlayerStartLocation, playerIndex: 1)
        
        addEntity(crateEntity(at: TiledPoint(2, 10)))
        addEntity(crateEntity(at: TiledPoint(22, 10)))
        addEntity(crateEntity(at: TiledPoint(25, 10)))
        addEntity(crateEntity(at: TiledPoint(28, 10)))
        addEntity(crateEntity(at: TiledPoint(31, 10)))
        
        setupTips()
    }
    
    func addPlayerEntity(at position: CGPoint, playerIndex: Int) {
        let entity = SimplePlayerEntity(initialNodePosition: position, playerIndex: playerIndex)
        
        let attackingPlayerComponent = AttackingPlayerComponent()
        entity.addComponent(attackingPlayerComponent)
        
        let healthComponent = HealthComponent(maximumHealth: 3)
        entity.addComponent(healthComponent)
        
        let blinkerComponent = BlinkerComponent(blinkingDuration: 0.8)
        entity.addComponent(blinkerComponent)
        
        let bouncerComponent = BouncerComponent(contactCategoryMasks: DemoCategoryMask.hazard)
        entity.addComponent(bouncerComponent)
        
        addEntity(entity)
        
        let meleeWeaponEntity = MeleeWeaponEntity(initialNodePosition: .zero, playerIndex: playerIndex)
        addEntity(meleeWeaponEntity)
        meleeWeaponEntity.transform.parentTransform = entity.transform
        
        let healthBarEntity = StickyHealthBarEntity(numberOfHearts: 3)
        healthBarEntity.component(ofType: SpriteNodeComponent.self)?.spriteNode.zPosition = 10
        healthBarEntity.component(ofType: SpriteNodeComponent.self)?.offset = CGPoint(x: 0, y: 20)
        addEntity(healthBarEntity)
        healthBarEntity.transform.parentTransform = entity.transform
        
        if let updatableHealthBarComponent = healthBarEntity.component(ofType: UpdatableHealthBarComponent.self) {
            let updateHealthBarComponent = UpdateHealthBarComponent(updatableHealthBarComponent: updatableHealthBarComponent)
            entity.addComponent(updateHealthBarComponent)
        }
    }
    
    func crateEntity(at position: TiledPoint) -> GlideEntity {
        return DemoEntityFactory.crateEntity(size: CGSize(width: 24, height: 24),
                                             bottomLeftPosition: position,
                                             tileSize: tileSize)
    }
    
    func setupTips() {
        #if os(OSX)
        let text = """
                    Use your keyboard or connect 2 game controllers to control those two
                    identical adventurers. See `DefaultInputProfiles` for the list of commands.
                    Friendly fire is on!
                    """
        let tipEntity = GameplayTipEntity(initialNodePosition: TiledPoint(5, 13).point(with: tileSize),
                                          text: text,
                                          frameWidth: 260.0)
        addEntity(tipEntity)
        #elseif os(iOS)
        
        var tipWidth: CGFloat = 260.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            tipWidth = 220.0
        }
        
        let text = """
                    Connect 2 game controllers to control those two identical adventurers.
                    See `DefaultInputProfiles` for the list of commands.
                    Friendly fire is on!
                    """
        let tipEntity = GameplayTipEntity(initialNodePosition: TiledPoint(5, 13).point(with: tileSize),
                                          text: text,
                                          frameWidth: tipWidth)
        addEntity(tipEntity)
        #elseif os(tvOS)
        
        let text = """
                    Connect an additional game controller to control those two identical adventurers.
                    See `DefaultInputProfiles` for the list of commands.
                    Friendly fire is on!
                    """
        let tipEntity = GameplayTipEntity(initialNodePosition: TiledPoint(7, 16).point(with: tileSize),
                                          text: text,
                                          frameWidth: 600.0)
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
