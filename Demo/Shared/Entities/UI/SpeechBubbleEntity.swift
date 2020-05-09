//
//  SpeechBubbleEntity.swift
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
import SpriteKit

class SpeechBubbleEntity: SpeechBubbleTemplateEntity {
    
    let spriteNodeComponent = SpriteNodeComponent(nodeSize: CGSize(width: 50, height: 50))
    lazy var speechFlowController: SpeechFlowControllerComponent = {
        let controller = SpeechFlowControllerComponent(speech: speech)
        return controller
    }()
    let labelNodeComponent = LabelNodeComponent()
    
    var optionButtonEntities: [GlideEntity] = []
    
    required init(initialNodePosition: CGPoint, speech: Speech) {
        super.init(initialNodePosition: initialNodePosition, speech: speech)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        transform.usesProposedPosition = false
        transform.node.alpha = 0
        
        spriteNodeComponent.spriteNode.texture = SKTexture(nearestFilteredImageName: "dialog_frame")
        spriteNodeComponent.spriteNode.centerRect = CGRect(x: 15.0/32.0, y: 15.0/32.0, width: 2.0/32.0, height: 2.0/32.0)
        
        if speech.displaysOnTalkerPosition {
            spriteNodeComponent.zPositionContainer = DemoZPositionContainer.overlay
        } else {
            spriteNodeComponent.zPositionContainer = GlideZPositionContainer.camera
        }
        addComponent(spriteNodeComponent)
        spriteNodeComponent.spriteNode.zPosition = 1
        
        labelNodeComponent.labelNode.verticalAlignmentMode = .center
        labelNodeComponent.labelNode.fontName = Font.speechBubbleTextFont(ofSize: speechBubbleTextFontSize).familyName
        labelNodeComponent.labelNode.fontSize = speechBubbleTextFontSize
        addComponent(labelNodeComponent)
        labelNodeComponent.labelNode.zPosition = 2
        
        addComponent(speechFlowController)
    }
    
    override func willUpdateComponents(currentTime: TimeInterval, deltaTime: TimeInterval) {
        let selectedButtonEntity = optionButtonEntities.first { $0.component(ofType: FocusableComponent.self)?.wasSelected == true }
        if let selectedButtonEntity = selectedButtonEntity, let buttonIndex = optionButtonEntities.firstIndex(of: selectedButtonEntity) {
            if speech.options.isEmpty == false {
                let nextSpeech = speech.options[buttonIndex].targetSpeech
                speechFlowController.proceed(to: nextSpeech)
            } else {
                speechFlowController.proceed(to: nil)
            }
        }
    }
    
    var lastTextBlockIndex: Int?
    
    override func updateText(to textBlockIndex: Int) {
        guard textBlockIndex != lastTextBlockIndex else {
            return
        }
        
        transform.node.alpha = 1
        lastTextBlockIndex = textBlockIndex
        labelNodeComponent.labelNode.text = speech.textBlocks[textBlockIndex]
        
        optionButtonEntities.forEach { scene?.removeEntity($0) }
        optionButtonEntities = []
        
        if speech.options.count > 1 && speechFlowController.shouldDisplayOptions {
            for option in speech.options {
                let buttonEntity = SpeechBubbleOptionButtonEntity(text: option.text, size: .zero, inputProfile: "Submit")
                scene?.addEntity(buttonEntity)
                buttonEntity.transform.parentTransform = transform
                buttonEntity.transform.node.zPosition = 10
                optionButtonEntities.append(buttonEntity)
            }
            for (index, buttonEntity) in optionButtonEntities.enumerated() {
                guard index + 1 < optionButtonEntities.count else {
                    continue
                }
                let nextEntity = optionButtonEntities[index + 1]
                buttonEntity.component(ofType: FocusableComponent.self)?.leftwardFocusable = nextEntity.component(ofType: FocusableComponent.self)
                nextEntity.component(ofType: FocusableComponent.self)?.rightwardFocusable = buttonEntity.component(ofType: FocusableComponent.self)
            }
        } else {
            let buttonEntity = SpeechBubbleOptionButtonEntity(text: "", size: .zero, inputProfile: "Submit")
            scene?.addEntity(buttonEntity)
            buttonEntity.transform.parentTransform = transform
            buttonEntity.transform.node.zPosition = 10
            buttonEntity.spriteNodeComponent.spriteNode.alpha = 0
            optionButtonEntities.append(buttonEntity)
        }
        
        if let scene = scene {
            layoutSpeeechBubble(for: scene)
        }
    }
    
    func layoutSpeeechBubble(for scene: GlideScene) {
        let speech = speechFlowController.speech
        
        if speech.displaysOnTalkerPosition {
            displaySpeechOnTalkerPosition()
        } else {
            displaySpeechOnCamera(for: scene)
        }
    }
    
    override func layout(scene: GlideScene, previousSceneSize: CGSize) {
        guard scene.size != previousSceneSize else {
            return
        }
        
        layoutSpeeechBubble(for: scene)
    }
    
    private func displaySpeechOnTalkerPosition() {
        
        if component(ofType: SceneAnchoredSpriteLayoutComponent.self) == nil {
            addComponent(SceneAnchoredSpriteLayoutComponent())
        }
        
        let labelNode = labelNodeComponent.labelNode
        let spriteNode = spriteNodeComponent.spriteNode
        let speech = speechFlowController.speech
        
        labelNode.removeFromParent()
        transform.node.addChild(labelNode)
        
        guard let talker = speech.talker else {
            return
        }
        guard let talkerTransform = talker.transform else {
            return
        }
        
        let sizeOfTalker = talker.entity?.component(ofType: ColliderComponent.self)?.size ?? talker.entity?.component(ofType: SpriteNodeComponent.self)?.spriteNode.size
        
        guard let talkerSize = sizeOfTalker else {
            return
        }
        
        var buttonsHeight: CGFloat = 0
        var labelAndButtonsSpacing: CGFloat = 0.0
        if optionButtonEntities.count > 1 {
            buttonsHeight = 50.0
            labelAndButtonsSpacing = 10.0
        }
        
        let verticalMargin: CGFloat = 10.0
        let horizontalMargin: CGFloat = 10.0
        
        labelNode.preferredMaxLayoutWidth = 300
        let frameSize = CGSize(width: labelNode.frame.size.width + horizontalMargin * 2, height: labelNode.frame.size.height + verticalMargin * 2 + buttonsHeight + labelAndButtonsSpacing)
        spriteNode.size = frameSize
        
        labelNodeComponent.offset = CGPoint(x: 0, y: buttonsHeight / 2 + labelAndButtonsSpacing / 2)
        
        if optionButtonEntities.count > 1 {
            let buttonWidth = floor(labelNode.frame.size.width / CGFloat(optionButtonEntities.count))
            
            var currentX = (labelNode.frame.size.width / 2) - (buttonWidth / 2)
            for buttonEntity in optionButtonEntities {
                buttonEntity.component(ofType: SpriteNodeComponent.self)?.spriteNode.size = CGSize(width: buttonWidth, height: buttonsHeight)
                buttonEntity.transform.currentPosition = CGPoint(x: currentX, y: -spriteNode.size.height / 2 + buttonsHeight / 2 + verticalMargin)
                currentX -= buttonWidth
            }
        } else {
            optionButtonEntities.first?.component(ofType: SpriteNodeComponent.self)?.spriteNode.size = frameSize
        }
        
        let scaleFactor = scene?.camera?.xScale ?? 1.0
        transform.currentPosition = talkerTransform.currentPosition + CGPoint(size: ((spriteNode.size / 2) * scaleFactor) + (talkerSize / 2))
    }
    
    private func displaySpeechOnCamera(for scene: GlideScene) {
        
        if component(ofType: SceneAnchoredSpriteLayoutComponent.self) == nil {
            removeGlideComponent(ofType: SceneAnchoredSpriteLayoutComponent.self)
        }
        
        let labelNode = labelNodeComponent.labelNode
        let spriteNode = spriteNodeComponent.spriteNode
        
        // Due to a bug with SpriteKit not respecting z positions of siblings added to camera node.
        labelNode.removeFromParent()
        spriteNode.addChild(labelNode)
        
        let verticalMarginFromSceneEdges: CGFloat = 20.0
        let horizontalMarginFromSceneEdges: CGFloat = 20.0
        let verticalMargin: CGFloat = 20.0
        let horizontalMargin: CGFloat = 20.0
        
        let horizontalMarginForButtons: CGFloat = 20.0
        var labelAndButtonsSpacing: CGFloat = 0.0
        var buttonsHeight: CGFloat = 0
        
        if optionButtonEntities.count > 1 {
            buttonsHeight = 50.0
            labelAndButtonsSpacing = 10.0
        }
        
        spriteNode.size.width = scene.size.width - (horizontalMarginFromSceneEdges * 2)
        labelNode.preferredMaxLayoutWidth = spriteNode.size.width - (horizontalMargin * 2)
        spriteNode.size.height = labelNode.frame.height + (verticalMargin * 2) + buttonsHeight + labelAndButtonsSpacing
        
        labelNodeComponent.offset = CGPoint(x: 0, y: buttonsHeight / 2 + labelAndButtonsSpacing / 2)
        
        if optionButtonEntities.count > 1 {
            let buttonAreaWidth = spriteNode.size.width - (horizontalMarginForButtons * 2)
            let buttonWidth = floor(buttonAreaWidth / CGFloat(optionButtonEntities.count))
            
            var currentX = (buttonAreaWidth / 2) - (buttonWidth / 2)
            for buttonEntity in optionButtonEntities {
                buttonEntity.component(ofType: SpriteNodeComponent.self)?.spriteNode.size = CGSize(width: buttonWidth, height: 50.0)
                buttonEntity.transform.currentPosition = CGPoint(x: currentX, y: -spriteNode.size.height / 2 + buttonsHeight / 2 + verticalMargin)
                
                currentX -= buttonWidth
            }
        } else {
            optionButtonEntities.first?.component(ofType: SpriteNodeComponent.self)?.spriteNode.size = spriteNode.size
        }
        
        let yPosition = -scene.size.height / 2 + spriteNode.size.height / 2 + verticalMarginFromSceneEdges
        transform.currentPosition = CGPoint(x: 0, y: yPosition)
    }
}
