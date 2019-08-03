//
//  PlayableCharacterComponent.swift
//  glide
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

import GameplayKit

/// Coordinates the transfer of input profile values to different ability
/// components based on given player index.
///
/// Controlled components:
/// - `JumpComponent`
/// - `WallJumpComponent`
/// - `HorizontalMovementComponent`
/// - `ProjectileShooterComponent`
/// - `LadderClimberComponent`
/// - `SwingHolderComponent`
/// - `DasherComponent`
/// - `ColliderComponent`
/// - `ParagliderComponent`
/// - `CroucherComponent`
/// - `JetpackOperatorComponent`
/// - `SwingHolderComponent`
public final class PlayableCharacterComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 640
    
    /// Index of the player to be used to pair the component with input profiles.
    public let playerIndex: Int
    
    // CameraFocusingComponent
    public var focusOffset: CGPoint = .zero
    
    // MARK: - Initialize
    
    /// Create a playable character component.
    ///
    /// - Parameters:
    ///     - playerIndex: Index of the player to be used to pair the component with
    /// input profiles.
    public init(playerIndex: Int) {
        self.playerIndex = playerIndex
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        handleProjectileShooting()
        handleHeadingDirection()
        handleVerticalMove()
        handleHorizontalMove()
    }
    
    // MARK: - Private
    
    /// Value of when the input jump button was pressed the last time.
    /// Used to control serial jumps.
    private var lastJumpPressTime: TimeInterval = 0
    
    /// `true` if jump input profile is being continuously captured since the last frame.
    /// Used to control early jump release for faster falling.
    private var holdingDownInitialJumpPress: Bool = false
    
    private var shouldWallJump: Bool {
        guard let wallJumpComponent = entity?.component(ofType: WallJumpComponent.self) else {
            return false
        }
        return isButtonPressed(for: "Jump") && wallJumpComponent.canJump
    }
    
    private var shouldGroundJump: Bool {
        guard let jumpComponent = entity?.component(ofType: JumpComponent.self) else {
            return false
        }
        return isButtonPressed(for: "Jump") && jumpComponent.canJump
    }
    
    private func shouldSerialGroundJump(at currentTime: TimeInterval) -> Bool {
        guard let jumpComponent = entity?.component(ofType: JumpComponent.self) else {
            return false
        }
        return isButtonHoldDown(for: "Jump") &&
            jumpComponent.canJump &&
            holdingDownInitialJumpPress == false &&
            currentTime - lastJumpPressTime <= jumpComponent.configuration.serialJumpThreshold
    }
    
    private func handleCrouching() {
        let collider = entity?.component(ofType: ColliderComponent.self)
        
        let verticalProfile = profile(for: "Vertical")
        
        if verticalProfile == -1 && collider?.isOnAir == false {
            entity?.component(ofType: CroucherComponent.self)?.crouches = true
        }
    }
    
    private func handleLookingUpwards() {
        let collider = entity?.component(ofType: ColliderComponent.self)
        
        let verticalProfile = profile(for: "Vertical")
        
        if verticalProfile == 1 && collider?.isOnAir == false {
            entity?.component(ofType: UpwardsLookerComponent.self)?.looksUpwards = true
        }
    }
    
    private func handleLadderClimbing() {
        guard let ladderClimber = entity?.component(ofType: LadderClimberComponent.self) else {
            return
        }
        guard ladderClimber.isContactingLadder else {
            ladderClimber.isHolding = false
            return
        }
        
        let collider = entity?.component(ofType: ColliderComponent.self)
        
        let verticalProfile = profile(for: "Vertical")
        
        let shouldClimbLadder = verticalProfile > 0 && ladderClimber.isHolding == false
        let isClimbingUpLadder = verticalProfile > 0 && ladderClimber.isHolding
        let isClimbingDownLadder = verticalProfile < 0 && ladderClimber.isHolding
        
        if shouldClimbLadder {
            ladderClimber.isHolding = true
        } else if isClimbingUpLadder {
            ladderClimber.movingDirection = .upwards
        } else if collider?.onGround == true {
            ladderClimber.isHolding = false
        } else if isClimbingDownLadder {
            if collider?.wasOnGround == true || collider?.onGround == true {
                ladderClimber.isHolding = false
            } else {
                ladderClimber.movingDirection = .downwards
            }
        } else {
            ladderClimber.movingDirection = .none
        }
    }
    
    private func handleJetpacking() {
        guard let jetpackOperator = entity?.component(ofType: JetpackOperatorComponent.self) else {
            return
        }
        
        jetpackOperator.isOperatingJetpack = isButtonPressed(for: "Jetpack") || isButtonHoldDown(for: "Jetpack")
    }
    
    private func handleJumpingAndParagliding() {
        
        if isButtonPressed(for: "Jump") {
            lastJumpPressTime = currentTime ?? 0
        }
        
        var wasHoldingDownInitialJumpPress = false
        if isButtonReleased(for: "Jump") {
            if holdingDownInitialJumpPress {
                wasHoldingDownInitialJumpPress = true
            }
            holdingDownInitialJumpPress = false
        }
        
        let collider = entity?.component(ofType: ColliderComponent.self)
        
        guard let kinematicsBody = entity?.component(ofType: KinematicsBodyComponent.self) else {
            return
        }
        
        let ladderClimber = entity?.component(ofType: LadderClimberComponent.self)
        let jumpComponent = entity?.component(ofType: JumpComponent.self)
        let wallJumpComponent = entity?.component(ofType: WallJumpComponent.self)
        
        let shouldReleaseJumpingOnAir = isButtonReleased(for: "Jump") &&
            wasHoldingDownInitialJumpPress &&
            kinematicsBody.velocity.dy > 0 &&
            collider?.isOnAir == true
        
        let shouldJump = shouldGroundJump || shouldSerialGroundJump(at: currentTime ?? 0)
        
        if shouldJump {
            ladderClimber?.isHolding = false
            jumpComponent?.jumps = true
            holdingDownInitialJumpPress = true
        } else if shouldWallJump {
            holdingDownInitialJumpPress = true
            wallJumpComponent?.jumps = true
        } else if shouldReleaseJumpingOnAir {
            // Early jump break, faster falling
            kinematicsBody.velocity.dy = fmin(2.0, kinematicsBody.velocity.dy)
        } else {
            handleParagliding()
        }
    }
    
    private func handleParagliding() {
        guard let kinematicsBody = entity?.component(ofType: KinematicsBodyComponent.self) else {
            return
        }
        
        let collider = entity?.component(ofType: ColliderComponent.self)
        let paraglider = entity?.component(ofType: ParagliderComponent.self)
        
        let shouldStartParagliding = isButtonPressed(for: "Paraglide") &&
            kinematicsBody.velocity.dy < 0 &&
            collider?.isOnAir == true &&
            paraglider?.canParaglide == true
        
        let shouldContinueParagliding = paraglider?.wasParagliding == true &&
            isButtonHoldDown(for: "Paraglide") &&
            collider?.isOnAir == true
        
        if shouldStartParagliding || shouldContinueParagliding {
            paraglider?.isParagliding = true
        }
    }
    
    private func handleVerticalMove() {
        let verticalProfile = profile(for: "Vertical")
        
        if let verticalMovement = entity?.component(ofType: VerticalMovementComponent.self) {
            if verticalProfile < 0 {
                verticalMovement.movementDirection = .negative
            } else if verticalProfile > 0 {
                verticalMovement.movementDirection = .positive
            } else {
                verticalMovement.movementDirection = .stationary
            }
        }
        
        handleCrouching()
        handleLookingUpwards()
        handleLadderClimbing()
        handleJetpacking()
        handleJumpingAndParagliding()
    }
    
    private func handleProjectileShooting() {
        if isButtonPressed(for: "Shoot") {
            entity?.component(ofType: ProjectileShooterComponent.self)?.shoots = true
        }
    }
    
    private func handleHeadingDirection() {
        let horizontalProfile = profile(for: "Horizontal")
        if horizontalProfile < 0 {
            transform?.headingDirection = .left
        } else if horizontalProfile > 0 {
            transform?.headingDirection = .right
        }
    }
    
    private func handleHorizontalMove() {
        guard let horizontalMovement = entity?.component(ofType: HorizontalMovementComponent.self) else {
            return
        }
        guard entity?.component(ofType: LadderClimberComponent.self)?.isHolding != true else {
            horizontalMovement.movementDirection = .stationary
            return
        }
        
        let horizontalProfile = profile(for: "Horizontal")
        
        let swingHolder = entity?.component(ofType: SwingHolderComponent.self)
        
        let dasher = entity?.component(ofType: DasherComponent.self)
        let shouldDash = dasher != nil && isButtonPressed(for: "Dash")
        
        if swingHolder?.isHolding == true {
            if horizontalProfile < 0 {
                swingHolder?.pushDirection = .clockwise
            } else if horizontalProfile > 0 {
                swingHolder?.pushDirection = .counterClockwise
            }
        } else if shouldDash {
            dasher?.dashes = true
        } else if dasher?.dashes != true {
            if horizontalProfile < 0 {
                horizontalMovement.movementDirection = .negative
            } else if horizontalProfile > 0 {
                horizontalMovement.movementDirection = .positive
            } else {
                horizontalMovement.movementDirection = .stationary
            }
        }
    }
    
    // MARK: - Input
    
    private func playerInputProfileName(_ baseProfileName: String) -> String {
        return "Player\((playerIndex + 1))_" + baseProfileName
    }
    
    private func isButtonPressed(for baseProfileName: String) -> Bool {
        guard (entity as? GlideEntity)?.shouldBlockInputs == false else {
            return false
        }
        
        return Input.shared.isButtonPressed(playerInputProfileName(baseProfileName))
    }
    
    private func isButtonHoldDown(for baseProfileName: String) -> Bool {
        guard (entity as? GlideEntity)?.shouldBlockInputs == false else {
            return false
        }
        
        return Input.shared.isButtonHoldDown(playerInputProfileName(baseProfileName))
    }
    
    private func isButtonReleased(for baseProfileName: String) -> Bool {
        guard (entity as? GlideEntity)?.shouldBlockInputs == false else {
            return false
        }
        
        return Input.shared.isButtonReleased(playerInputProfileName(baseProfileName))
    }
    
    private func profile(for baseProfileName: String) -> CGFloat {
        guard (entity as? GlideEntity)?.shouldBlockInputs == false else {
            return 0.0
        }
        
        return Input.shared.profileValue(playerInputProfileName(baseProfileName))
    }
}

extension PlayableCharacterComponent: CameraFocusingComponent {}
