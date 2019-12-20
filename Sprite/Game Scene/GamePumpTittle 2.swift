//
//  GamePumpTittle.swift
//  Sprite
//
//  Created by dimas pratama on 28/10/19.
//  Copyright © 2019 Felix Kylie. All rights reserved.
//

import SpriteKit
import GameplayKit

class GamePumpTittle: SKScene {
    
    lazy var greenBalloon: SKSpriteNode = {
        var node = SKSpriteNode(imageNamed: "greenBalloonTittle")
        node.position = CGPoint(x: frame.origin.x + frame.width / 16 * 7, y: frame.origin.y + frame.height / 64 * 18)
        node.zPosition = 1
        node.setScale(1.5 * 0.67)
        return node
    }()
    
    lazy var redBalloon: SKSpriteNode = {
        var node = SKSpriteNode(imageNamed: "redBalloonTittle")
        node.position = CGPoint(x: frame.origin.x + frame.width / 16 * 9.5, y: frame.origin.y + frame.height / 64 * 13)
        node.zPosition = 2
        node.setScale(1.5 * 0.67)
        return node
    }()
    
    lazy var backgroundImage: SKSpriteNode = {
        var node = SKSpriteNode(imageNamed: "tittleScreenPTB")
        node.position = CGPoint(x: frame.midX, y: frame.midY)
        node.zPosition = 0
        node.setScale(1.5 * 0.67)
        return node
    }()
    
    
    
    override func didMove(to view: SKView) {
        addChild(redBalloon)
        runAnimateBalloon()
        addChild(greenBalloon)
        
        addChild(backgroundImage)
        
        
    }
    
    func runAnimateBalloon(){
        let moveUp = SKAction.move(by: CGVector(dx: 0, dy: 50), duration: TimeInterval(Double.random(in: 1.8...2.0)))
        moveUp.timingMode = SKActionTimingMode.easeInEaseOut
        let moveDown = SKAction.move(by: CGVector(dx: 0, dy: -50), duration: TimeInterval(Double.random(in: 1.8...2.0)))
        moveDown.timingMode = SKActionTimingMode.easeInEaseOut
        let wait = SKAction.wait(forDuration: TimeInterval(Double.random(in: 0.1...0.3)))
        redBalloon.run(SKAction.sequence([wait,SKAction.repeatForever(SKAction.sequence([moveUp,moveDown]))]))
        
        greenBalloon.run(SKAction.repeatForever(SKAction.sequence([moveUp,moveDown])))
        
//        balloon.physicsBody?.velocity = CGVector(dx: 0, dy: 50)
//        balloon.physicsBody?.applyForce(CGVector(dx: 0, dy: 50))
    }
    
//    func runBottomExplotion() {
//        let part1 = SKSpriteNode(imageNamed: "explotion1")
//        part1.setScale(0.17 * 0.67)
//        part1.position = CGPoint(x: frame.origin.x + frame.width / 2, y: frame.origin.y + frame.height / 10 * 4)
//        part1.anchorPoint = CGPoint(x: 0.5, y: 0)
//        part1.zPosition = 1
//
//        let scale = SKAction.scale(by: 1.3, duration: 1)
//        scale.timingMode = SKActionTimingMode.easeOut
//        part1.run(scale)
//        addChild(part1)
//    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
