//
//  GameScene2.swift
//  Sprite
//
//  Created by Felix Kylie on 09/10/19.
//  Copyright © 2019 Felix Kylie. All rights reserved.
//

import SpriteKit
import GameplayKit
import WatchConnectivity
import HealthKit

class GamePump : SKScene {

    // MARK: - Iniziliasation
    var boyPumpingAnimation = [SKTexture]()
    var girlPumpingAnimation = [SKTexture]()
    var boyRopeAnimation = [SKTexture]()
    var girlRopeAnimation = [SKTexture]()
    var boyJumpAnimation = [SKTexture]()
    var girlJumpAnimation = [SKTexture]()
    var boyWinAnimation = [SKTexture]()
    var girlWinAnimation = [SKTexture]()
    var howToPlayAnimation = [SKTexture]()
    var bodyAnimated = SKAction()
    var pumpingAnimation = [SKTexture]()
    
    var player1PumpCount = 0
    var player2PumpCount = 0
    var player1Ready: Bool = false
    var player2Ready: Bool = false
    var counterTimer = Timer()
    var counterStartValue: Int = 13
    var isGameOver = false
    var appDelegate: AppDelegate! = AppDelegate()
    var player: String?
    var pump: Bool = true
    var wcSession = WCSession.default
    var play: Bool = false
    var numberoftaps: Int = 0
    var stopTouch: Bool = false
    
    // MARK: - NODE
    lazy var scorePlayerOne: SKLabelNode = {
        let node = SKLabelNode()
        node.fontSize = 50
        node.fontName = "ImperfectaRough"
        node.position = CGPoint(x: frame.midX - 50, y: frame.midY - 175)
        node.zPosition = 10
        return node
    }()

    lazy var scorePlayerTwo: SKLabelNode = {
        let node = SKLabelNode()
        node.fontSize = 50
        node.fontName = "ImperfectaRough"
        node.position = CGPoint(x: frame.midX + 60, y: frame.midY - 175)
        node.zPosition = 10
        return node
    }()
    
    lazy var pumping: SKSpriteNode = {
        var node = SKSpriteNode(imageNamed: "oranghtp_pump1")
        node.position = CGPoint(x: frame.midX, y: frame.midY)
        node.zPosition = 11
        node.setScale(1)
        for i in 1...2 {
            let name = "oranghtp_pump\(i)"
            pumpingAnimation.append(SKTexture(imageNamed: name))
        }
        return node
    }()
    
//    lazy var pumpAnimation: SKSpriteNode = {
//        var node = SKSpriteNode(imageNamed: "pump_ptb1")
//        node.position = CGPoint(x: frame.midX, y: frame.origin.y + frame.height / 64 * 31 + frame.midY / 4)
//        node.zPosition = 11
//        node.setScale(1)
//        node.size = CGSize(width: 324, height: 233)
//        for i in 1...3 {
//            let name = "pump_ptb\(i)"
//            howToPlayAnimation.append(SKTexture(imageNamed: name))
//        }
//        return node
//    }()
    
    lazy var dimPanelHowToPlay: SKSpriteNode = {
        var node = SKSpriteNode(color: UIColor.black, size: self.size)
        node.alpha = 0.75
        node.zPosition = 9
        node.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        return node
    }()
    
    lazy var backgroundHowToPlay: SKSpriteNode = {
        var node = SKSpriteNode(imageNamed: "backgroundhtp_watchpump")
        node.setScale(1)
        node.position = CGPoint(x: frame.midX, y: frame.midY)
        node.zPosition = 10
        return node
    }()
 
    lazy var backgroundNode: SKSpriteNode = {
        var node = SKSpriteNode()
        node.texture = SKTexture(imageNamed: "backgroundBalloon")
        node.size = CGSize(width: frame.width, height: 8000)
        node.position = CGPoint(x: frame.midX, y: frame.midY + 3500)
        node.zPosition = -15
        return node
    }()
    
    lazy var dimPanel: SKSpriteNode = {
        var node = SKSpriteNode(color: UIColor.black, size: self.size)
        node.alpha = 0
        node.zPosition = 4
        node.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        return node
    }()
    
    lazy var boyNode: SKSpriteNode = {
        var node = SKSpriteNode()
        node.texture = SKTexture(imageNamed: "pumpboy_1")
        node.position = CGPoint(x: frame.midX - frame.midX/2, y: frame.midY - 290)
        node.size = CGSize(width: 110, height: 200)
        node.zPosition = 1
        for i in 1...3 {
            let name = "pumpboy_\(i)"
            boyPumpingAnimation.append(SKTexture(imageNamed: name))
        }
        for i in 1...9 {
            let name = "balonboy-\(i)"
            boyJumpAnimation.append(SKTexture(imageNamed: name))
        }
        for i in 1...2 {
            let name = "winboy_\(i)"
            boyWinAnimation.append(SKTexture(imageNamed: name))
        }
        return node
    }()
    
    lazy var signPlayerOne: SKSpriteNode = {
        let node = SKSpriteNode()
        node.texture = SKTexture(imageNamed: "you red")
        node.position = CGPoint(x: frame.midX - frame.midX/2, y: frame.midY - 170)
        node.size = CGSize(width: 209, height: 117)
        node.setScale(0.3)
        node.zPosition = 1
        return node
    }()
    
    lazy var girlNode: SKSpriteNode = {
        var node = SKSpriteNode()
        node.texture = SKTexture(imageNamed: "pumpgirl_1")
        node.position = CGPoint(x: frame.midX + frame.midX/2, y: frame.midY - 290)
        node.size = CGSize(width: 110, height: 200)
        node.zPosition = 1
        for i in 1...3 {
            let name = "pumpgirl_\(i)"
            girlPumpingAnimation.append(SKTexture(imageNamed: name))
        }
        for i in 1...9 {
            let name = "balongirl-\(i)"
            girlJumpAnimation.append(SKTexture(imageNamed: name))
        }
        for i in 1...2 {
            let name = "wingirl_\(i)"
            girlWinAnimation.append(SKTexture(imageNamed: name))
        }
        return node
    }()
    
    lazy var signPlayerTwo: SKSpriteNode = {
        let node = SKSpriteNode()
        node.texture = SKTexture(imageNamed: "you blue")
        node.position = CGPoint(x: frame.midX + frame.midX/2, y: frame.midY - 170)
        node.size = CGSize(width: 209, height: 117)
        node.setScale(0.3)
        node.zPosition = 1
        return node
    }()
    
    lazy var boyRopeNode: SKSpriteNode = {
        var node = SKSpriteNode()
        node.texture = SKTexture(imageNamed: "boyrope_1")
        node.size = CGSize(width: 60, height: 330)
        node.position = CGPoint(x: frame.midX - 50, y: frame.midY - 250)
        node.zPosition = 2
        for i in 1...6 {
            let name = "boyrope_\(i).png"
            boyRopeAnimation.append(SKTexture(imageNamed: name))
        }
        return node
    }()
    
    lazy var girlRopeNode: SKSpriteNode = {
        var node = SKSpriteNode()
        node.texture = SKTexture(imageNamed: "girlrope_1")
        node.size = CGSize(width: 60, height: 330)
        node.position = CGPoint(x: frame.midX + 50, y: frame.midY - 250)
        node.zPosition = 2
        for i in 1...6 {
            let name = "girlrope_\(i).png"
            girlRopeAnimation.append(SKTexture(imageNamed: name))
        }
        return node
    }()
    
    lazy var boyBalloonNode: SKSpriteNode = {
        var node = SKSpriteNode()
        node.texture = SKTexture(imageNamed: "balon-boy")
        node.size = CGSize(width: 150, height: 150)
        node.position = CGPoint(x: frame.midX - 33, y: frame.midY - 205 - CGFloat(self.player1PumpCount))
        node.anchorPoint = CGPoint(x: 0.5, y: 0)
        node.zPosition = 3
        return node
    }()
    
    lazy var girlBalloonNode: SKSpriteNode = {
        var node = SKSpriteNode()
        node.texture = SKTexture(imageNamed: "balon-girl")
        node.size = CGSize(width: 150, height: 150)
        node.position = CGPoint(x: frame.midX + 32, y: frame.midY - 205 - CGFloat(self.player2PumpCount))
        node.anchorPoint = CGPoint(x: 0.5, y: 0)
        node.zPosition = 4
        return node
    }()
    
    lazy var timerLabel: SKLabelNode = {
        var node = SKLabelNode()
        node.fontName = "ImperfectaRough"
        node.fontColor = UIColor.black
        node.fontSize = 30
        node.position = CGPoint(x: frame.midX, y: frame.midY + 300)
        node.zPosition = 1
        return node
    }()
    
    lazy var readyLabel: SKLabelNode = {
        var node = SKLabelNode()
        node.text = "Ready"
        node.fontName = "ImperfectaRough"
        node.fontColor = UIColor.black
        node.fontSize = 50
        node.position = CGPoint(x: frame.midX, y: frame.midY + 300)
        node.zPosition = 2
        return node
    }()
    
    // MARK: - DID MOVE
    override func didMove(to view: SKView) {
        //kirim ke watch start accelerometer
        appDelegate.musicPlayer.stopMusic()
        appDelegate.musicPlayer.startGameBackgroundMusic()
        
        startGame()
        notificationHandler()
        
        addChild(dimPanelHowToPlay)
        addChild(backgroundNode)
        addChild(boyNode)
        addChild(boyRopeNode)
        addChild(girlNode)
        addChild(girlRopeNode)
        addChild(boyBalloonNode)
        addChild(girlBalloonNode)
        addChild(timerLabel)
        addChild(backgroundHowToPlay)
//        addChild(pumpAnimation)
        addChild(pumping)
        addChild(readyLabel)
        
//        hideHowToPlay()
        
        if player == "player1"{
            addChild(signPlayerOne)
        } else if player == "player2"{
            addChild(signPlayerTwo)
        }
        pumping.run(SKAction.repeatForever(SKAction.animate(with: pumpingAnimation, timePerFrame: 0.5)))
        
        //buat coba
//        DispatchQueue.main.async {
//                       self.counterTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.decrementCounter), userInfo: nil, repeats: true)
//                   }
    }
    
    // MARK: - WATCH AND PEER CONNECTIVITY
    
    func notificationHandler(){
        NotificationCenter.default.addObserver(self, selector: #selector(motionData), name: NSNotification.Name(rawValue: "motiondataPump"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enemyPump), name: NSNotification.Name(rawValue: "enemyPump"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(readyToPlay), name: NSNotification.Name(rawValue: "readyToPlayPump"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerReady), name: NSNotification.Name(rawValue: "playerReady"), object: nil)
    }
    
    func startGame(){
        if self.wcSession.isReachable == true{
            self.wcSession.sendMessage(["gameplay":"start", "game":"pump", "displayedText":"Press ready to start the game"], replyHandler: nil, errorHandler: { (error) -> Void in
                print("failed with error \(error)")
            })
//            self.wcSession.sendMessage(["displayedText":"Press ready to start the game"], replyHandler: nil, errorHandler: { (error) -> Void in
//                print("failed with error \(error)")
//            })
        } else{
            print("not reachable")
        }
    }
    
    @objc func readyToPlay(notification: Notification){ //receive ready from watch
        if player == "player1"{
            player1Ready = true
        } else if player == "player2"{
            player2Ready = true
        }
            
        sendToPeer(send: "playerReady")
        
        if player1Ready == true && player2Ready == true{
            hideHowToPlay()
                MusicPlayer.shared.readySoundEffect()
            
            DispatchQueue.main.async {
                self.counterTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.decrementCounter), userInfo: nil, repeats: true)
            }
        }
    }
    
    @objc func playerReady(notification: Notification){ //receive ready from peer
         if player == "player1"{
            player2Ready = true
         } else if player == "player2"{
            player1Ready = true
         }
            
        if player1Ready == true && player2Ready == true{
            hideHowToPlay()
                MusicPlayer.shared.readySoundEffect()
            
            DispatchQueue.main.async {
                self.counterTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.decrementCounter), userInfo: nil, repeats: true)
            }
        }
    }
    
    @objc func motionData(notification: NSNotification){
        let message = notification.userInfo!
        DispatchQueue.main.async {
            let time = message["time"] as! String
            
            let accx = message["accx"] as! String
            let accy = message["accy"] as! String
            let accz = message["accz"] as! String
            
            let gyrox = message["gyrox"] as! String
            let gyroy = message["gyroy"] as! String
            let gyroz = message["gyroz"] as! String
            
            let x: Double = Double(accx)!
            if x > 1.5 && self.pump == true && self.play == true{
                    MusicPlayer.shared.pumpSoundEffect()
                
                self.pump = false
                if self.player == "player1"{
                    self.animationChanged(pos: "player1pump")
                } else if self.player == "player2"{
                    self.animationChanged(pos: "player2pump")
                }
                
                self.sendToPeer(send: "enemyPump")
            }
            
            if x < 1.0 && self.pump == false && self.play == true{
                self.pump = true
            }
            
//            if self.play == false{
//                if x > 1.5{
//                    self.pumpAnimation.run(SKAction.animate(with: self.howToPlayAnimation, timePerFrame: 0.1))
//                }
//            }
        }
    }
    
    // buat coba
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first {
//            boyNode.run(SKAction.animate(with: boyPumpingAnimation, timePerFrame: 0.1))
//            boyBalloonNode.run(SKAction.scale(by: 1.03, duration: 0.2))
//            boyBalloonNode.position = CGPoint(x: boyBalloonNode.position.x, y: boyBalloonNode.position.y - 1)
//            player1PumpCount += 1
            
//            if self.play == false{
//                if player == "player1"{
//                    player1Ready = true
//                } else if player == "player2"{
//                    player2Ready = true
//                }
//
//                sendToPeer(send: "playerReady")
//
//                if stopTouch == false{
//                    if player1Ready == true && player2Ready == true{
//                        print("masuk game")
//                        hideHowToPlay()
//                        stopTouch = true
//                        DispatchQueue.main.async {
//                            self.counterTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.decrementCounter), userInfo: nil, repeats: true)
//                        }
//                    }
//                }
//            } else{
//                if self.player == "player1"{
//                    self.animationChanged(pos: "player1pump")
//                } else if self.player == "player2"{
//                    self.animationChanged(pos: "player2pump")
//                }
//                self.sendToPeer(send: "enemyPump")
//            }
//        }
//    }
    
    
    // MARK: - FUNCTIONS
    func jumpAnimation(){
        boyNode.position = CGPoint(x: frame.midX - 80, y: frame.midY - 290)
        boyNode.run(SKAction.animate(with: boyJumpAnimation, timePerFrame: 0.1))
        boyRopeNode.run(SKAction.animate(with: boyRopeAnimation, timePerFrame: 0.1))
        
        girlNode.position = CGPoint(x: frame.midX + 80, y: frame.midY - 290)
        girlNode.run(SKAction.animate(with: girlJumpAnimation, timePerFrame: 0.1))
        girlRopeNode.run(SKAction.animate(with: girlRopeAnimation, timePerFrame: 0.1))
    }
    
    func hideHowToPlay(){
        backgroundHowToPlay.isHidden = true
        dimPanelHowToPlay.isHidden = true
//        pumpAnimation.isHidden = true
        pumping.isHidden = true
//        play = true
    }
    
    func gameOver(won: Bool){
        
        //self.view?.isUserInteractionEnabled = false
        
        let moveAction = SKAction.moveTo(y: frame.midY - 3300, duration: 5)
        moveAction.timingMode = .easeOut
        backgroundNode.run(moveAction)
        
        boyNode.run(SKAction.move(to: CGPoint(x: frame.midX - 80, y: frame.midY - 180), duration: 2))
        boyRopeNode.run(SKAction.move(to: CGPoint(x: frame.midX - 50, y: frame.midY - 110), duration: 2))
        boyBalloonNode.run(SKAction.move(to: CGPoint(x: frame.midX - 30, y: frame.midY - 85 - CGFloat(player1PumpCount)), duration: 2))
        
        girlNode.run(SKAction.move(to: CGPoint(x: frame.midX + 80, y: frame.midY - 180), duration: 2))
        girlRopeNode.run(SKAction.move(to: CGPoint(x: frame.midX + 50, y: frame.midY - 110), duration: 2))
        girlBalloonNode.run(SKAction.move(to: CGPoint(x: frame.midX + 30, y: frame.midY - 85 - CGFloat(player2PumpCount)), duration: 2))
        
        boyRopeNode.position = CGPoint(x: frame.midX - 50, y: frame.midY - 270)
        timerLabel.alpha = 0
    }
    
    
    
    func animationChanged(pos: String){
        if pos == "player1pump" {
            boyNode.run(SKAction.animate(with: boyPumpingAnimation, timePerFrame: 0.1))
            boyBalloonNode.run(SKAction.scale(by: 1.03, duration: 0.2))
            boyBalloonNode.position = CGPoint(x: boyBalloonNode.position.x, y: boyBalloonNode.position.y - 1)
            player1PumpCount += 1
            print("number of pump : \(player1PumpCount)")
        } else if pos == "player2pump"{
            girlNode.run(SKAction.animate(with: girlPumpingAnimation, timePerFrame: 0.1))
            girlBalloonNode.run(SKAction.scale(by: 1.03, duration: 0.2))
            girlBalloonNode.position = CGPoint(x: girlBalloonNode.position.x, y: girlBalloonNode.position.y - 1)
            player2PumpCount += 1
        }
    }
    
    @objc func enemyPump(notification: Notification){
        if player == "player1"{
            animationChanged(pos: "player2pump")
        } else if player == "player2"{
            animationChanged(pos: "player1pump")
        }
    }
    
    func sendToPeer(send: String){
        if appDelegate.MPC.session.connectedPeers.count > 0{
            var message: Data = Data(send.utf8)
            print("before sending data : \(appDelegate.MPC.session.connectedPeers) with data : \(message)")
            appDelegate.MPC.sendData(data: message)
        } else{
            print("no connected peers")
        }
    }
    
    @objc func decrementCounter(){
            if !isGameOver{
                print(counterStartValue)
                if counterStartValue == 13{
                    timerLabel.isHidden = true
                }
                
                if counterStartValue == 12 {
                        MusicPlayer.shared.goSoundEffect()
                    
                    readyLabel.text = "Go"
                    print("masuk 11")
                }
                
                if counterStartValue == 11 {
                    timerLabel.isHidden = false
                    readyLabel.isHidden = true
                    if player == "player1"{
                        signPlayerOne.removeFromParent()
                    } else if player == "player2"{
                        signPlayerTwo.removeFromParent()
                    }
                    play = true
                }
                
                if counterStartValue == 0 {
                        MusicPlayer.shared.flyingSoundEffect()
                    
                    gameOver(won: true)
                }
                
                if counterStartValue == 1 {
                    self.isUserInteractionEnabled = false
                    play = false
                    //kirim ke watch stop accelerometer
                    self.wcSession.sendMessage(["gameplay":"done"], replyHandler: nil, errorHandler: { (error) -> Void in
                        print("failed with error \(error)")
                    })
                    jumpAnimation()
                    boyBalloonNode.run(SKAction.move(to: CGPoint(x: frame.midX - 30, y: frame.midY - 180 - CGFloat(player1PumpCount)), duration: 1))
                    girlBalloonNode.run(SKAction.move(to: CGPoint(x: frame.midX + 30, y: frame.midY - 180 - CGFloat(player2PumpCount)), duration: 1))
                    timerLabel.alpha = 0
                }
                
                if counterStartValue == -3 {
                    if (player1PumpCount >= player2PumpCount) {
                        girlNode.run(SKAction.move(to: CGPoint(x: frame.midX + 80, y: frame.midY - 1000), duration: 1))
                        girlRopeNode.run(SKAction.move(to: CGPoint(x: frame.midX + 50, y: frame.midY - 1000), duration: 1))
                        girlBalloonNode.run(SKAction.move(to: CGPoint(x: frame.midX + 30, y: frame.midY - 1000), duration: 1))
                        boyNode.run(SKAction.move(to: CGPoint(x: frame.midX, y: frame.midY - 180), duration: 2))
                        boyRopeNode.run(SKAction.move(to: CGPoint(x: frame.midX + 30, y: frame.midY - 110), duration: 2))
                        boyBalloonNode.run(SKAction.move(to: CGPoint(x: frame.midX + 50, y: frame.midY - 85), duration: 2))
                    } else if (player2PumpCount > player1PumpCount) {
                        boyNode.run(SKAction.move(to: CGPoint(x: frame.midX - 80, y: frame.midY - 1000), duration: 1))
                        boyRopeNode.run(SKAction.move(to: CGPoint(x: frame.midX - 50, y: frame.midY - 1000), duration: 1))
                        boyBalloonNode.run(SKAction.move(to: CGPoint(x: frame.midX - 30, y: frame.midY - 1000), duration: 1))
                        girlNode.run(SKAction.move(to: CGPoint(x: frame.midX, y: frame.midY - 180), duration: 2))
                        girlRopeNode.run(SKAction.move(to: CGPoint(x: frame.midX - 30, y: frame.midY - 110), duration: 2))
                        girlBalloonNode.run(SKAction.move(to: CGPoint(x: frame.midX - 50, y: frame.midY - 85), duration: 2))
                    }
                }
                
                if counterStartValue == -5 {
                   let moveAction = SKAction.moveTo(y: frame.midY - 3200, duration: 1)
                   moveAction.timingMode = .easeOut
                   backgroundNode.run(moveAction)
                    
                    if (player1PumpCount >= player2PumpCount) {
                        boyRopeNode.run(SKAction.move(to: CGPoint(x: frame.midX + 30, y: frame.midY + 1000), duration: 3))
                        boyBalloonNode.run(SKAction.move(to: CGPoint(x: frame.midX + 50, y: frame.midY + 1000), duration: 3))
                    } else if (player2PumpCount > player1PumpCount) {
                        girlRopeNode.run(SKAction.move(to: CGPoint(x: frame.midX - 30, y: frame.midY + 1000), duration: 3))
                        girlBalloonNode.run(SKAction.move(to: CGPoint(x: frame.midX - 55, y: frame.midY + 1000), duration: 3))
                    }
                   
                }
                
                if counterStartValue == -6 {
                    if (player1PumpCount >= player2PumpCount) {
                        boyNode.run(SKAction.animate(with: boyWinAnimation, timePerFrame: 1))
                    } else if (player2PumpCount > player1PumpCount) {
                        girlNode.run(SKAction.animate(with: girlWinAnimation, timePerFrame: 1))
                    }
                }
                
                if counterStartValue == -7{
                    if self.player1PumpCount >= self.player2PumpCount{ //animasi player 1 win
                        appDelegate.gameScore.addScore(player: "player1")
                        appDelegate.gameScore.winnerGame1 = "player1"
                    } else { //animasi player 2 win
                        appDelegate.gameScore.addScore(player: "player2")
                        appDelegate.gameScore.winnerGame1 = "player2"
                    }
                    showScoreBoard()
                }
                
                if counterStartValue == -8 {
//                    if (player1PumpCount >= player2PumpCount) {
//                        if player == "player1"{
//                            let boyScoreBoard = SKSpriteNode(imageNamed: "player 1 win score")
//                            boyScoreBoard.size = CGSize(width: 870.32, height: 870.32)
//                            boyScoreBoard.position = CGPoint(x: frame.midX, y: frame.midY)
//                            boyScoreBoard.setScale(0.6)
//                            boyScoreBoard.zPosition = 5
//                            addChild(boyScoreBoard)
//                        } else if player == "player2"{
//                            let boyScoreBoard = SKSpriteNode(imageNamed: "player 2 lose score")
//                            boyScoreBoard.size = CGSize(width: 870.32, height: 880)
//                            boyScoreBoard.position = CGPoint(x: frame.midX, y: frame.midY)
//                            boyScoreBoard.setScale(0.4)
//                            boyScoreBoard.zPosition = 5
//                            addChild(boyScoreBoard)
//                        }
//
//                    } else if (player2PumpCount > player1PumpCount) {
//                        if player == "player1"{
//                            let boyScoreBoard = SKSpriteNode(imageNamed: "player 1 lose score")
//                            boyScoreBoard.size = CGSize(width: 870.32, height: 870.32)
//                            boyScoreBoard.position = CGPoint(x: frame.midX, y: frame.midY)
//                            boyScoreBoard.setScale(0.4)
//                            boyScoreBoard.zPosition = 5
//                            addChild(boyScoreBoard)
//                        } else if player == "player2"{
//                            let boyScoreBoard = SKSpriteNode(imageNamed: "player 2 win score")
//                            boyScoreBoard.size = CGSize(width: 870.32, height: 880)
//                            boyScoreBoard.position = CGPoint(x: frame.midX, y: frame.midY)
//                            boyScoreBoard.setScale(0.6)
//                            boyScoreBoard.zPosition = 5
//                            addChild(boyScoreBoard)
//                        }
//                    }
                    isGameOver = true
                }
    //            print(counter)
                counterStartValue -= 1
                timerLabel.text = "\(counterStartValue)"
            }
        }
    
    @objc func showScoreBoard(){
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {_ in
            self.addChild(self.dimPanel)
            self.dimPanel.run(SKAction.fadeAlpha(to: 0.9, duration: 1))
        })
        
        var win: Bool?
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {_ in
            var scoreBoard = SKSpriteNode()
            if self.player == "player1"{
                if self.player1PumpCount >= self.player2PumpCount{
                    //score board win player 1
                    scoreBoard = SKSpriteNode(imageNamed: "player 1 win score")
                    win = true
                } else {
                    scoreBoard = SKSpriteNode(imageNamed: "player 1 lose score")
                    win = false
                }
            } else if self.player == "player2"{
                if self.player1PumpCount >= self.player2PumpCount{
                    //score board lose player 2
                    scoreBoard = SKSpriteNode(imageNamed: "player 2 lose score")
                    win = false
                } else {
                    //score board win player 2
                    scoreBoard = SKSpriteNode(imageNamed: "player 2 win score")
                    win = true
                }
            }
            
            self.scorePlayerOne.text = String(self.appDelegate.gameScore.scorePlayer1)
            self.scorePlayerTwo.text = String(self.appDelegate.gameScore.scorePlayer2)
            self.addChild(self.scorePlayerOne)
            self.addChild(self.scorePlayerTwo)
            
            scoreBoard.size = CGSize(width: 870.32, height: 870.32)
            scoreBoard.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            scoreBoard.setScale(0.6)
            scoreBoard.zPosition = 6
            self.addChild(scoreBoard)
            
            self.appDelegate.musicPlayer.stopMusic()
                if win == true{
                    MusicPlayer.shared.winSoundEffect()
                } else{
                    MusicPlayer.shared.loseSoundEffect()
                }
            
            self.moveToMainMenu()
        })
        
    }
    
    func moveToMainMenu(){
        Timer.scheduledTimer(withTimeInterval: 6, repeats: false, block: {_ in
            let transition = SKTransition.fade(withDuration: 1)
            let scene = MenuScene(size: self.size)
//            scene.appDelegate.MPC = self.appDelegate.MPC
//            scene.appDelegate.musicPlayer = self.appDelegate.musicPlayer
            self.appDelegate.MPC.turnOffAdvertiser()
            self.wcSession.sendMessage(["turnOffWorkoutSession":"yes"], replyHandler: nil, errorHandler: { (error) -> Void in
                       print("failed with error \(error)")
                   })
            self.view?.presentScene(scene, transition: transition)
        })
        
    }
    
//    func moveToFlappy(){
//        Timer.scheduledTimer(withTimeInterval: 6, repeats: false, block: {_ in
//                    let transition = SKTransition.fade(withDuration: 1)
//                    let scene = GameFlappy(size: self.size)
//                    scene.appDelegate.MPC = self.appDelegate.MPC
//                    scene.appDelegate.musicPlayer = self.appDelegate.musicPlayer
//                    scene.player = self.player
//                    scene.appDelegate.gameScore = self.appDelegate.gameScore
//                    self.view?.presentScene(scene, transition: transition)
//                })
//    }
}
