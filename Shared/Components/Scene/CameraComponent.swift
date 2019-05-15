//
//  CameraComponent.swift
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
import SpriteKit

/// Component that controls the camera node of a scene through an entity.
/// In a `GlideScene`, you don't need to initialize this component or a camera node
/// as this is already done by the scene.
public final class CameraComponent: GKComponent, GlideComponent {
    
    public let cameraNode: SKCameraNode
    
    /// Size of the boundaries of the camera's display area, centered on the scene.
    public var boundingBoxSize: CGSize
    
    /// Position of the camera in the last frame
    public private(set) var previousCameraPosition: CGPoint = .zero
    
    // MARK: - Configuration
    
    public struct Configuration {
        /// Proportional width of the area on the left and right sides of the scene
        /// which trigger direction change for the camera when entered.
        /// For example, when the focused object enters that area on the left,
        /// camera will focus on the left side of the object showing more area
        /// on the left side of the scene. Same applies for the right side respectively.
        /// All the multipliers are in respect to scene's current dimensions.
        public var horizontalEdgesBoundaryWidthMultiplier: CGFloat = 1 / 4
        
        /// Proportional width of the area on the center of the scene where the focused
        /// object can freely roam without camera changing its direction.
        /// Width of this area is also used as the horizontal offset value from the
        /// position of the object so that the object remains in this area wherever possible.
        public var horizontalCenterBoundaryWidthMultiplier: CGFloat = 1 / 6
        
        /// Proportional height of the area on the top of the scene. While the focused
        /// object is in the boundaries of that area, camera will try to focus on the exact
        /// vertical position of the object to keep it in the visible frame.
        public var verticalTopBoundaryHeightMultiplier: CGFloat = 1 / 6
        
        /// Proportional height of the area on the bottom of the scene. While the focused
        /// object is in the boundaries of that area, camera will try to focus on below the
        /// vertical position of the object with an amount of this value to keep the object
        /// in the visible frame.
        public var verticalBottomBoundaryHeightMultiplier: CGFloat = 1 / 6
        
        /// Smoothness of camera following its target focus position.
        public var followPositionSmoothness: CGFloat = 0.15
        
        /// Width of the visible portion of the scene that is seen at any given moment.
        /// Camera will be scaled according to this formula:
        /// `fieldOfViewWidth` / `scene.width`
        public var fieldOfViewWidth: CGFloat? // In screen points
        
        /// This value should be between 0 and 1.
        /// Smaller value means that the camera will be zoomed in more.
        public var maximumZoom: CGFloat = 0.3
    }
    
    public var configuration = Configuration() {
        didSet {
            if oldValue.fieldOfViewWidth != configuration.fieldOfViewWidth {
                isFieldOfViewUpdated = true
            }
            validateConfigurationBoundaries()
        }
    }
    
    // MARK: - Initialize
    
    /// Create a camera component.
    ///
    /// - Parameters:
    ///     - cameraNode: Camera node of the scene.
    ///     - boundingBoxSize: Size of the bounding box frame for the camera movement.
    /// That's usually the size of the collision tile map of the scene so that the camera
    /// can't go out of the boundaries of the tile map.
    public init(cameraNode: SKCameraNode,
                boundingBoxSize: CGSize) {
        self.cameraNode = cameraNode
        self.boundingBoxSize = boundingBoxSize
        super.init()
        
        validateConfigurationBoundaries()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Call this function to focus the camera on one or more transforms.
    ///
    /// - Parameters:
    ///     - transforms: Transform node components of the entities desired to be focused.
    public func setCameraPosition(to transforms: [TransformNodeComponent]) {
        focusTransforms = transforms
        
        targetCameraPosition = targetCameraPosition(cameraScale: CGVector(dx: targetScale.dx, dy: targetScale.dy),
                                                    currentTargetPosition: targetCameraPosition,
                                                    isForcedToSnap: true)
        previousCameraPosition = cameraNode.position
        cameraNode.position = targetCameraPosition
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        updateCameraPositionAndScale(deltaTime: seconds)
    }
    
    // MARK: - Private
    
    private var positionDampVelocity: CGPoint = .zero
    
    private var scaleDampVelocity: CGPoint = .zero
    
    private var targetScale = CGVector(dx: 1, dy: 1)
    
    private var sceneSize: CGSize = .zero
    
    private var horizontalDirection: HorizontalCameraDirection = .toRight
    
    private var previousTargetCameraPosition: CGPoint = .zero
    
    private var targetCameraPosition: CGPoint = .zero {
        didSet {
            previousTargetCameraPosition = oldValue
        }
    }
    
    private var baseScale = CGVector(dx: 1, dy: 1) {
        didSet {
            cameraNode.xScale = baseScale.dx
            cameraNode.yScale = baseScale.dy
            targetScale = baseScale
        }
    }
    private var isFieldOfViewUpdated: Bool = false
    
    private var boundingBoxFrame: CGRect {
        return CGRect(x: 0, y: 0, width: boundingBoxSize.width, height: boundingBoxSize.height)
    }
    
    private func updateCameraPositionAndScale(deltaTime seconds: TimeInterval) {
        func applyScale() {
            guard targetScale.dx != CGFloat.infinity && targetScale.dy != CGFloat.infinity else {
                return
            }
            
            let startScale = CGPoint(x: cameraNode.xScale, y: cameraNode.yScale)
            let endScale = CGPoint(x: targetScale.dx, y: targetScale.dy)
            
            let damped = startScale.smoothCD(destination: endScale,
                                             velocity: &scaleDampVelocity,
                                             deltaTime: CGFloat(seconds),
                                             smoothness: configuration.followPositionSmoothness)
            
            cameraNode.xScale = damped.x
            cameraNode.yScale = damped.x
        }
        applyScale()
        
        targetCameraPosition = targetCameraPosition(cameraScale: CGVector(dx: targetScale.dx, dy: targetScale.dy),
                                                    currentTargetPosition: targetCameraPosition,
                                                    isForcedToSnap: false)
        
        let damped = cameraNode.position.smoothCD(destination: targetCameraPosition,
                                                  velocity: &positionDampVelocity,
                                                  deltaTime: CGFloat(seconds),
                                                  smoothness: configuration.followPositionSmoothness)
        previousCameraPosition = cameraNode.position
        cameraNode.position = damped
    }
    
    /// Returns the target camera position for the given transform node component.
    private func targetCameraPosition(for focusTransform: TransformNodeComponent,
                                      focusNodeParent: SKNode,
                                      cameraScale: CGVector,
                                      currentTargetPosition: CGPoint,
                                      isForcedToSnap: Bool) -> CGPoint {
        
        var basePosition = focusTransform.node.position
        if let offset = (focusTransform.entity as? GlideEntity)?.cameraFocusOffset {
            basePosition += offset
        }
        
        var convertedFocusNodePosition = cameraNode.convert(basePosition, from: focusNodeParent)
        let scaleFactor = CGPoint(x: cameraScale.dx, y: cameraScale.dy)
        convertedFocusNodePosition *= scaleFactor
        
        let sceneSizeScaled = CGSize(width: sceneSize.width * cameraScale.dx,
                                     height: sceneSize.height * cameraScale.dy)
        
        let horizontalEdgeBoundary: CGFloat = (sceneSizeScaled.width * configuration.horizontalEdgesBoundaryWidthMultiplier)
        let horizontalCenterBoundary: CGFloat = (sceneSizeScaled.width * configuration.horizontalCenterBoundaryWidthMultiplier)
        
        var result = CGPoint.zero
        
        if convertedFocusNodePosition.x < -(sceneSizeScaled.width / 2) + horizontalEdgeBoundary {
            // Hit the left edge
            horizontalDirection = .toLeft
            result.x = basePosition.x - horizontalCenterBoundary
        } else if convertedFocusNodePosition.x > sceneSizeScaled.width / 2 - horizontalEdgeBoundary {
            // Hit the right edge
            horizontalDirection = .toRight
            result.x = basePosition.x + horizontalCenterBoundary
        } else if
            convertedFocusNodePosition.x < horizontalCenterBoundary &&
                convertedFocusNodePosition.x > -horizontalCenterBoundary {
            // Hit the right center boundary
            // or Hit the left center boundary
            switch horizontalDirection {
            case .toLeft:
                result.x = basePosition.x - horizontalCenterBoundary
            case .toRight:
                result.x = basePosition.x + horizontalCenterBoundary
            }
        } else {
            result.x = currentTargetPosition.x
        }
        
        let verticalTop = (sceneSizeScaled.height * configuration.verticalTopBoundaryHeightMultiplier)
        let verticalTopBoundary = (sceneSizeScaled.height / 2 - verticalTop)
        let verticalBottom = (sceneSizeScaled.height * configuration.verticalBottomBoundaryHeightMultiplier)
        let verticalBottomBoundary = (-(sceneSizeScaled.height / 2) + verticalBottom)
        
        if focusTransform.entity?.component(ofType: ColliderComponent.self)?.onGround == true || isForcedToSnap {
            result.y = basePosition.y
        } else if convertedFocusNodePosition.y > verticalTopBoundary {
            // Follow when it hits the top boundary
            result.y = basePosition.y
        } else if convertedFocusNodePosition.y < verticalBottomBoundary {
            // Follow when it hits the bottom boundary
            result.y = basePosition.y + verticalBottomBoundary
        } else {
            result.y = currentTargetPosition.y
        }
        return result
    }
    
    private func targetCameraPosition(cameraScale: CGVector, currentTargetPosition: CGPoint, isForcedToSnap: Bool) -> CGPoint {
        var result: CGPoint
        
        if let focusPosition = focusPosition {
            result = focusPosition
        } else if
            let focusTransform = focusTransform,
            let focusNodeParent = focusTransform.node.parent
        {
            result = targetCameraPosition(for: focusTransform,
                                          focusNodeParent: focusNodeParent,
                                          cameraScale: cameraScale,
                                          currentTargetPosition: currentTargetPosition,
                                          isForcedToSnap: isForcedToSnap)
        } else {
            result = focusTransform?.node.position ?? .zero
            
            if let offset = (focusTransform?.entity as? GlideEntity)?.cameraFocusOffset {
                result += offset
            }
        }
        
        // Screen edges
        if result.x < boundingBoxFrame.origin.x + (sceneSize.width / 2 * cameraScale.dx) {
            // Left
            result.x = boundingBoxFrame.origin.x + (sceneSize.width / 2 * cameraScale.dx)
        }
        if result.x > boundingBoxFrame.origin.x + boundingBoxFrame.width - (sceneSize.width / 2 * cameraScale.dx) {
            // Right
            result.x = boundingBoxFrame.origin.x + boundingBoxFrame.width - (sceneSize.width / 2 * cameraScale.dx)
        }
        if result.y < boundingBoxFrame.origin.y + (sceneSize.height / 2 * cameraScale.dx) {
            // Bottom
            result.y = boundingBoxFrame.origin.y + (sceneSize.height / 2 * cameraScale.dx)
        }
        if result.y > boundingBoxFrame.origin.y + boundingBoxFrame.height - (sceneSize.height / 2 * cameraScale.dx) {
            // Top
            result.y = boundingBoxFrame.origin.y + boundingBoxFrame.height - (sceneSize.height / 2 * cameraScale.dx)
        }
        
        return result
    }
    
    private func validateConfigurationBoundaries() {
        assert(configuration.horizontalEdgesBoundaryWidthMultiplier * 2 + configuration.horizontalCenterBoundaryWidthMultiplier <= 1,
               "Sum of horizontal edge and center boundary multipliers should be less than or equal to 1.")
        assert(configuration.verticalTopBoundaryHeightMultiplier + configuration.verticalBottomBoundaryHeightMultiplier < 1,
               "Sum of vertical top and bottom boundary multipliers should be smaller than 1.")
    }
    
    // MARK: - Internal
    
    var focusTransform: TransformNodeComponent?
    
    var focusTransforms: [TransformNodeComponent] = [] {
        didSet {
            if focusTransforms.count < 2 {
                focusTransform = focusTransforms.first
            } else {
                var minX = CGFloat.greatestFiniteMagnitude
                var maxX = -CGFloat.greatestFiniteMagnitude
                var minY = CGFloat.greatestFiniteMagnitude
                var maxY = -CGFloat.greatestFiniteMagnitude
                for transform in focusTransforms {
                    if transform.currentPosition.x < minX {
                        minX = transform.currentPosition.x
                    }
                    if transform.currentPosition.x > maxX {
                        maxX = transform.currentPosition.x
                    }
                    if transform.currentPosition.y < minY {
                        minY = transform.currentPosition.y
                    }
                    if transform.node.position.y > maxY {
                        maxY = transform.currentPosition.y
                    }
                }
                focusFrame = CGRect(x: minX - 32, y: minY - 32, width: maxX - minX + 64, height: maxY - minY + 64)
            }
        }
    }
    
    var focusPosition: CGPoint?
    
    var focusFrame: CGRect? {
        didSet {
            if let focusFrame = focusFrame {
                
                let focusWidth = focusFrame.width / baseScale.dx
                let focusHeight = focusFrame.height / baseScale.dy
                if focusWidth > sceneSize.width || focusHeight > sceneSize.height {
                    let horizontalScale = focusFrame.width / sceneSize.width
                    let verticalScale = focusFrame.height / sceneSize.height
                    let scale = fmax(horizontalScale, verticalScale)
                    targetScale = CGVector(dx: scale, dy: scale)
                }
                
                focusPosition = CGPoint(x: focusFrame.midX, y: focusFrame.midY)
            } else {
                focusPosition = nil
                targetScale = baseScale
            }
        }
    }
    
    // MARK: - Debuggable
    
    public static var isDebugEnabled: Bool = false
    public var isDebugEnabled: Bool = false
}

extension CameraComponent: NodeLayoutableComponent {
    
    public func layout(scene: GlideScene, previousSceneSize: CGSize) {
        guard previousSceneSize != scene.size || isFieldOfViewUpdated else {
            return
        }
        
        isFieldOfViewUpdated = false
        sceneSize = scene.size
        
        if let fieldOfViewWidth = configuration.fieldOfViewWidth {
            let maxZoom = fmin(fmax(configuration.maximumZoom, 0.0), 1.0)
            let scale = fmin(fmax(fieldOfViewWidth / sceneSize.width, maxZoom), 1.0)
            baseScale = CGVector(dx: scale, dy: scale)
        } else {
            baseScale = CGVector(dx: 1.0, dy: 1.0)
        }
    }
}

extension CameraComponent {
    enum HorizontalCameraDirection {
        case toLeft
        case toRight
    }
}

extension CameraComponent: DebuggableComponent {
    
    public func updateDebugElements() {
        let centerDebugNodeName = debugElementName(with: "center")
        let leftEdgeDebugNodeName = debugElementName(with: "leftEdge")
        let rightEdgeDebugNodeName = debugElementName(with: "rightEdge")
        
        let verticalTop = (sceneSize.height * configuration.verticalTopBoundaryHeightMultiplier).glideRound
        let verticalBottom = (sceneSize.height * configuration.verticalBottomBoundaryHeightMultiplier).glideRound
        
        let debugNodeHeight = sceneSize.height - verticalTop - verticalBottom
        let debugNodeYPosition = (verticalBottom - verticalTop) / 2
        
        let horizontalCenterBoundaryWidthMultiplier = configuration.horizontalCenterBoundaryWidthMultiplier
        let horizontalCenterBoundary = (sceneSize.width * horizontalCenterBoundaryWidthMultiplier).glideRound
        let centerDebugNodeSize = CGSize(width: horizontalCenterBoundary * 2, height: debugNodeHeight)
        if cameraNode.childNode(withName: centerDebugNodeName)?.parent == nil {
            let centerDebugNode = SKSpriteNode(texture: nil,
                                               color: Color.red.withAlphaComponent(0.3),
                                               size: centerDebugNodeSize)
            centerDebugNode.name = centerDebugNodeName
            cameraNode.addChild(centerDebugNode)
        }
        (cameraNode.childNode(withName: centerDebugNodeName) as? SKSpriteNode)?.position = CGPoint(x: 0, y: debugNodeYPosition)
        (cameraNode.childNode(withName: centerDebugNodeName) as? SKSpriteNode)?.size = centerDebugNodeSize
        
        let horizontalEdgesBoundaryWidthMultiplier = configuration.horizontalEdgesBoundaryWidthMultiplier
        let horizontalEdgeBoundary: CGFloat = (sceneSize.width * horizontalEdgesBoundaryWidthMultiplier).glideRound
        let edgeDebugNodeSize = CGSize(width: horizontalEdgeBoundary, height: debugNodeHeight)
        
        if cameraNode.childNode(withName: leftEdgeDebugNodeName)?.parent == nil {
            let leftEdgeDebugNode = SKSpriteNode(texture: nil,
                                                 color: Color.green.withAlphaComponent(0.3),
                                                 size: edgeDebugNodeSize)
            leftEdgeDebugNode.name = leftEdgeDebugNodeName
            cameraNode.addChild(leftEdgeDebugNode)
        }
        (cameraNode.childNode(withName: leftEdgeDebugNodeName) as? SKSpriteNode)?.size = edgeDebugNodeSize
        (cameraNode.childNode(withName: leftEdgeDebugNodeName) as? SKSpriteNode)?.position = CGPoint(x: -sceneSize.width / 2 + edgeDebugNodeSize.width / 2,
                                                                                                     y: debugNodeYPosition)
        
        if cameraNode.childNode(withName: rightEdgeDebugNodeName)?.parent == nil {
            let rightEdgeDebugNode = SKSpriteNode(texture: nil,
                                                  color: Color.green.withAlphaComponent(0.3),
                                                  size: edgeDebugNodeSize)
            rightEdgeDebugNode.name = rightEdgeDebugNodeName
            cameraNode.addChild(rightEdgeDebugNode)
        }
        (cameraNode.childNode(withName: rightEdgeDebugNodeName) as? SKSpriteNode)?.size = edgeDebugNodeSize
        (cameraNode.childNode(withName: rightEdgeDebugNodeName) as? SKSpriteNode)?.position = CGPoint(x: sceneSize.width / 2 - edgeDebugNodeSize.width / 2,
                                                                                                      y: debugNodeYPosition)
    }
    
    public func cleanDebugElements() {
        let centerDebugNodeName = debugElementName(with: "center")
        let leftEdgeDebugNodeName = debugElementName(with: "leftEdge")
        let rightEdgeDebugNodeName = debugElementName(with: "rightEdge")
        cameraNode.childNode(withName: centerDebugNodeName)?.removeFromParent()
        cameraNode.childNode(withName: leftEdgeDebugNodeName)?.removeFromParent()
        cameraNode.childNode(withName: rightEdgeDebugNodeName)?.removeFromParent()
    }
}
