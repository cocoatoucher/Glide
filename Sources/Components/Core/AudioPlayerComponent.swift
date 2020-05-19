//
//  AudioPlayerComponent.swift
//  glide
//
//  Copyright (c) 2020 cocoatoucher user on github.com (https://github.com/cocoatoucher/)
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

/// Component that is used to play audio clips on the entity's sprite node.
/// Uses `SKAudioNodes`s as clips for playing audio and uses predefined
/// trigger ids to play/stop associated clips.
///
/// Required components: `SpriteNodeComponent`
public final class AudioPlayerComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 925
    
    /// Add an audio clip which can be triggered at a later time.
    ///
    /// - Parameters:
    ///     - clip: Audio clip to be added.
    public func addClip(_ clip: AudioClip) {
        guard clips.contains(where: { $0.id == clip.id }) == false else {
            fatalError("A clip with same id already exists.")
        }
        guard clips.contains(where: { $0.triggerName == clip.triggerName }) == false else {
            fatalError("Clip trigger with same name already exists.")
        }
        clips.append(clip)
    }
    
    /// Retrieve the audio clip with the given trigger name.
    ///
    /// - Parameters:
    ///     - triggerName: Trigger name of the desired audio clip.
    public func clip(with triggerName: String) -> AudioClip? {
        return clips.first { $0.triggerName == triggerName }
    }
    
    /// Enable a trigger to be played at the next update.
    ///
    /// - Parameters:
    ///     - triggerName: Trigger name of the desired audio clip.
    public func enableClip(with triggerName: String) {
        let clip = clips.first { $0.triggerName == triggerName }
        clip?.isTriggerEnabled = true
    }
    
    public func didFinishUpdate() {
        clips.forEach { $0.isTriggerEnabled = false }
    }
    
    // MARK: - Private
    
    private var clips: [AudioClip] = []
    
    private func playClips() {
        let activatedClips = clips.filter { $0.isTriggerEnabled }
        
        let spriteNodeComponent = entity?.component(ofType: SpriteNodeComponent.self)
        let node = spriteNodeComponent?.node
        
        for node in node?.children.filter({ $0 is SKAudioNode }) ?? [] {
            
            let audioNode = node as? SKAudioNode
            
            if activatedClips.first(where: { $0.audioNode == audioNode }) == nil {
                if audioNode?.autoplayLooped == true {
                    audioNode?.removeFromParent()
                }
            }
        }
        
        for clip in activatedClips {
            if clip.audioNode.autoplayLooped {
                if clip.audioNode.parent == nil {
                    node?.addChild(clip.audioNode)
                }
            } else {
                if clip.audioNode.parent == nil {
                    node?.addChild(clip.audioNode)
                }
                clip.play()
            }
        }
    }
}

extension AudioPlayerComponent: ActionsEvaluatorComponent {
    func sceneDidEvaluateActions() {
        playClips()
    }
}
