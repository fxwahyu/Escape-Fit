//
//  Prologue.swift
//  Sprite
//
//  Created by dimas pratama on 28/10/19.
//  Copyright © 2019 Felix Kylie. All rights reserved.
//
import SpriteKit
import GameplayKit

struct layerStory{
    static let backgroundCity:CGFloat = -20000
    static let skyBackground:CGFloat = -20
    static let cloudBackground:CGFloat = -19
    static let backBuilding:CGFloat = -10
    static let frontBuilding:CGFloat = 1
    static let carToLeft:CGFloat = 3
    static let carToRight:CGFloat = 2
    static let semakSemak:CGFloat = 4
    
    static let bigMeteor:CGFloat = 2
    static let boy:CGFloat = 5
    static let girl:CGFloat = 5
    static let circle:CGFloat = 6
}

class Prologue: SKScene {
        
    lazy var backBuilding: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "backBuildingStory")
        node.zPosition = layerStory.backBuilding
        node.size = CGSize(width: 1667, height: 900)
        node.anchorPoint = CGPoint(x: 0, y: 0.5)
        node.position = CGPoint(x: frame.origin.x , y: frame.origin.x + frame.height / 128 * 35)
        node.setScale(1.5 * 0.67)
        return node
    }()
    
    lazy var frontBuilding: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "frontBuildingStory")
        node.zPosition = layerStory.frontBuilding
        node.size = CGSize(width: 1667, height: 900)
        node.anchorPoint = CGPoint(x: 0, y: 0.5)
        node.position = CGPoint(x: frame.origin.x , y: frame.origin.x + frame.height / 128 * 35)
        node.setScale(1.5 * 0.67)
        return node
    }()
    
    lazy var cloudBackground: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "cloudStory")
        node.zPosition = layerStory.cloudBackground
        node.size = CGSize(width: 1667, height: 900)
        node.anchorPoint = CGPoint(x: 0, y: 0.5)
        node.position = CGPoint(x: frame.origin.x , y: frame.origin.x + frame.height / 128 * 35)
        node.setScale(1.5 * 0.67)
        return node
    }()
    
    lazy var skyBackground: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "skyStory")
        node.zPosition = layerStory.skyBackground
        node.size = CGSize(width: 1667, height: 900)
        node.anchorPoint = CGPoint(x: 0, y: 0.5)
        node.position = CGPoint(x: frame.origin.x , y: frame.origin.x + frame.height / 128 * 35)
        node.setScale(1.5 * 0.67)
        return node
    }()
    
    lazy var carToLeft: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "carToLeftStory")
        node.zPosition = layerStory.carToLeft
        node.size = CGSize(width: 1667, height: 900)
        node.anchorPoint = CGPoint(x: 0, y: 0.5)
        node.position = CGPoint(x: frame.origin.x , y: frame.origin.x + frame.height / 128 * 35)
        node.setScale(1.5 * 0.67)
        return node
    }()
    
    lazy var carToRight: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "carToRightStory")
        node.zPosition = layerStory.carToRight
        node.size = CGSize(width: 1667, height: 900)
        node.anchorPoint = CGPoint(x: 1, y: 0.5)
        node.position = CGPoint(x: frame.origin.x + frame.width, y: frame.origin.x + frame.height / 128 * 35)
        node.setScale(1.5 * 0.67)
        return node
    }()
    
    lazy var semakSemak: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "semakSemak")
        node.zPosition = layerStory.backBuilding
        node.size = CGSize(width: 1667, height: 900)
        node.anchorPoint = CGPoint(x: 0, y: 0.5)
        node.position = CGPoint(x: frame.origin.x , y: frame.origin.x + frame.height / 128 * 35)
        node.setScale(1.5 * 0.67)
        return node
    }()
    
    lazy var bigMeteor: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "meteor")
        node.zPosition = layerStory.bigMeteor
        node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        node.position = CGPoint(x: frame.origin.x + (frame.width / 4 * 3) - frame.height / 4 * 3   , y: frame.origin.y + (frame.height / 4) + frame.height / 4 * 3)
        node.setScale(3 * 0.67)
        node.anchorPoint = CGPoint(x: 0.8, y: 0.3)
        return node
    }()
    
    lazy var circle: SKShapeNode = {
        var Circle = SKShapeNode(circleOfRadius: 1 ) // Size of Circle
        Circle.position = CGPoint(x: frame.origin.x + (frame.width / 4 * 3), y: frame.origin.y + (frame.height / 4))
        Circle.strokeColor = .red
        Circle.glowWidth = 1.0
        Circle.fillColor = .red
        Circle.zPosition = layerStory.circle
        Circle.alpha = 0
        return Circle
    }()
    
    lazy var boy: SKSpriteNode = { // DI KANAN
        let node = SKSpriteNode(imageNamed: "boyLoadingScreen1")
        node.zPosition = layerStory.boy
        node.position = CGPoint(x: frame.origin.x + frame.width + (frame.width / 4), y: frame.origin.y)
        node.setScale(0.4 * 0.67)
        return node
    }()
    
    lazy var girl: SKSpriteNode = { //DI KIRI
        let node = SKSpriteNode(imageNamed: "girlLoadingScreen1")
        node.zPosition = layerStory.girl
        node.position = CGPoint(x: frame.origin.x - frame.width / 4 , y: frame.origin.y)
        node.setScale(0.4 * 0.67)
        return node
    }()
    
    override func didMove(to view: SKView) {
        addChild(backBuilding)
        addChild(frontBuilding)
        addChild(cloudBackground)
        addChild(skyBackground)
        addChild(carToLeft)
        addChild(carToRight)
        addChild(semakSemak)
        slideBackground(mySprite: backBuilding, jarak: 0.5)
        slideBackground(mySprite: frontBuilding, jarak: 0.8)
        slideBackground(mySprite: cloudBackground, jarak: 0.3)
        slideBackground(mySprite: semakSemak, jarak: 1.0)
        slideBackground(mySprite: carToLeft, jarak: 3.0)
        slideRight(mySprite: carToRight, jarak: 2.0)
        
        Timer.scheduledTimer(withTimeInterval: 0, repeats: false, block: {_ in
            self.runTimerMeteor()
        })
        
        Timer.scheduledTimer(withTimeInterval: 15, repeats: false, block: {_ in
            self.addChild(self.boy)
            self.addChild(self.girl)
            self.kaget()
        })
        
        Timer.scheduledTimer(withTimeInterval: 21, repeats: false, block: {_ in
            self.addChild(self.bigMeteor)
            self.animateMeteor()
        })
        
        Timer.scheduledTimer(withTimeInterval: 23, repeats: false, block: {_ in
            self.addChild(self.circle)
            self.dimScreen()
        })
    }
    
    func runTimerMeteor(){
            Timer.scheduledTimer(withTimeInterval: TimeInterval(Double.random(in: 1.0...1.5 )), repeats: true, block: {_ in
                self.createMeteor()
            })
    }
    
    func createMeteor(){
        let meteorSprite = SKSpriteNode(imageNamed: "meteor")
        meteorSprite.position = CGPoint(
            x: CGFloat.random(in: frame.origin.x + frame.width / 2...frame.origin.x + frame.width * 1.2),
            y: CGFloat.random(in: frame.origin.y + frame.height...frame.origin.y + frame.height * 1.2))
        let jarak = Double.random(in: 0.1...0.9)
        meteorSprite.zPosition = CGFloat((jarak) * 10) - 10
        let fallMovement = SKAction.moveBy(x: -1125 / 8 * 6 , y: -2001 / 8 * 7, duration: 20 / jarak)
        fallMovement.timingMode = SKActionTimingMode.easeOut
        meteorSprite.scale(to: CGSize(width: Double(meteorSprite.size.width) * jarak, height: Double(meteorSprite.size.height) * jarak))
        meteorSprite.run(fallMovement, completion: meteorSprite.removeFromParent)
        addChild(meteorSprite)
    }
    
    func kaget(){
        let girlIn = SKAction.move(to: CGPoint(x: frame.origin.x + frame.width / 4 * 1,
                                               y: frame.origin.y + frame.height / 8), duration: 1)
        girlIn.timingMode = SKActionTimingMode.easeIn
        let boyIn = SKAction.move(to: CGPoint(x: frame.origin.x + frame.width / 4 * 3,
                                              y: frame.origin.y + frame.height / 8), duration: 1)
        boyIn.timingMode = SKActionTimingMode.easeIn
        let wait = SKAction.wait(forDuration: 2)
        let girlOut = SKAction.move(to: CGPoint(x: frame.origin.x - frame.width / 4 ,
                                                y: frame.origin.y - frame.height / 8), duration: 1)
        girlOut.timingMode = SKActionTimingMode.easeOut
        let boyOut = SKAction.move(to: CGPoint(x: frame.origin.x + frame.width + (frame.width / 4),
                                               y: frame.origin.y - frame.height / 8), duration: 1)
        boyOut.timingMode = SKActionTimingMode.easeOut
        girl.run(SKAction.sequence([girlIn,wait,girlOut]))
        boy.run(SKAction.sequence([boyIn,wait,boyOut]))
    }
    
    func dimScreen(){
        circle.alpha = 1
        let dimScreen = SKAction.scale(to: CGFloat(1000), duration: 0.8)
        circle.run(dimScreen)
    }
    
    func animateMeteor(){
        let fallMovement = SKAction.move(to: CGPoint(x: frame.origin.x + frame.width / 4 * 3 ,
                                                     y: frame.origin.y + frame.height / 4), duration: 2)
        bigMeteor.run(SKAction.sequence([fallMovement]))
    }
    
    func slideBackground(mySprite:SKSpriteNode,jarak:Double){
        let slideToLeft = SKAction.moveBy(x: -mySprite.size.width + frame.width, y: 0, duration: 24 / jarak)
        mySprite.run(slideToLeft)
    }
    
    func slideRight(mySprite:SKSpriteNode, jarak:Double){
        let slideToRight = SKAction.moveBy(x: mySprite.size.width + frame.width, y: 0, duration: 24 / jarak)
        mySprite.run(slideToRight)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
