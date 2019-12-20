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
        addChild(backgroundImage)
        addChild(waterLevel)
        waterLevel.shader = liquidShader
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
