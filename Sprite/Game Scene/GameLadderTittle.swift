//
//  GameLadderTittle.swift
//  Sprite
//
//  Created by dimas pratama on 28/10/19.
//  Copyright © 2019 Felix Kylie. All rights reserved.
//


import SpriteKit
import GameplayKit

class GameLadderTittle: SKScene {
    
    var appDelegate: AppDelegate = AppDelegate()
    var player: String?
    
    lazy var backgroundImage: SKSpriteNode = {
        var node = SKSpriteNode(imageNamed: "ladderGameTittle") // Size of Circle
        node.position = CGPoint(x: frame.midX, y: frame.midY)
        node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        node.zPosition = 0
        node.alpha = 1
        node.setScale(1.5 * 0.67)
        return node
    }()
    
    lazy var waterLevel: SKSpriteNode = {
        var node = SKSpriteNode(imageNamed: "waterGameTittle") // Size of Circle
        node.position = CGPoint(x: frame.midX, y: frame.minY)
        node.anchorPoint = CGPoint(x: 0.5, y: 0.1)
        node.zPosition = 1
        node.alpha = 1
        node.setScale(1.5 * 0.67)
        return node
    }()
    
    let liquidShader = SKShader(fileNamed: "simpleLiquidShader.fsh")
    
//    let waterAnimation = SKShader(fileNamed: "poolWaterShader.fsh")
    
    override func didMove(to view: SKView) {
        MusicPlayer.shared.ladderTitle()
        addChild(backgroundImage)
        addChild(waterLevel)
        waterLevel.shader = liquidShader
        naikTurun(water: waterLevel)
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: {_ in
            self.pindahHalaman()
        })
    }
    
    func pindahHalaman(){
        if let view = view {
            let transition:SKTransition = SKTransition.fade(withDuration: 0)
            let scene = GameLadder(size: self.size)
            scene.appDelegate.MPC = self.appDelegate.MPC
            scene.appDelegate.musicPlayer = self.appDelegate.musicPlayer
            scene.player = self.player
            self.view?.presentScene(scene, transition: transition)
        }
    }
    
    func naikTurun(water:SKSpriteNode){
        let moveUp = SKAction.moveBy(x: 0, y: 12, duration: 0.8)
        moveUp.timingMode = SKActionTimingMode.easeInEaseOut
        let moveDown = SKAction.moveBy(x: 0, y: -12, duration: 0.8)
        moveDown.timingMode = SKActionTimingMode.easeInEaseOut
        water.run(SKAction.repeatForever(SKAction.sequence([moveUp,moveDown])))
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
