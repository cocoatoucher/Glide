//
//  SpeechBubblesScene.swift
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
import GameplayKit

class SpeechBubblesScene: BaseLevelScene {
    
    lazy var conversation: Conversation? = {
        guard let playerTalker = playerEntity.component(ofType: TalkerComponent.self) else {
            return nil
        }
        guard let npcTalker = npcEntity.component(ofType: TalkerComponent.self) else {
            return nil
        }
        
        var speech1 = Speech(textBlocks: ["Now I will give you two options...", "Which one would you prefer? Make your choice and brace yourself..."],
                             talker: npcTalker,
                             displaysOnTalkerPosition: true,
                             speechBubbleTemplate: SpeechBubbleEntity.self)
        
        let speech2 = Speech(text: "I choose Chickens!",
                             talker: playerTalker,
                             displaysOnTalkerPosition: true,
                             speechBubbleTemplate: SpeechBubbleEntity.self)
        
        var speech3 = Speech(text: "I choose Eggs!",
                             talker: playerTalker,
                             displaysOnTalkerPosition: true,
                             speechBubbleTemplate: SpeechBubbleEntity.self)
        
        var speech4 = Speech(textBlocks: ["...And they lived happily ever after.", "Did you like this ending?"],
                             talker: nil,
                             displaysOnTalkerPosition: false,
                             speechBubbleTemplate: SpeechBubbleEntity.self)
        
        let speech5 = Speech(text: "Great!",
                             talker: npcTalker,
                             displaysOnTalkerPosition: true,
                             speechBubbleTemplate: SpeechBubbleEntity.self)
        
        let speech6 = Speech(text: ":(",
                             talker: npcTalker,
                             displaysOnTalkerPosition: true,
                             speechBubbleTemplate: SpeechBubbleEntity.self)
        
        speech1.addOption(SpeechOption(text: "Chickens", targetSpeech: speech2))
        speech1.addOption(SpeechOption(text: "Eggs", targetSpeech: speech3))
        
        speech2.addOption(SpeechOption(text: "", targetSpeech: speech4))
        speech3.addOption(SpeechOption(text: "", targetSpeech: speech4))
        
        speech4.addOption(SpeechOption(text: "Yes", targetSpeech: speech5))
        speech4.addOption(SpeechOption(text: "No", targetSpeech: speech6))
        
        let speeches = [speech1, speech2, speech3]
        return Conversation(speeches: speeches, blocksInputs: true)
    }()
    
    lazy var playerEntity: GlideEntity = {
        let entity = SimplePlayerEntity(initialNodePosition: defaultPlayerStartLocation, playerIndex: 0)
        entity.tag = "Player"
        let talkerComponent = TalkerComponent()
        entity.addComponent(talkerComponent)
        return entity
    }()
    
    lazy var npcEntity: GlideEntity = {
        let origin = TiledPoint(17, 10)
        let entity = ChefEntity(initialNodePosition: origin.point(with: tileSize))
        
        let observingArea = EntityObserverComponent.ObservingArea(frame: TiledRect(origin: TiledPoint.zero, size: TiledSize(6, 6)), isLocal: true)
        let entityObserverComponent = EntityObserverComponent(entityTags: ["Player"], observingAreas: [observingArea])
        entity.addComponent(entityObserverComponent)
        
        return entity
    }()
    
    override func setupScene() {
        super.setupScene()
        
        let talkProfile = InputProfile(name: "Talk") { profile in
            profile.positiveKeys = [.returnEnter,
                                    .keypadEnter,
                                    .allControllersButtonX]
        }
        Input.shared.addInputProfile(talkProfile)
        
        addEntity(npcEntity)
        addEntity(playerEntity)
        
        setupTips()
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if npcEntity.transform.componentInChildren(ofType: FocusableComponent.self)?.wasSelected == true {
            if let conversation = conversation {
                startFlowForConversation(conversation)
            }
        }
    }
    
    func setupTips() {
        #if os(OSX)
        let text = """
                    Approach and enjoy a quality conversation with this one eyed gentleman.
                    Use the keyboard (enter) or a game controller (X) to start the conversation when near the NPC.
                    """
        let tipEntity = GameplayTipEntity(initialNodePosition: TiledPoint(5, 13).point(with: tileSize),
                                          text: text,
                                          frameWidth: 280.0)
        addEntity(tipEntity)
        #elseif os(iOS)
        
        var tipWidth: CGFloat = 240.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            tipWidth = 260.0
        }
        
        let text = """
                    Approach and enjoy a quality conversation with this one eyed gentleman.
                    Use the touch button that will appear or controller (X) to start the conversation when near the NPC.
                    """
        let tipEntity = GameplayTipEntity(initialNodePosition: TiledPoint(5, 13).point(with: tileSize),
                                          text: text,
                                          frameWidth: tipWidth)
        addEntity(tipEntity)
        #elseif os(tvOS)
        let text = """
                    Approach and enjoy a quality conversation with this one eyed gentleman.
                    Use the (play) on remote or controller (X) to start the conversation when near the NPC.
                    """
        let tipEntity = GameplayTipEntity(initialNodePosition: TiledPoint(6, 15).point(with: tileSize),
                                          text: text,
                                          frameWidth: 500.0)
        addEntity(tipEntity)
        #endif
    }
    
    deinit {
        Input.shared.removeInputProfilesNamed("Talk")
    }
}
