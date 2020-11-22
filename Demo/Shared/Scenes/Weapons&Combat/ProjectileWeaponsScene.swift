//
//  ProjectileWeaponsScene.swift
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

class ProjectileWeaponsScene: BaseLevelScene {
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
            profile.positiveKeys = [.e, .mouseLeft, .controller1ButtonX, .controller1ButtonY]
        }
        Input.shared.addInputProfile(player1ShootProfile)
        #endif
        
        mapContact(between: DemoCategoryMask.crate, and: DemoCategoryMask.projectile)
        
        addEntity(playerEntity)
        
        addEntity(weaponEntity)
        weaponEntity.transform.parentTransform = playerEntity.transform
        weaponEntity.transform.node.zPosition = 10
        
        Input.shared.addInputProfile(InputProfile(name: "Player1_Horizontal_Alt") { profile in
            profile.positiveKeys = [.controller1RightThumbstickRight]
            profile.negativeKeys = [.controller1RightThumbstickLeft]
        })
        Input.shared.addInputProfile(InputProfile(name: "Player1_Vertical_Alt") { profile in
            profile.positiveKeys = [.controller1RightThumbstickUp]
            profile.negativeKeys = [.controller1RightThumbstickDown]
        })
        
        addEntity(crateEntity(at: TiledPoint(13, 10)))
        addEntity(crateEntity(at: TiledPoint(16, 10)))
        addEntity(crateEntity(at: TiledPoint(19, 10)))
        addEntity(crateEntity(at: TiledPoint(22, 10)))
        addEntity(crateEntity(at: TiledPoint(25, 10)))
        
        setupTips()
    }
    
    lazy var playerEntity: GlideEntity = {
        let playerEntity = SimplePlayerEntity(initialNodePosition: defaultPlayerStartLocation, playerIndex: 0)
        
        let projectileShooterComponent = ProjectileShooterComponent(projectileTemplate: GrenadeEntity.self, projectilePropertiesCallback: { [weak self, weak playerEntity] in
            
            guard let playerEntity = playerEntity else { return nil }
            guard let self = self else { return nil }
            
            let weaponComponent = playerEntity.transform.componentInChildren(ofType: ProjectileWeaponComponent.self)
            if let localPosition = weaponComponent?.weaponPosition.projectileStartPosition,
                let shootingAngle = weaponComponent?.shootingAngle {
                
                let kinematicsBody = playerEntity.component(ofType: KinematicsBodyComponent.self)
                let initialVelocity = kinematicsBody?.velocity ?? .zero
                
                let properties = ProjectileShootingProperties(position: playerEntity.transform.node.convert(localPosition, to: self),
                                                              sourceAngle: shootingAngle,
                                                              velocity: initialVelocity)
                return properties
            }
            return nil
        })
        playerEntity.addComponent(projectileShooterComponent)
        
        let audioPlayerComponent = playerEntity.component(ofType: AudioPlayerComponent.self)
        
        let shootClip = AudioClip(triggerName: "Shoot",
                                  fileName: "shoot",
                                  fileExtension: "wav",
                                  loops: false,
                                  isPositional: true)
        audioPlayerComponent?.addClip(shootClip)
        
        return playerEntity
    }()
    
    lazy var weaponEntity: GlideEntity = {
        let weaponEntity = ProjectileWeaponEntity(initialNodePosition: .zero, positionOffset: .zero)
        return weaponEntity
    }()
    
    func crateEntity(at position: TiledPoint) -> GlideEntity {
        return DemoEntityFactory.crateEntity(size: CGSize(width: 24, height: 24),
                                             bottomLeftPosition: position,
                                             tileSize: tileSize)
    }
    
    func setupTips() {
        #if os(OSX)
        let text = """
                    Move your mouse or connect a game controller and use the right thumbstick to rotate the rifle.
                    Use the keyboard (e) or left mouse button or connect a game controller (Y) to shoot projectiles.
                    Will look much better if you have combined textures for the character and weapon.
                    """
        let tipEntity = GameplayTipEntity(initialNodePosition: TiledPoint(4, 13).point(with: tileSize),
                                          text: text,
                                          frameWidth: 360.0)
        addEntity(tipEntity)
        #elseif os(iOS)
        
        let tipEntity = GameplayTipEntity(initialNodePosition: TiledPoint(4, 13).point(with: tileSize),
                                          text: "Connect a game controller or try on macOS for rotating the rifle.",
                                          frameWidth: 180.0)
        addEntity(tipEntity)
        
        #elseif os(tvOS)
        
        let tipEntity = GameplayTipEntity(initialNodePosition: TiledPoint(4, 14).point(with: tileSize),
                                          text: "Use (play) on remote or connect a game controller to shoot projectiles and rotate the rifle.",
                                          frameWidth: 350.0)
        addEntity(tipEntity)
        #endif
    }
    
    deinit {
        #if os(tvOS)
        Input.shared.removeInputProfilesNamed("Player1_Shoot")
        let player1ShootProfile = InputProfile(name: "Player1_Shoot") { profile in
            profile.positiveKeys = [.e, .mouseLeft, .controller1ButtonY]
        }
        Input.shared.addInputProfile(player1ShootProfile)
        #endif
    }
}
