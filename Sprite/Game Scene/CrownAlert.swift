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


class CrownAlert: SKScene {
    
    var background = SKSpriteNode()
    var muted: Bool = false
    var appDelegate: AppDelegate = AppDelegate()
    var wcSessionConnected: Bool = false
    var wcSession = WCSession.default
    var player: String?

    override func didMove(to view: SKView) {
        appDelegate.musicPlayer.stopMusic()
        
        background.size = CGSize(width: 552, height: 1194)
        background.texture = SKTexture(imageNamed: "alert crown")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = 0
        background.setScale(0.8)
        addChild(background)
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: {_ in
            self.move()
        })
    }
    
    func move(){
        if let view = view {
            let transition:SKTransition = SKTransition.fade(withDuration: 1)
//            let scene = GameLadderTittle(size: self.size)
            let scene = GameLadder(size: self.size)
            scene.appDelegate.MPC = self.appDelegate.MPC
            scene.appDelegate.musicPlayer = self.appDelegate.musicPlayer
            scene.player = self.player
            self.view?.presentScene(scene, transition: transition)
        }
    }
    
}
