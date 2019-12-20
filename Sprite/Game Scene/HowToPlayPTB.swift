//
//  MenuScene.swift
//  Sprite
//
//  Created by Felix Kylie on 14/10/19.
//  Copyright © 2019 Felix Kylie. All rights reserved.
//

import SpriteKit
import WatchConnectivity
import HealthKit

class HowToPlayPTB: SKScene {

    var appDelegate: AppDelegate = AppDelegate()
    var player: String?
    var wcSession = WCSession.default
    
    lazy var dimPanel: SKSpriteNode = {
        var node = SKSpriteNode(color: UIColor.black, size: self.size)
        node.alpha = 0.8
        node.zPosition = -2
        node.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        return node
    }()
    
    lazy var background: SKSpriteNode = {
        var node = SKSpriteNode(imageNamed: "howtoplay_ptb")
        node.setScale(1)
        node.position = CGPoint(x: frame.midX, y: frame.midY)
        node.zPosition = -1
        return node
    }()

    override func didMove(to view: SKView) {
        
        if self.wcSession.isReachable == true{
            self.wcSession.sendMessage(["watchactivation":"start"], replyHandler: nil, errorHandler: { (error) -> Void in
                print("failed with error \(error)")
            })
        } else{
            print("not reachable")
        }
        
        appDelegate.musicPlayer.stopBackgroundMusic()
        appDelegate.musicPlayer.startGameBackgroundMusic()  
        
        addChild(dimPanel)
        addChild(background)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
                let scene = GamePump(size: self.size)
                scene.appDelegate.MPC = self.appDelegate.MPC
                scene.appDelegate.musicPlayer = self.appDelegate.musicPlayer
                scene.player = self.player
                self.view?.presentScene(scene)
//                MusicPlayer.shared.clickSoundEffect()
//                if let view = view {
//                    let transition:SKTransition = SKTransition.fade(withDuration: 1)
//                    let scene = CreateRoom(size: self.size)
//                    scene.appDelegate.musicPlayer = self.appDelegate.musicPlayer
//                    self.view?.presentScene(scene, transition: transition)
//                }
            
        }
    }
}
