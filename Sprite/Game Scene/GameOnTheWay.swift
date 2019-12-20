//
//  GameOnTheWay.swift
//  Sprite
//
//  Created by dimas pratama on 13/11/19.
//  Copyright © 2019 Felix Kylie. All rights reserved.
//
// LOKASI KETIKA SAMPAI background x location = -1282

import SpriteKit
import WatchConnectivity

struct collisionBitMask {
    static let playerOneCategory:UInt32 = 0x1 << 1
    static let playerTwoCategory:UInt32 = 0x1 << 2
    static let buildingCategory:UInt32 = 0x1 << 3
    static let airplaneCategory:UInt32 = 0x1 << 4
    static let groundCategory:UInt32 = 0x1 << 5 // atas-bawah-kiri-kanan
}

struct layerFlappyGame {
    static let background:CGFloat = 0
    static let airplane:CGFloat = 1
    static let building:CGFloat = 1
    static let ground:CGFloat = 2
    var playerTwo:CGFloat = 3
    var playerOne:CGFloat = 4
}

class GameFlappy: SKScene, SKPhysicsContactDelegate{
    
    var counterPrint = 0

//    MARK: GLOBAL VARIABLE
    var gameStarted = Bool(false)
    var isPlayerOneAlive = Bool(true)
    var isPlayerTwoAlive = Bool(true)
    var isPlayerOneFinished = Bool(false)
    var isPlayerTwoFinished = Bool(false)
    var isLastBuildingHasBeenSpawn = Bool(false)
    var countSpawnAirplane = 0
    
    var player: String!
    var appDelegate: AppDelegate! = AppDelegate()
    var wcSession = WCSession.default

    var boyFlapTextures:[SKTexture] = []    // TEXTURE
    var boyFlapAnimate = SKAction()         // ACTION
    var landedBoyTextures:[SKTexture] = []  // TEXTURE
    var landedBoyAnimate = SKAction()       // ACTION

    var girlFlapTextures:[SKTexture] = []   // TEXTURE
    var girlFlapAnimate = SKAction()        // ACTION
    var landedGirlTextures:[SKTexture] = [] // TEXTURE
    var landedGirlAnimate = SKAction()      // ACTION

    var whenDieAnimate = SKAction()         // ACTION
    var characterBoy = SKSpriteNode()       // NODE

    var background = SKSpriteNode() //NODE background
    var ground = SKSpriteNode()     //NODE gedung
    var playerOne = SKSpriteNode() // KARAKTER P1
    var playerTwo = SKSpriteNode() // KARAKTER P2
    let jarakBackground = 0.5   // digunakan utk mengatur kecepatan
    let jarakGround = 1.2       // digunakan utk mengatur kecepatan
    var moveToLeftGround = SKAction()   // ACTION
    
    var timerGirlComputerFlap: Timer?   // pergerakan karakter cewek
    var xLastLocationPlayerTwo:CGFloat = 103.5 // untuk spawn ulang player two
    
    func shapeLandingLastBuilding()->UIBezierPath{
        let shape = UIBezierPath()
        shape.move(to: CGPoint(x: frame.origin.x, y: frame.origin.y))
        shape.addLine(to: CGPoint(x: frame.origin.x, y: frame.height / 64 * 31))
        shape.addLine(to: CGPoint(x: frame.width, y: frame.height / 64 * 31))
        shape.addLine(to: CGPoint(x: frame.width, y: frame.origin.y))
        shape.close()
        return shape
    }

    func bentukFifteen()->UIBezierPath{
        let shape = UIBezierPath()
        shape.move(to: CGPoint(x: 116.31, y: 139))
        shape.addLine(to: CGPoint(x: 142, y: 139))
        shape.addLine(to: CGPoint(x: 142, y: 564))
        shape.addLine(to: CGPoint(x: 215, y: 564))
        shape.addLine(to: CGPoint(x: 215, y: 253.06))
        shape.addLine(to: CGPoint(x: 222.14, y: 248.34))
        shape.addLine(to: CGPoint(x: 234.74, y: 202))
        shape.addLine(to: CGPoint(x: 265.46, y: 202))
        shape.addLine(to: CGPoint(x: 268, y: 240.91))
        shape.addLine(to: CGPoint(x: 319, y: 268.38))
        shape.addLine(to: CGPoint(x: 319, y: 564))
        shape.addLine(to: CGPoint(x: 354, y: 564))
        shape.addLine(to: CGPoint(x: 354, y: 480.81))
        shape.addLine(to: CGPoint(x: 369.08, y: 458.24))
        shape.addLine(to: CGPoint(x: 394.32, y: 434))
        shape.addLine(to: CGPoint(x: 443.32, y: 434))
        shape.addLine(to: CGPoint(x: 470.66, y: 451.15))
        shape.addLine(to: CGPoint(x: 495, y: 479.43))
        shape.addLine(to: CGPoint(x: 495, y: 564))
        shape.addLine(to: CGPoint(x: 506, y: 564))
        shape.addLine(to: CGPoint(x: 506, y: 217.87))
        shape.addLine(to: CGPoint(x: 542.58, y: 198.85))
        shape.addLine(to: CGPoint(x: 542.58, y: 151))
        shape.addLine(to: CGPoint(x: 559.52, y: 151))
        shape.addLine(to: CGPoint(x: 588, y: 193.64))
        shape.addLine(to: CGPoint(x: 588, y: 564))
        shape.addLine(to: CGPoint(x: 689, y: 564))
        shape.addLine(to: CGPoint(x: 689, y: 444.02))
        shape.addLine(to: CGPoint(x: 790.12, y: 444.02))
        shape.addLine(to: CGPoint(x: 790.12, y: 157))
        shape.addLine(to: CGPoint(x: 821.31, y: 157))
        shape.addLine(to: CGPoint(x: 821.31, y: 179.72))
        shape.addLine(to: CGPoint(x: 896.5, y: 177.97))
        shape.addLine(to: CGPoint(x: 913, y: 202))
        shape.addLine(to: CGPoint(x: 913, y: 564))
        shape.addLine(to: CGPoint(x: 949, y: 564))
        shape.addLine(to: CGPoint(x: 949, y: 451))
        shape.addLine(to: CGPoint(x: 1057, y: 451.15))
        shape.addLine(to: CGPoint(x: 1057, y: 564))
        shape.addLine(to: CGPoint(x: 1141, y: 564))
        shape.addLine(to: CGPoint(x: 1141.87, y: 122.28))
        shape.addLine(to: CGPoint(x: 1160.93, y: 122.28))
        shape.addLine(to: CGPoint(x: 1160.93, y: 43.61))
        shape.addLine(to: CGPoint(x: 1195.57, y: 43.61))
        shape.addLine(to: CGPoint(x: 1195.57, y: 0))
        shape.addLine(to: CGPoint(x: 1209.15, y: 0))
        shape.addLine(to: CGPoint(x: 1209.15, y: 43.61))
        shape.addLine(to: CGPoint(x: 1247.45, y: 43.61))
        shape.addLine(to: CGPoint(x: 1247.45, y: 121.3))
        shape.addLine(to: CGPoint(x: 1263, y: 121.3))
        shape.addLine(to: CGPoint(x: 1264, y: 564))
        shape.addLine(to: CGPoint(x: 1411, y: 564))
        shape.addLine(to: CGPoint(x: 1411, y: 357))
        shape.addLine(to: CGPoint(x: 1544, y: 357))
        shape.addLine(to: CGPoint(x: 1544, y: 564))
        shape.addLine(to: CGPoint(x: 1555, y: 564))
        shape.addLine(to: CGPoint(x: 1555, y: 472.37))
        shape.addLine(to: CGPoint(x: 1608.37, y: 399))
        shape.addLine(to: CGPoint(x: 1640.23, y: 399))
        shape.addLine(to: CGPoint(x: 1655.59, y: 424.03))
        shape.addLine(to: CGPoint(x: 1669, y: 498))
        shape.addLine(to: CGPoint(x: 1669, y: 564))
        shape.addLine(to: CGPoint(x: 1707, y: 564))
        shape.addLine(to: CGPoint(x: 1707, y: 32))
        shape.addLine(to: CGPoint(x: 1723.7, y: 33))
        shape.addLine(to: CGPoint(x: 1818, y: 75.91))
        shape.addLine(to: CGPoint(x: 1818, y: 564))
        shape.addLine(to: CGPoint(x: 1920, y: 564))
        shape.addLine(to: CGPoint(x: 1920, y: 331))
        shape.addLine(to: CGPoint(x: 2042, y: 331))
        shape.addLine(to: CGPoint(x: 2042, y: 409))
        shape.addLine(to: CGPoint(x: 2150, y: 409))
        shape.addLine(to: CGPoint(x: 2150, y: 9))
        shape.addLine(to: CGPoint(x: 2233.87, y: 112.99))
        shape.addLine(to: CGPoint(x: 2272, y: 224.36))
        shape.addLine(to: CGPoint(x: 2272, y: 564))
        shape.addLine(to: CGPoint(x: 2303, y: 564))
        shape.addLine(to: CGPoint(x: 2303, y: 405.34))
        shape.addLine(to: CGPoint(x: 2339.06, y: 335))
        shape.addLine(to: CGPoint(x: 2417.11, y: 336))
        shape.addLine(to: CGPoint(x: 2467, y: 391))
        shape.addLine(to: CGPoint(x: 2467, y: 564))
        shape.addLine(to: CGPoint(x: 2498, y: 564))
        shape.addLine(to: CGPoint(x: 2498, y: 264.32))
        shape.addLine(to: CGPoint(x: 2606, y: 239))
        shape.addLine(to: CGPoint(x: 2606, y: 564))
        shape.addLine(to: CGPoint(x: 2753, y: 564))
        shape.addLine(to: CGPoint(x: 2753, y: 336))
        shape.addLine(to: CGPoint(x: 2775.34, y: 336))
        shape.addLine(to: CGPoint(x: 2775.34, y: 357))
        shape.addLine(to: CGPoint(x: 2848, y: 364.88))
        shape.addLine(to: CGPoint(x: 2848, y: 564))
        shape.addLine(to: CGPoint(x: 2860, y: 564))
        shape.addLine(to: CGPoint(x: 2860, y: 437))
        shape.addLine(to: CGPoint(x: 2953, y: 439))
        shape.addLine(to: CGPoint(x: 2953, y: 419.78))
        shape.addLine(to: CGPoint(x: 3050.14, y: 268.38))
        shape.addLine(to: CGPoint(x: 3084.26, y: 269))
        shape.addLine(to: CGPoint(x: 3128, y: 347.31))
        shape.addLine(to: CGPoint(x: 3128, y: 564))
        shape.addLine(to: CGPoint(x: 3181, y: 564))
        shape.addLine(to: CGPoint(x: 3181, y: 234.55))
        shape.addLine(to: CGPoint(x: 3234.81, y: 223.24))
        shape.addLine(to: CGPoint(x: 3354.54, y: 210))
        shape.addLine(to: CGPoint(x: 3468, y: 210))
        shape.addLine(to: CGPoint(x: 3468, y: 640)) // GARIS PANJANG
        shape.addLine(to: CGPoint(x: 0, y: 640))  // minX = 0 maxX = 3468
        shape.addLine(to: CGPoint(x: 0, y: 139))   // minY = 27 maxY = 640
        shape.addLine(to: CGPoint(x: 116.31, y: 139))     // Y = + 139
        shape.addLine(to: CGPoint(x: 116.31, y: 139))
        shape.close()
        return shape
    }

    func runPhysicsWorld(){
        self.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: frame.origin.x, y: frame.height), to: CGPoint(x: frame.width, y: frame.height))
        self.physicsBody?.categoryBitMask = collisionBitMask.groundCategory
        self.physicsBody?.collisionBitMask = collisionBitMask.playerOneCategory | collisionBitMask.playerTwoCategory
        self.physicsBody?.contactTestBitMask = collisionBitMask.playerOneCategory | collisionBitMask.playerTwoCategory
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
    }

    func runCreatePlayerOne(){
        playerOne = SKSpriteNode(texture: SKTexture(imageNamed:"flapBoy1"))
        let scale = 0.3
        playerOne.name = "PlayerOne"
        playerOne.size = CGSize(width: 402.86 * scale, height: 684.22 * scale)
        playerOne.position = CGPoint(x:self.frame.origin.x + self.frame.width / 4, y:self.frame.origin.y + self.frame.height / 8 * 5)
        playerOne.zPosition = layerFlappyGame.playerOne
        playerOne.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        playerOne.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 30), center: CGPoint(x: 1.0, y: 0))
        playerOne.physicsBody?.mass = 0.09
        playerOne.physicsBody?.linearDamping = 1.1
        playerOne.physicsBody?.restitution = 0
        playerOne.physicsBody?.categoryBitMask = collisionBitMask.playerOneCategory
        playerOne.physicsBody?.collisionBitMask = collisionBitMask.buildingCategory | collisionBitMask.groundCategory | collisionBitMask.airplaneCategory
        playerOne.physicsBody?.contactTestBitMask = collisionBitMask.buildingCategory | collisionBitMask.groundCategory | collisionBitMask.airplaneCategory
        playerOne.physicsBody?.affectedByGravity = false
        playerOne.physicsBody?.isDynamic = true
        addChild(playerOne)
    }

    func runCreatePlayerTwo(){
        playerTwo = SKSpriteNode(texture: SKTexture(imageNamed:"flapGirl1"))
        let scale = 0.3
        playerTwo.name = "PlayerTwo"
        playerTwo.size = CGSize(width: 402.86 * scale, height: 684.22 * scale)
        playerTwo.position = CGPoint(x:xLastLocationPlayerTwo, y:self.frame.origin.y + self.frame.height / 8 * 5)
        playerTwo.zPosition = layerFlappyGame.playerTwo
        playerTwo.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        playerTwo.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 30), center: CGPoint(x: 1.0, y: 0))
        playerTwo.physicsBody?.mass = 0.09
        playerTwo.physicsBody?.linearDamping = 1.1
        playerTwo.physicsBody?.restitution = 0
        playerTwo.physicsBody?.categoryBitMask = collisionBitMask.playerTwoCategory
        playerTwo.physicsBody?.collisionBitMask = collisionBitMask.buildingCategory | collisionBitMask.groundCategory | collisionBitMask.airplaneCategory
        playerTwo.physicsBody?.contactTestBitMask = collisionBitMask.buildingCategory | collisionBitMask.groundCategory | collisionBitMask.airplaneCategory
        playerTwo.physicsBody?.affectedByGravity = false
        playerTwo.physicsBody?.isDynamic = true
        addChild(playerTwo)
    }

    //    MARK:TEXTURE ANIMATION
    func textureFlyingBoy(){
        boyFlapTextures.append(SKTexture(imageNamed: "flapBoy1"))
        boyFlapTextures.append(SKTexture(imageNamed: "flapBoy3"))
        boyFlapTextures.append(SKTexture(imageNamed: "flapBoy4"))
        boyFlapTextures.append(SKTexture(imageNamed: "flapBoy5"))
        boyFlapTextures.append(SKTexture(imageNamed: "flapBoy1"))
        boyFlapAnimate = SKAction.animate(with: boyFlapTextures, timePerFrame: 0.05)

        let disappear = SKAction.fadeOut(withDuration: 0.25)
        let appear = SKAction.fadeIn(withDuration: 0.25)
        let blink = SKAction.sequence([disappear,appear])
        whenDieAnimate = SKAction.repeat(blink, count: 5)
    }

    func textureLandedBoy(){
        landedBoyTextures.append(SKTexture(imageNamed: "flapBoy1"))
        landedBoyTextures.append(SKTexture(imageNamed: "flapBoy3"))
        landedBoyTextures.append(SKTexture(imageNamed: "flapBoy4"))
        landedBoyTextures.append(SKTexture(imageNamed: "flapBoy5"))
        landedBoyTextures.append(SKTexture(imageNamed: "flapBoy1"))
        landedBoyTextures.append(SKTexture(imageNamed: "landedBoy1"))
        landedBoyTextures.append(SKTexture(imageNamed: "landedBoy2"))
        landedBoyTextures.append(SKTexture(imageNamed: "landedBoy3"))
        landedBoyTextures.append(SKTexture(imageNamed: "landedBoy4"))
        landedBoyTextures.append(SKTexture(imageNamed: "landedBoy5"))
        landedBoyAnimate = SKAction.animate(with: landedBoyTextures, timePerFrame: 0.1)
    }

    func flapEndingGame(){
        playerOne.run(landedBoyAnimate)
    }

    func flapTheWing(){
        self.playerOne.run(boyFlapAnimate)
        playerOne.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        playerOne.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40 * 1.5))
    }

    //    MARK:TEXTURE ANIMATION GIRL
    func textureFlyingGirl(){
        girlFlapTextures.append(SKTexture(imageNamed: "flapGirl1"))
        girlFlapTextures.append(SKTexture(imageNamed: "flapGirl3"))
        girlFlapTextures.append(SKTexture(imageNamed: "flapGirl4"))
        girlFlapTextures.append(SKTexture(imageNamed: "flapGirl5"))
        girlFlapTextures.append(SKTexture(imageNamed: "flapGirl1"))
        girlFlapAnimate = SKAction.animate(with: girlFlapTextures, timePerFrame: 0.05)
    }

    func textureLandedGirl(){
        landedGirlTextures.append(SKTexture(imageNamed: "flapGirl1"))
        landedGirlTextures.append(SKTexture(imageNamed: "flapGirl3"))
        landedGirlTextures.append(SKTexture(imageNamed: "flapGirl4"))
        landedGirlTextures.append(SKTexture(imageNamed: "flapGirl5"))
        landedGirlTextures.append(SKTexture(imageNamed: "flapGirl1"))
        landedGirlTextures.append(SKTexture(imageNamed: "landedGirl1"))
        landedGirlTextures.append(SKTexture(imageNamed: "landedGirl2"))
        landedGirlTextures.append(SKTexture(imageNamed: "landedGirl3"))
        landedGirlTextures.append(SKTexture(imageNamed: "landedGirl4"))
        landedGirlTextures.append(SKTexture(imageNamed: "landedGirl5"))
        landedGirlAnimate = SKAction.animate(with: landedGirlTextures, timePerFrame: 0.1)
    }

    func flapEndingGameGirl(){
        playerTwo.run(landedGirlAnimate)
    }

    func flapTheWingGirl(){
        self.playerTwo.run(girlFlapAnimate)
        playerTwo.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        playerTwo.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40 * 1.5))
    }

    func automaticGirlComputer(){
        timerGirlComputerFlap = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true, block: {_ in
            if self.isPlayerTwoAlive == true {
                self.flapTheWingGirl()
            }
        })
    }

    func physicCity() -> SKShapeNode{
        let kotak = SKShapeNode(path: bentukFifteen().cgPath)
        kotak.position = CGPoint(x: frame.origin.x, y:  frame.origin.y + kotak.frame.height)
        kotak.alpha = 1
        kotak.zPosition = 9
        kotak.alpha = 0
        kotak.strokeColor = .black
        kotak.fillColor = .gray
        kotak.physicsBody = SKPhysicsBody(polygonFrom: bentukFifteen().cgPath)
        kotak.physicsBody?.categoryBitMask = collisionBitMask.buildingCategory
        kotak.physicsBody?.collisionBitMask = collisionBitMask.playerOneCategory
        kotak.physicsBody?.contactTestBitMask = collisionBitMask.playerOneCategory
        kotak.physicsBody?.isDynamic = false
        kotak.physicsBody?.affectedByGravity = false
        kotak.yScale = kotak.yScale * -1
        return kotak
    }
    
    func physicLastBuilding() -> SKShapeNode{
        let shape = SKShapeNode(path: shapeLandingLastBuilding().cgPath)
        shape.position = CGPoint(x: frame.origin.x, y: frame.origin.y)
        shape.physicsBody = SKPhysicsBody(polygonFrom: shapeLandingLastBuilding().cgPath)
        shape.physicsBody?.categoryBitMask = collisionBitMask.groundCategory
        shape.physicsBody?.collisionBitMask = collisionBitMask.playerOneCategory | collisionBitMask.playerTwoCategory
        shape.physicsBody?.isDynamic = false
        shape.physicsBody?.affectedByGravity = false
        return shape
    }
    
//    MARK:BACKGROUND NODE
    func runBackgroundAsset(){
        background = SKSpriteNode(imageNamed: "BackgroundFlappy")
        background.anchorPoint = CGPoint.init(x: 0, y: 0.5)
        background.position = CGPoint(x:0, y:self.frame.origin.y + frame.height / 2)
        background.name = "background"
        background.size = CGSize(width: 3468, height: 896)
        background.zPosition = layerFlappyGame.background
        addChild(background)
    }

//    MARK:GROUND NODE
    func runGroundAsset(){
        ground = SKSpriteNode(imageNamed: "AllGround")
        ground.anchorPoint = CGPoint.init(x: 0, y: 0)
        ground.position = CGPoint(x: self.frame.origin.x , y:self.frame.origin.y)
        ground.name = "ground"
        ground.zPosition = layerFlappyGame.ground
        addChild(ground)
    }

//    MARK:AIRPLANE NODE
    func airplaneAsset(xCoordinate:CGFloat, yCoordinate:CGFloat) -> SKSpriteNode{
        let airplane = SKSpriteNode(imageNamed: "airplane")
        airplane.name = "Airplane"
        airplane.position = CGPoint(x: xCoordinate, y: yCoordinate )
//        self.frame.height / 4 * 3
        airplane.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        airplane.setScale(1)
        airplane.zPosition = layerFlappyGame.airplane
        airplane.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: airplane.size.width, height: airplane.size.height))
        airplane.physicsBody?.categoryBitMask = collisionBitMask.airplaneCategory
        airplane.physicsBody?.collisionBitMask = collisionBitMask.playerOneCategory
        airplane.physicsBody?.contactTestBitMask = collisionBitMask.playerOneCategory
        airplane.physicsBody?.isDynamic = false
        airplane.physicsBody?.affectedByGravity = true
        return airplane
    }

    func runTheBackgroundMovement(){
        let moveToLeftBackground = SKAction.moveTo(x: -background.size.width, duration: 30  / jarakBackground)
        background.run(moveToLeftBackground)
        moveToLeftGround = SKAction.moveTo(x: -background.size.width, duration: 30  / jarakGround)
        let fisik = physicCity()
        fisik.zPosition = ground.zPosition + 1
        ground.addChild(fisik)
        ground.run(moveToLeftGround)
    }

    //    MARK:DIDMOVE
    override func didMove(to view: SKView) {
        
        runPhysicsWorld()

        runGroundAsset()
        runBackgroundAsset()

        runCreatePlayerOne()
        runCreatePlayerTwo()
        
        if player == "player1"{
            playerOne.zPosition = 4
            playerTwo.zPosition = 3
        } else{
            playerTwo.zPosition = 4
            playerOne.zPosition = 3
        }

        textureFlyingBoy()
        textureLandedBoy()

        textureFlyingGirl()
        textureLandedGirl()
        
        ground.addChild(airplaneAsset(xCoordinate: self.frame.width * 1.5, yCoordinate: self.frame.height / 8 * 7))
        ground.addChild(airplaneAsset(xCoordinate: self.frame.width * 7, yCoordinate: self.frame.height / 8 * 7))
    }

//    MARK: TOUCHES BEGAN
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false{
//          UNTUK AWAL MULAI GAME
            gameStarted =  true
            playerOne.physicsBody?.affectedByGravity = true
            playerTwo.physicsBody?.affectedByGravity = true
            self.ground.isPaused = false
            flapTheWing()
            runTheBackgroundMovement()
            automaticGirlComputer()
        } else if gameStarted == true {
            // KETIKA GAME SUDAH DIMULAI DAN ADA TAP
            if isPlayerOneAlive == true && isPlayerOneFinished == false {
                flapTheWing()
            }
        }
    }

//    MARK: DID BEGIN
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
//        print("Contact between : \(firstBody.node?.name) and \(secondBody.node?.name)")
        if isPlayerOneFinished == false && isPlayerOneAlive == true {
            if firstBody.categoryBitMask == collisionBitMask.playerOneCategory && secondBody.categoryBitMask == collisionBitMask.buildingCategory ||
                firstBody.categoryBitMask == collisionBitMask.buildingCategory && secondBody.categoryBitMask == collisionBitMask.playerOneCategory ||

                firstBody.categoryBitMask == collisionBitMask.playerOneCategory && secondBody.categoryBitMask == collisionBitMask.airplaneCategory ||
                firstBody.categoryBitMask == collisionBitMask.airplaneCategory && secondBody.categoryBitMask == collisionBitMask.playerOneCategory ||

                firstBody.categoryBitMask == collisionBitMask.playerOneCategory && secondBody.categoryBitMask == collisionBitMask.groundCategory ||
                firstBody.categoryBitMask == collisionBitMask.groundCategory && secondBody.categoryBitMask == collisionBitMask.playerOneCategory{
                
                playerOneCrash()
            }
        }
        
        if isPlayerTwoFinished == false && isPlayerTwoAlive == true {
            if firstBody.categoryBitMask == collisionBitMask.playerTwoCategory && secondBody.categoryBitMask == collisionBitMask.buildingCategory || firstBody.categoryBitMask == collisionBitMask.buildingCategory && secondBody.categoryBitMask == collisionBitMask.playerTwoCategory ||

                firstBody.categoryBitMask == collisionBitMask.playerTwoCategory && secondBody.categoryBitMask == collisionBitMask.groundCategory ||
                firstBody.categoryBitMask == collisionBitMask.groundCategory && secondBody.categoryBitMask == collisionBitMask.playerTwoCategory{
                
                playerTwoCrash()
            }
        }
    }

    func playerOneCrash(){
//      1 BACKGROUND BERHENTI
        self.ground.isPaused = true
        self.background.isPaused = true
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {_ in
            self.ground.isPaused = false
            self.background.isPaused = false
        })

//      2 KARAKTER KEDIP2
        if isPlayerOneAlive == true {
            // WHEN CRASH
           self.playerOne.removeAllActions()
           self.playerOne.removeFromParent()
           self.runCreatePlayerOne()
           self.playerOne.run(whenDieAnimate)
           
           isPlayerOneAlive = false
                   
           Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {_ in
               
               self.isPlayerOneAlive = true
           })
        }

//      3 ENEMY MAJU
        goForwardPlayerTwo()
    }

    func playerTwoCrash(){
        // WHEN CRASH
        isPlayerTwoAlive = false
        xLastLocationPlayerTwo = playerTwo.position.x
        self.playerTwo.removeAllActions()
        self.playerTwo.removeFromParent()
        self.runCreatePlayerTwo()
        self.playerTwo.run(whenDieAnimate)
        
        
//        print(background.position.x)
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {_ in
            
            self.isPlayerTwoAlive = true
            print(self.background.position.x)
        })

        // ENEMY MUNDUR
        goBackPlayerTwo()
    }
    
    func goBackPlayerTwo(){
        let mundurPlayerTwo = SKAction.moveBy(x: -116, y: 0, duration: 1)
        playerTwo.run(mundurPlayerTwo)
    }
    
    func goForwardPlayerTwo(){
        let majuPlayerTwo = SKAction.moveBy(x: 116, y: 0, duration: 1)
        playerTwo.run(majuPlayerTwo)
    }
    
    func endingTheGame(){
        if isLastBuildingHasBeenSpawn == false {
            isLastBuildingHasBeenSpawn = true
            addChild(physicLastBuilding())
            flapEndingGame()
            isPlayerOneFinished = true
            isPlayerTwoFinished = true
            background.removeAllActions()
            ground.removeAllActions()
            print("posisi player one \(playerOne.position.x)")
            flapEndingGameGirl()
            
            let majuPlayerOne = SKAction.moveBy(x: 116, y: 0, duration: 1)
            playerOne.run(majuPlayerOne)
        }
    }

    override func update(_ currentTime: TimeInterval) {
//        print(background.position.x)
        counterPrint = counterPrint + 1
        print(counterPrint)
//        print("posisi player 2 = \(playerTwo.position.x)")
        print("posisi background = \(background.position.x)")
        
//        print("jika dijumlah adalah = \(background.position.x + -playerTwo.position.x) \n\n")
        if background.position.x < -1270{
            endingTheGame()
            timerGirlComputerFlap?.invalidate()
        }
        
        
        if gameStarted == true{
            if isPlayerOneAlive == true && isPlayerTwoAlive == true{
                self.playerOne.physicsBody?.affectedByGravity = true
                self.playerTwo.physicsBody?.affectedByGravity = true
                
                self.playerOne.physicsBody?.collisionBitMask = collisionBitMask.groundCategory
                self.playerTwo.physicsBody?.collisionBitMask = collisionBitMask.groundCategory
                self.ground.physicsBody?.collisionBitMask    = collisionBitMask.playerOneCategory | collisionBitMask.playerTwoCategory
                
            } else if isPlayerOneAlive == true && isPlayerTwoAlive == false {
                self.playerOne.physicsBody?.affectedByGravity = true
                self.playerTwo.physicsBody?.affectedByGravity = false
                
                self.playerOne.physicsBody?.collisionBitMask = collisionBitMask.groundCategory | collisionBitMask.airplaneCategory
                self.playerTwo.physicsBody?.collisionBitMask = 0
                self.ground.physicsBody?.collisionBitMask    = collisionBitMask.playerOneCategory
                
            } else if isPlayerOneAlive == false && isPlayerTwoAlive == true {
                self.playerOne.physicsBody?.affectedByGravity = false
                self.playerTwo.physicsBody?.affectedByGravity = true
                
                self.playerOne.physicsBody?.collisionBitMask = 0
                self.playerTwo.physicsBody?.collisionBitMask = collisionBitMask.groundCategory | collisionBitMask.airplaneCategory
                self.ground.physicsBody?.collisionBitMask    = collisionBitMask.playerTwoCategory
                
            } else if isPlayerOneAlive == false && isPlayerTwoAlive == false {
                self.playerOne.physicsBody?.affectedByGravity = false
                self.playerTwo.physicsBody?.affectedByGravity = false
                
                self.playerOne.physicsBody?.collisionBitMask = 0
                self.playerTwo.physicsBody?.collisionBitMask = 0
                self.ground.physicsBody?.collisionBitMask    = 0
            }
        }
        
    }
}

//    func createCloud() {
////        1 AMBIL GAMBAR
//        let cloudSprite = SKSpriteNode(imageNamed: "cloud\(Int.random(in: 1...5))")
////        2 AWAL MUNCUL DIMANA
//        cloudSprite.position = CGPoint(x: frame.origin.x - frame.width / 2, y: CGFloat.random(in: frame.origin.y + frame.height / 2 ... frame.origin.y + frame.height))
////        3 JARAK DEKAT-JAUH ASSETS
//        let jarak = Double.random(in: 0.1...2.0)
////        4 ZPOSISI YG MENUTUPI LAINNYA
//        cloudSprite.zPosition = CGFloat((jarak * 10) - 20)
////        5 PERGERAKAN KECEPATAN DISESUAIKAN DENGAN JARAK
//        let moveToRight = SKAction.moveTo(x: frame.maxX * 2, duration: 30 / jarak)
////        6 SKALA UKURAN ASSET DISESUAIKAN DENGAN JARAK
//        cloudSprite.scale(to: CGSize(width: Double(cloudSprite.size.width) * jarak,
//                                    height: Double(cloudSprite.size.height) * jarak))
////        7 MUNCULKAN
//        addChild(cloudSprite)
////        8 JIKA SELESAI MAKA REMOVE
//        cloudSprite.run(moveToRight, completion: cloudSprite.removeFromParent)
//    }
