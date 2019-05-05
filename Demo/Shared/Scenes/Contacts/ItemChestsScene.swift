//
//  ItemChestsScene.swift
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

class ItemChestsScene: BaseLevelScene {
    
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
        
        let pickUpItemProfile = InputProfile(name: "PickUpItem") { profile in
            profile.positiveKeys = [.returnEnter,
                                    .keypadEnter,
                                    .allControllersButtonX]
        }
        Input.shared.addInputProfile(pickUpItemProfile)
        
        mapContact(between: DemoCategoryMask.projectile, and: GlideCategoryMask.colliderTile)
        mapContact(between: DemoCategoryMask.projectile, and: GlideCategoryMask.snappable)
        mapContact(between: GlideCategoryMask.player, and: DemoCategoryMask.chestItem)
        
        addEntity(chestEntity)
        
        addEntity(playerEntity)
        
        setupTips()
    }
    
    lazy var playerEntity: GlideEntity = {
        let entity = SimplePlayerEntity(initialNodePosition: defaultPlayerStartLocation, playerIndex: 0)
        entity.tag = "Player"
        
        let bulletShooterComponent = ProjectileShooterComponent(projectileTemplate: BulletEntity.self, projectilePropertiesCallback: { [weak entity, weak self] in
            
            guard let entity = entity else { return nil }
            guard let self = self else { return nil }
            
            let kinematicsBody = entity.component(ofType: KinematicsBodyComponent.self)
            let initialVelocity = kinematicsBody?.velocity ?? .zero
            
            let properties = ProjectileShootingProperties(position: entity.transform.node.convert(.zero, to: self),
                                                          sourceAngle: entity.transform.headingDirection == .left ? 0 : 180,
                                                          velocity: initialVelocity)
            return properties
        })
        entity.addComponent(bulletShooterComponent)
        
        let chestItemPickerComponent = ChestItemPickerComponent(pickUpCallback: { _ in
            
            entity.removeGlideComponent(ofType: ProjectileShooterComponent.self)
            
            let grenadeShooterComponent = ProjectileShooterComponent(projectileTemplate: GrenadeEntity.self, projectilePropertiesCallback: { [weak entity, weak self] in
                
                guard let entity = entity else { return nil }
                guard let self = self else { return nil }
                
                let kinematicsBody = entity.component(ofType: KinematicsBodyComponent.self)
                let initialVelocity = kinematicsBody?.velocity ?? .zero
                
                let properties = ProjectileShootingProperties(position: entity.transform.node.convert(.zero, to: self),
                                                              sourceAngle: entity.transform.headingDirection == .left ? 0 : 180,
                                                              velocity: initialVelocity)
                return properties
            })
            entity.addComponent(grenadeShooterComponent)
        })
        entity.addComponent(chestItemPickerComponent)
        
        return entity
    }()
    
    lazy var chestEntity: ItemChestEntity = {
        let entity = ItemChestEntity(bottomLeftPosition: TiledPoint(15, 10).point(with: tileSize))
        
        let observingArea = EntityObserverComponent.ObservingArea(frame: TiledRect(origin: TiledPoint(13, 10), size: TiledSize(6, 5)), isLocal: false)
        let entityObserverComponent = EntityObserverComponent(entityTags: ["Player"], observingAreas: [observingArea])
        entity.addComponent(entityObserverComponent)
        
        return entity
    }()
    
    func setupTips() {
        var tipWidth: CGFloat = 220.0
        var location = TiledPoint(5, 12)
        var text = "First try shooting. Then look inside the chest to have a boost to your projectiles."
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .phone {
            tipWidth = 200.0
        }
        #elseif os(tvOS)
        tipWidth = 400.0
        location = TiledPoint(5, 14)
        text.append(" Use (play) on the remote to open the chest.")
        #endif
        
        let tipEntity = GameplayTipEntity(initialNodePosition: location.point(with: tileSize),
                                          text: text,
                                          frameWidth: tipWidth)
        addEntity(tipEntity)
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
