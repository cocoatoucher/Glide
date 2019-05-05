//
//  SelfFollowWaypointsComponent.swift
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

/// Component that makes a self moving entity change its movement direction based on
/// preset conditions.
public final class SelfFollowWaypointsComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 580
    
    /// Points inside scene's tile map to follow.
    public let waypoints: [TiledPoint]
    
    /// Method for calculating positions on every frame while following the waypoints.
    public let movementStyle: MovementStyle
    
    // MARK: - Initialize
    
    /// Create a self follow waypoints component.
    ///
    /// - Parameters:
    ///     - waypoints: Points inside scene's tile map to follow.
    ///     - movementStyle: Method for calculating positions on every frame while
    /// following the waypoints.
    public init(waypoints: [TiledPoint], movementStyle: MovementStyle) {
        self.waypoints = waypoints
        self.movementStyle = movementStyle
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func start() {
        guard let scene = scene else {
            return
        }
        
        if let firstPoint = self.waypoints.first?.point(with: scene.tileSize) {
            transform?.proposedPosition = firstPoint
        }
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        guard waypoints.isEmpty == false else {
            return
        }
        
        moveToCurrentWaypoint(deltaTime: seconds)
        
        updateCurrentWaypointIfNeeded()
    }
    
    // MARK: - Private
    
    /// Current waypoint that the entity is on the way to reach.
    private var currentWaypointIndex: Int = 0
    
    private func moveToCurrentWaypoint(deltaTime seconds: TimeInterval) {
        guard let scene = scene else {
            return
        }
        
        let target = waypoints[currentWaypointIndex].point(with: scene.tileSize)
        switch movementStyle {
        case .lerp:
            entity?.component(ofType: LerpingMovementComponent.self)?.targetPoint = target
        case .approach:
            entity?.component(ofType: ApproachingMovementComponent.self)?.targetPoint = target
        }
    }
    
    private func updateCurrentWaypointIfNeeded() {
        guard waypoints.isEmpty == false else {
            return
        }
        guard let scene = scene else {
            return
        }
        
        let currentTargetPoint = waypoints[currentWaypointIndex].point(with: scene.tileSize)
        
        switch movementStyle {
        case .lerp:
            guard let distance = transform?.proposedPosition.distanceTo(currentTargetPoint) else {
                return
            }
            if distance < 2.0 {
                incrementCurrentWaypointIndex()
            }
        case .approach:
            if transform?.currentPosition == currentTargetPoint {
                incrementCurrentWaypointIndex()
            }
        }
    }
    
    private func incrementCurrentWaypointIndex() {
        if currentWaypointIndex == waypoints.count - 1 {
            currentWaypointIndex = 0
        } else {
            currentWaypointIndex += 1
        }
    }
}

extension SelfFollowWaypointsComponent {
    /// Types of position calculation while approaching individual waypoints.
    public enum MovementStyle {
        /// Entity will move with lerping.
        /// `LerpingMovementComponent` is required.
        case lerp
        /// Entity will move with approaching.
        /// `ApproachingMovementComponent` is required.
        case approach
    }
    
}
