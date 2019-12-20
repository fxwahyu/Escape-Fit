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
    static let skyBlueBackground:CGFloat = -21
    static let skyOrangeBackground:CGFloat = -20
    static let cloudBackground:CGFloat = -19
    static let backBuilding3:CGFloat = -11
    static let backBuilding2:CGFloat = -10
    static let frontBuilding:CGFloat = 1
    static let carToLeft:CGFloat = 3
    static let carToRight:CGFloat = 2
    static let bigMeteor:CGFloat = 2
    static let semakSemak:CGFloat = 4
    static let boy:CGFloat = 5
    static let girl:CGFloat = 5
    static let circle:CGFloat = 6
    static let subtitle:CGFloat = 5
}
   
class Prologue: SKScene {

    var music1:MusicPlayer = MusicPlayer()
    var music2:MusicPlayer = MusicPlayer()
    var music3:MusicPlayer = MusicPlayer()
    //Subtitle var
    var counterTimer = Timer()
    var counterStartValue: Double = 19


    var appDelegate: AppDelegate = AppDelegate()
//    var player: String?

    lazy var subtitle: SKLabelNode = {
        var node = SKLabelNode()
        node.position = CGPoint(x: frame.midX, y: frame.midY + 175)
        node.fontColor = .black
        node.alpha = 0
        node.fontName = "ImperfectaRough"
        node.zPosition = layerStory.subtitle
        node.fontSize = 25
        node.numberOfLines = 1
        return node
    }()

    lazy var skipButton: SKSpriteNode = {
        var node = SKSpriteNode(imageNamed: "skipbutton")
        node.size = CGSize(width: 44, height: 46)
        node.position = CGPoint(x: frame.maxX - 50, y: frame.maxY - 70)
        node.zPosition = 10
    return node
    }()

    lazy var skyOrangeBackground: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "skyOrange")
        node.zPosition = layerStory.skyOrangeBackground
        node.size = CGSize(width: 1667, height: 900)
        node.anchorPoint = CGPoint(x: 0, y: 0.5)
        node.position = CGPoint(x: frame.origin.x , y: frame.origin.x + frame.height / 128 * 65)
        node.setScale(1.5 * 0.67)
        node.alpha = 0
        return node
    }()

    lazy var skyBlueBackground: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "skyBlue")
        node.zPosition = layerStory.skyBlueBackground
        node.size = CGSize(width: 1667, height: 900)
        node.anchorPoint = CGPoint(x: 0, y: 0.5)
        node.position = CGPoint(x: frame.origin.x , y: frame.origin.x + frame.height / 128 * 65)
        node.setScale(1.5 * 0.67)
        return node
    }()

    lazy var cloudBackground: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "cloudStory")
        node.zPosition = layerStory.cloudBackground
        node.size = CGSize(width: 1667, height: 900)
        node.anchorPoint = CGPoint(x: 0, y: 0.5)
        node.position = CGPoint(x: frame.origin.x , y: frame.origin.x + frame.height / 128 * 65)
        node.setScale(1.5 * 0.67)
        return node
    }()

    lazy var backBuilding3: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "back3")
        node.zPosition = layerStory.backBuilding3
        node.size = CGSize(width: 1667, height: 900)
        node.anchorPoint = CGPoint(x: 0, y: 0.5)
        node.position = CGPoint(x: frame.origin.x , y: frame.origin.x + frame.height / 128 * 65)
        node.setScale(1.5)
        return node
    }()

    lazy var backBuilding2: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "back2")
        node.zPosition = layerStory.backBuilding2
        node.size = CGSize(width: 1667, height: 900)
        node.anchorPoint = CGPoint(x: 0, y: 0.5)
        node.position = CGPoint(x: frame.origin.x , y: frame.origin.x + frame.height / 128 * 65)
        node.setScale(1.5 * 0.67)
        return node
    }()

    lazy var frontBuilding: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "frontBuildingStory")
        node.zPosition = layerStory.frontBuilding
        node.size = CGSize(width: 1667, height: 900)
        node.anchorPoint = CGPoint(x: 0, y: 0.5)
        node.position = CGPoint(x: frame.origin.x , y: frame.origin.x + frame.height / 128 * 65)
        node.setScale(1.5 * 0.67)
        return node
    }()

    lazy var carToLeft: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "carToLeftStory")
        node.zPosition = layerStory.carToLeft
        node.size = CGSize(width: 1667, height: 900)
        node.anchorPoint = CGPoint(x: 0, y: 0.5)
        node.position = CGPoint(x: frame.origin.x , y: frame.origin.x + frame.height / 128 * 65)
        node.setScale(1.5 * 0.67)
        return node
    }()

    lazy var carToRight: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "carToRightStory")
        node.zPosition = layerStory.carToRight
        node.size = CGSize(width: 1667, height: 900)
        node.anchorPoint = CGPoint(x: 1, y: 0.5)
        node.position = CGPoint(x: frame.origin.x + frame.width, y: frame.origin.x + frame.height / 128 * 65)
        node.setScale(1.5 * 0.67)
        return node
    }()

    lazy var semakSemak: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "semakSemak")
        node.zPosition = layerStory.semakSemak
        node.size = CGSize(width: 1667, height: 900)
        node.anchorPoint = CGPoint(x: 0, y: 0.5)
        node.position = CGPoint(x: frame.origin.x , y: frame.origin.x + frame.height / 128 * 65)
        node.setScale(1.5 * 0.67)
        return node
    }()

    lazy var bigMeteor: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "meteor")
        node.zPosition = layerStory.bigMeteor
        node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        node.position = CGPoint(x: frame.origin.x + (frame.width / 4 * 3) - frame.height / 4 * 3   , y: frame.origin.y + (frame.height / 4) + frame.height / 4 * 3)
        node.setScale(4 * 0.67)
        node.anchorPoint = CGPoint(x: 0.8, y: 0.3)
        return node
    }()

    lazy var circle: SKShapeNode = {
        var Circle = SKShapeNode(circleOfRadius: 1 ) // Size of Circle
        Circle.position = CGPoint(x: frame.origin.x + (frame.width / 4 * 3), y: frame.origin.y + (frame.height / 4))
        Circle.strokeColor = .black
        Circle.glowWidth = 1.0
        Circle.fillColor = .black
        Circle.zPosition = layerStory.circle
        Circle.alpha = 0
        return Circle
    }()

    lazy var boy: SKSpriteNode = { // DI KANAN
        let node = SKSpriteNode(imageNamed: "boyShock2")
        node.zPosition = layerStory.boy
        node.position = CGPoint(x: frame.origin.x + frame.width + (frame.width / 4), y: frame.origin.y)
        node.setScale(0.4 * 0.67)
        return node
    }()

    lazy var girl: SKSpriteNode = { //DI KIRI
        let node = SKSpriteNode(imageNamed: "girlShock2")
        node.zPosition = layerStory.girl
        node.position = CGPoint(x: frame.origin.x - frame.width / 4 , y: frame.origin.y)
        node.setScale(0.4 * 0.67)
        return node
    }()
    
    var timer1:Timer = Timer()
    var timer2:Timer = Timer()
    var timer3:Timer = Timer()
    var timer4:Timer = Timer()
    var timer5:Timer = Timer()
    var timer6:Timer = Timer()
    var timer7:Timer = Timer()
    var timer8:Timer = Timer()
    var timer9:Timer = Timer()
    

    override func didMove(to view: SKView) {
//        NotificationCenter.default.addObserver(self, selector: #selector(skipStory), name: NSNotification.Name(rawValue: "skipStory"), object: nil)
        appDelegate.musicPlayer.prolog()
    
        addChild(subtitle)
        startCounter()
        addChild(skyBlueBackground)
        addChild(skyOrangeBackground)
        addChild(cloudBackground)
        addChild(backBuilding3)
        addChild(backBuilding2)
        addChild(frontBuilding)
        addChild(carToLeft)
        addChild(carToRight)
        addChild(semakSemak)
        addChild(skipButton)
        slideBackground(mySprite: cloudBackground, jarak: 0.2)
        slideBackground(mySprite: backBuilding3, jarak: 0.3)
        slideBackground(mySprite: backBuilding2, jarak: 0.5)
        slideBackground(mySprite: frontBuilding, jarak: 0.8)
        slideBackground(mySprite: semakSemak, jarak: 1.0)
        slideBackground(mySprite: carToLeft, jarak: 3.0)
        slideRight(mySprite: carToRight, jarak: 2.0)

//        0, 15, 21, 23     => total 25 detik
//        2,  3,  5,  8, 10 => total 11 detik
//        3,  5,  8, 13, 15 => total 16 detik
//        6,  8, 11, 16, 18 => total 18 detik
        
        

        timer1 = Timer.scheduledTimer(withTimeInterval: 6, repeats: false, block: {_ in
            self.runTimerMeteor()
        })

        timer2 = Timer.scheduledTimer(withTimeInterval: 8, repeats: false, block: {_ in
            self.changeSky(biru: self.skyBlueBackground, orange: self.skyOrangeBackground)
    
            self.timer3 = Timer.scheduledTimer(withTimeInterval: 0, repeats: false, block: {_ in
                    let music4:MusicPlayer = MusicPlayer()
                    music4.NearMeteor()
                })
                
        })

        timer4 = Timer.scheduledTimer(withTimeInterval: 11, repeats: false, block: {_ in
            self.addChild(self.boy)
            self.addChild(self.girl)
            self.kaget()
        })

        timer5 = Timer.scheduledTimer(withTimeInterval: 16, repeats: false, block: {_ in
            self.addChild(self.bigMeteor)
            self.animateMeteor()
            self.timer6 = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {_ in
                self.music1.NearMeteor()
            })
            self.timer7 = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {_ in
                self.music2.explosionSound()
            })
        })

        timer8 = Timer.scheduledTimer(withTimeInterval: 18, repeats: false, block: {_ in
            self.addChild(self.circle)
            self.dimScreen()
        })

        timer9 = Timer.scheduledTimer(withTimeInterval: 21, repeats: false, block: {_ in
            self.pindahHalaman()
        })
    }
    
    func stopTimer(){
        timer1.invalidate()
        timer2.invalidate()
        timer3.invalidate()
        timer4.invalidate()
        timer5.invalidate()
        timer6.invalidate()
        timer7.invalidate()
        timer8.invalidate()
        timer9.invalidate()
    }



    func startCounter(){
        counterTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(decrementCounter), userInfo: nil, repeats: true)
    }

    @objc func decrementCounter(){
//        print(counterStartValue)
        if counterStartValue <= 18.8 {
            subtitle.text = "There's a time we live in peace"
            subtitle.run(SKAction.fadeAlpha(to: 1, duration: 0.3))
        }

        if counterStartValue <= 16 {
            subtitle.run(SKAction.fadeAlpha(to: 0, duration: 0.3))
            subtitle.alpha = 0
        }

        if counterStartValue <= 14 {
            subtitle.text = "We may know the beginning"
            subtitle.run(SKAction.fadeAlpha(to: 1, duration: 0.3))
        }

        if counterStartValue <= 12 {
             subtitle.run(SKAction.fadeAlpha(to: 0, duration: 0.3))
             subtitle.alpha = 0
        }

        if counterStartValue <= 11 {
            subtitle.text = "But we never know the ending"
            subtitle.run(SKAction.fadeAlpha(by: 1, duration: 0.3))
        }

        if counterStartValue <= 9 {
             subtitle.run(SKAction.fadeAlpha(to: 0, duration: 0.3))
             subtitle.alpha = 0
        }

        if counterStartValue <= 8 {
            subtitle.text = "When the time has come"
            subtitle.run(SKAction.fadeAlpha(by: 1, duration: 0.3))
        }

        if counterStartValue <= 6 {
             subtitle.run(SKAction.fadeAlpha(to: 0, duration: 0.3))
             subtitle.alpha = 0
        }

        if counterStartValue <= 5 {
            subtitle.text = "One thing for sure"
            subtitle.run(SKAction.fadeAlpha(by: 1, duration: 0.3))
        }

        if counterStartValue <= 3.5 {
             subtitle.run(SKAction.fadeAlpha(to: 0, duration: 0.3))
        }

        if counterStartValue <= 2.5 {
            subtitle.text = "ESCAPE!!"
            subtitle.fontSize = 70
            subtitle.run(SKAction.fadeAlpha(by: 1, duration: 0.3))
        }

        if counterStartValue <= 0 {
            counterTimer.invalidate()
        }
        counterStartValue -= 0.01
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            print("node is : \(node)")
            if node == skipButton {
                MusicPlayer.shared.clickSoundEffect()
                if let view = view {
                    stopTimer()
                    let transition:SKTransition = SKTransition.fade(withDuration: 1)
                    let scene = MenuScene(size: self.size)
//                    scene.player = self.player
                    self.appDelegate.musicPlayer.stopMusic()
                    scene.appDelegate.musicPlayer = self.appDelegate.musicPlayer
//                    scene.appDelegate.MPC = self.appDelegate.MPC
                    self.view?.presentScene(scene, transition: transition)
//                    sendToPeer(send: "skipStory")
                }
            }
        }
    }

    func sendToPeer(send: String){
        if appDelegate.MPC.session.connectedPeers.count > 0{
            var message: Data = Data(send.utf8)
            appDelegate.MPC.sendData(data: message)
        } else{
            print("no connected peers")
        }
    }

    @objc func skipStory(){
        if let view = view {
            stopTimer()
            let transition:SKTransition = SKTransition.fade(withDuration: 1)
            let scene = GameLadderTittle(size: self.size)
            appDelegate.musicPlayer.stopMusic()
//            scene.player = self.player
            scene.appDelegate.musicPlayer = self.appDelegate.musicPlayer
            scene.appDelegate.MPC = self.appDelegate.MPC
            self.view?.presentScene(scene, transition: transition)
        }
    }

    func pindahHalaman(){
        if let view = view {
            stopTimer()
            let transition:SKTransition = SKTransition.fade(withDuration: 1)
            let scene = MenuScene(size: self.size)
            appDelegate.musicPlayer.stopMusic()
//            scene.appDelegate.MPC = self.appDelegate.MPC
            scene.appDelegate.musicPlayer = self.appDelegate.musicPlayer
//            scene.player = self.player
            self.view?.presentScene(scene, transition: transition)
        }
    }

    func changeSky( biru:SKSpriteNode, orange:SKSpriteNode ){
        let menghilang = SKAction.fadeAlpha(to: 0.3, duration: 4)
        let muncul = SKAction.fadeAlpha(to: 1.0, duration: 2)
        biru.run(menghilang)
//        orange.color = UIColor.black.withAlphaComponent(1.0)
//        orange.run(SKAction.colorize(with: .red, colorBlendFactor: 0.1, duration: 1))
        orange.run(muncul)
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
        let fallMovement = SKAction.moveBy(x: -1125 / 8 * 0.3 , y: -2001 / 8 * 7, duration: 20 / jarak)
        fallMovement.timingMode = SKActionTimingMode.easeOut
        meteorSprite.scale(to: CGSize(width: Double(meteorSprite.size.width) * jarak, height: Double(meteorSprite.size.height) * jarak))
        meteorSprite.run(fallMovement, completion: meteorSprite.removeFromParent)
        addChild(meteorSprite)
    }

    func kaget(){
        let girlIn = SKAction.move(to: CGPoint(x: frame.origin.x + frame.width / 4,
                                               y: frame.origin.y + frame.height / 8 * 0.75), duration: 0.5)
        girlIn.timingMode = SKActionTimingMode.easeIn
        let boyIn = SKAction.move(to: CGPoint(x: frame.origin.x + frame.width / 4 * 3,
                                              y: frame.origin.y + frame.height / 8 * 0.75), duration: 0.5)
        boyIn.timingMode = SKActionTimingMode.easeIn
        let wait = SKAction.wait(forDuration: 2)
        let girlOut = SKAction.move(to: CGPoint(x: frame.origin.x - frame.width / 4 ,
                                                y: frame.origin.y - frame.height / 8 * 0.7), duration: 0.5)
        girlOut.timingMode = SKActionTimingMode.easeOut
        let boyOut = SKAction.move(to: CGPoint(x: frame.origin.x + frame.width + (frame.width / 4),
                                               y: frame.origin.y - frame.height / 8), duration: 0.5)
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
