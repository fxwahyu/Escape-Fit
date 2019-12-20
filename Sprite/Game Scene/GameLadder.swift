//
//  GameScene.swift
//  Sprite
//
//  Created by Felix Kylie on 24/09/19.
//  Copyright © 2019 Felix Kylie. All rights reserved.
//

import SpriteKit
import GameplayKit
import WatchConnectivity
import HealthKit

struct layerLadderGame {
    static let backgroundSky:CGFloat = -21
    static let backgroundLadder:CGFloat = -3
    static let backgroundHole:CGFloat = 5
    static let playerOne:CGFloat = -2
    static let playerTwo:CGFloat = -2
    static let progressBarOne:CGFloat = 2
    static let progressBarTwo:CGFloat = 2
    static let progressBar:CGFloat = 1
    static let htpAnimation:CGFloat = 4
    static let htpLadder:CGFloat = 4
    static let dimPanelHowToPlay:CGFloat = 2
    static let backgroundHowToPlay:CGFloat = 3
    static let longWater: CGFloat = 1
}

class GameLadder: SKScene {
    
    // MARK: - Iniziliasation
    var playerOneRightUp = SKTexture(imageNamed: "boy ladder 1")
    var playerOneLeftUp = SKTexture(imageNamed: "boy ladder 2")
    var playerTwoRightUp = SKTexture(imageNamed: "girl ladder 1")
    var playerTwoLeftUp = SKTexture(imageNamed: "girl ladder 2")
    var playerOneWin = [SKTexture]()
    var playerTwoWin = [SKTexture]()
    var howToPlayLadder = [SKTexture]()
    var howToPlayAnimation = [SKTexture]()
    var boyWinAnimation = [SKTexture]()
    var girlWinAnimation = [SKTexture]()
    
    var play = false
    var playerOneCount = 0
    var playerTwoCount = 0
    var goUp: Bool = true
    var player: String?
    var wcSession = WCSession.default
    var counter: Int = 0
    var counterTimer = Timer()
    var counterStartValue: Int = 3
    var finish: Bool = false
    var playerOneReady: Bool = false
    var playerTwoReady: Bool = false
    
    var appDelegate: AppDelegate! = AppDelegate()
    
    // MARK: - Node
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
    
    lazy var htpAnimation: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "oranghtp_ladder1")
        node.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        node.zPosition = layerLadderGame.htpAnimation
        node.setScale(1)
        for i in 1...2 {
            let name = "oranghtp_ladder\(i)"
            howToPlayAnimation.append(SKTexture(imageNamed: name))
        }
        return node
    }()
    
//    lazy var htpLadder: SKSpriteNode = {
//        let node = SKSpriteNode(imageNamed: "htpladder1")
//        node.position = CGPoint(x: frame.midX, y: frame.origin.y + frame.height / 64 * 30.2 + frame.midY / 4)
//        node.zPosition = layerLadderGame.htpLadder
//        node.setScale(1)
//        node.size = CGSize(width: 324, height: 233)
//        for i in 1...2 {
//            let name = "htpladder\(i)"
//            howToPlayLadder.append(SKTexture(imageNamed: name))
//        }
//        return node
//    }()
    
    lazy var dimPanel: SKSpriteNode = {
        var node = SKSpriteNode(color: UIColor.black, size: self.size)
        node.alpha = 0
        node.zPosition = 5
        node.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        return node
    }()
    
    lazy var dimPanelHowToPlay: SKSpriteNode = {
        let node = SKSpriteNode(color: UIColor.black, size: self.size)
        node.alpha = 0.75
        node.zPosition = layerLadderGame.dimPanelHowToPlay
        node.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        return node
    }()
    
    lazy var backgroundHowToPlay: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "backgroundhtp_watchladder")
        node.setScale(1)
        node.position = CGPoint(x: frame.midX, y: frame.midY)
        node.zPosition = layerLadderGame.backgroundHowToPlay
        return node
    }()
    
    lazy var backgroundSky: SKSpriteNode = {
            let node = SKSpriteNode()
            node.texture = SKTexture(imageNamed: "BackgroundSky")
    //        node.position = CGPoint(x: frame.midX, y: frame.midY + 895)
        node.position = CGPoint(x: frame.origin.x + frame.width / 2, y:  frame.height * 1.05)
        print("point : \(node.anchorPoint)")
            node.size = CGSize(width: 416, height: 896)
            node.setScale(1)
            node.zPosition = layerLadderGame.backgroundSky
            return node
        }()
    
    lazy var background: SKSpriteNode = {
        let node = SKSpriteNode()
//        node.texture = SKTexture(imageNamed: "background game ladder")
        node.texture = SKTexture(imageNamed: "backgroundGameLadder")
        node.position = CGPoint(x: frame.origin.x + frame.width / 2, y:  frame.height)
        node.size = CGSize(width: 830, height: 3580)
        node.setScale(0.5)
        node.zPosition = layerLadderGame.backgroundLadder
        return node
    }()
    
    lazy var backgroundHole: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "backgroundHole")
        node.position = CGPoint(x: frame.origin.x + frame.width / 2, y:  frame.height * 1.001)
        node.alpha = 1
        node.size = CGSize(width: 830, height: 3580)
        node.setScale(0.5)
        node.zPosition = layerLadderGame.backgroundHole
        return node
    }()
    
    lazy var longWater: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "longWater")
        node.position = CGPoint(x: frame.origin.x + frame.width / 2, y:  frame.height / 16 * 3)
        node.alpha = 1
        node.size = CGSize(width: 830, height: 2631)
        node.anchorPoint = CGPoint(x: 0.5, y: 1)
        node.setScale(0.5)
        node.zPosition = layerLadderGame.longWater
        return node
    }()

    
    lazy var playerOne: SKSpriteNode = {
        let node = SKSpriteNode()
        node.texture = SKTexture(imageNamed: "boy ladder 1")
        node.position = CGPoint(x: frame.origin.x + frame.width / 128 * 45.5, y: frame.height / 32 * 8.6 )
        node.size = CGSize(width: 140.61, height: 245.01)
        node.setScale(0.5)
        node.zPosition = layerLadderGame.playerOne
        for i in 1...3 {
            let name = "player1 finish \(i)"
            playerOneWin.append(SKTexture(imageNamed: name))
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
        node.position = CGPoint(x: frame.origin.x + frame.width / 128 * 45.5, y: frame.height / 32 * 8.6 + 100 )
        node.size = CGSize(width: 209, height: 117)
        node.setScale(0.4)
        node.zPosition = layerLadderGame.playerOne
        return node
    }()
    
    lazy var playerTwo: SKSpriteNode = {
        let node = SKSpriteNode()
        node.texture = SKTexture(imageNamed: "girl ladder 2")
        node.position = CGPoint(x: frame.width / 128 *  82.5, y: frame.height / 32 * 8.6 )
        node.size = CGSize(width: 130.63, height: 246.76)
        node.setScale(0.5)
        node.zPosition = layerLadderGame.playerTwo
        for i in 1...3 {
            let name = "player2 finish \(i)"
            playerTwoWin.append(SKTexture(imageNamed: name))
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
        node.position = CGPoint(x: frame.width / 128 *  82.5, y: frame.height / 32 * 8.6 + 100)
        node.size = CGSize(width: 209, height: 117)
        node.setScale(0.4)
        node.zPosition = layerLadderGame.playerOne
        return node
    }()
    
    lazy var progressBar: SKSpriteNode = {
        let node = SKSpriteNode()
        node.texture = SKTexture(imageNamed: "progressbar")
        node.position = CGPoint(x: frame.width / 64 * 9.6, y: frame.height / 5 * 3)
        node.size = CGSize(width: 74.07, height: 834.57)
        node.setScale(0.5)
        node.zPosition = layerLadderGame.progressBar
        return node
    }()
    
    lazy var player1Progress: SKSpriteNode = {
        let node = SKSpriteNode()
        node.texture = SKTexture(imageNamed: "player1bar")
        node.position = CGPoint(x: frame.width / 64 * 4.5, y: frame.height / 64 * 24)
        node.size = CGSize(width: 42.15, height: 25.14)
        node.setScale(0.5)
        node.zPosition = layerLadderGame.progressBarOne
        return node
    }()
    
    lazy var player2Progress: SKSpriteNode = {
        let node = SKSpriteNode()
        node.texture = SKTexture(imageNamed: "player2bar")
        node.position = CGPoint(x: frame.width / 64 * 10.5 , y: frame.height / 64 * 24)
        node.size = CGSize(width: 42.15, height: 25.14)
        node.setScale(0.5)
        node.zPosition = layerLadderGame.progressBarTwo
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
    
    //    batas atas = 50.5
    //    batas bawah = 24
    //    50.5 - 24 = 26,5
    //    (50.5 - 24) : 30 = 0.883333
    //    (50.5 - 24) : 31 = 0.85483871
    
    
    // MARK: - Iniziliasation
    override func didMove(to view: SKView) {
        startGame()
        notificationHandler()
        appDelegate.musicPlayer.stopMusic()
        appDelegate.musicPlayer.startGameBackgroundMusic()
        
//        if appDelegate.musicPlayer.muted == true{
//            appDelegate.musicPlayer.mute()
//        }
        
        addChild(backgroundHowToPlay)
        addChild(dimPanelHowToPlay)
//        addChild(htpLadder)
        addChild(htpAnimation)
        
//        hideHowToPlay()
        
        addChild(playerOne)
        addChild(playerTwo)
        addChild(backgroundSky)
        addChild(backgroundHole)
        
        print(backgroundHole)
        addChild(background)
//        print(background)
        addChild(progressBar)
        addChild(player1Progress)
        addChild(player2Progress)
        addChild(readyLabel)
        addChild(longWater)
        naikTurun(water: longWater)
        
        if player == "player1"{
            addChild(signPlayerOne)
        } else if player == "player2"{
            addChild(signPlayerTwo)
        }
        
        runTimerCloud()
        htpAnimation.run(SKAction.repeatForever(SKAction.animate(with: howToPlayAnimation, timePerFrame: 0.5)))
    }
    
    // MARK: - WATCH AND PEER CONNECTION
    func notificationHandler(){
        NotificationCenter.default.addObserver(self, selector: #selector(motionData), name: NSNotification.Name(rawValue: "motiondataLadder"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enemyUp), name: NSNotification.Name(rawValue: "enemyUp"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(continueToGame2), name: NSNotification.Name(rawValue: "continueToGame2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(readyToPlay), name: NSNotification.Name(rawValue: "readyToPlayLadder"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ladderFinished), name: NSNotification.Name(rawValue: "ladderFinished"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerReady), name: NSNotification.Name(rawValue: "playerReady"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showScoreBoard), name: NSNotification.Name(rawValue: "scoreBoard"), object: nil)
    }
    
    func startGame(){
        if self.wcSession.isReachable == true{
            print("sending watch activation")
            self.wcSession.sendMessage(["gameplay":"start", "game":"ladder", "displayedText":"Press ready to start the game"], replyHandler: nil, errorHandler: { (error) -> Void in
                print("failed with error \(error)")
            })
        } else{
            print("not reachable")
        }
    }
    
    @objc func readyToPlay(notification: Notification){ //from watch
        if player == "player1"{
            playerOneReady = true
        } else if player == "player2"{
            playerTwoReady = true
        }
        
        sendToPeer(send: "playerReady")
        
        if playerOneReady == true && playerTwoReady == true{
            hideHowToPlay()
            DispatchQueue.main.async {
                self.counterTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.decrementCounter), userInfo: nil, repeats: true)
            }
        }
    }
    
    @objc func playerReady(notification: Notification){
        if player == "player1"{
            playerTwoReady = true
        } else if player == "player2"{
            playerOneReady = true
        }
        
        if playerOneReady == true && playerTwoReady == true{
            hideHowToPlay()
            DispatchQueue.main.async {
                self.counterTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.decrementCounter), userInfo: nil, repeats: true)
            }
        }
    }
    
    @objc func decrementCounter(){
        print(counterStartValue)
        if counterStartValue == 2{
            MusicPlayer.shared.goSoundEffect()
            readyLabel.text = "Go"
        } else if counterStartValue == 1{
            readyLabel.removeFromParent()
            play = true
            if player == "player1"{
                signPlayerOne.removeFromParent()
            } else if player == "player2"{
                signPlayerTwo.removeFromParent()
            }
        } else if counterStartValue == 0{
            counterTimer.invalidate()
        }
        counterStartValue -= 1
    }
    
    @objc func ladderFinished(notification: Notification){
        self.wcSession.sendMessage(["gameplay":"done"], replyHandler: nil, errorHandler: { (error) -> Void in
            print("failed with error \(error)")
        })
        self.finish = true
        if self.playerOneCount > self.playerTwoCount{ //animasi player 1 win
            appDelegate.gameScore.addScore(player: "player1")
            appDelegate.gameScore.winnerGame1 = "player1"
            winAnimation(player: "player1")
        } else { //animasi player 2 win
            appDelegate.gameScore.addScore(player: "player2")
            appDelegate.gameScore.winnerGame1 = "player2"
            winAnimation(player: "player2")
        }
    }
    
    @objc func motionData(notification: NSNotification){
        let message = notification.userInfo!
        
        DispatchQueue.main.async {
            let accx = message["accx"] as! String
            
            let x: Double = Double(accx)!
            
            if self.play == true{ //siap main setelah 'GO'
                if x > 1.5 && self.goUp == true{
                    print("up")
                    if self.finish == true{
                        if self.playerOneCount > self.playerTwoCount{ //animasi player 1 win
                            
                        } else { //animasi player 2 win
                            
                        }
                    } else {
                            MusicPlayer.shared.climbSoundEffect()
                        
                        if self.player == "player1"{
                            self.animationChanged(pos: "player1Up")
                        } else if self.player == "player2"{
                            self.animationChanged(pos: "player2Up")
                        }
                        
                        self.sendToPeer(send: "enemyUp")
                        self.goUp = false
                    }
                    
                if self.playerOneCount == 32 && self.finish == false || self.playerTwoCount == 32 && self.finish == false {
                    self.finish = true
                    self.wcSession.sendMessage(["gameplay":"done"], replyHandler: nil, errorHandler: { (error) -> Void in
                        print("failed with error \(error)")
                    })
                    
                    if self.playerOneCount > self.playerTwoCount{ //animasi player 1 win
                        self.appDelegate.gameScore.addScore(player: "player1")
                        self.appDelegate.gameScore.winnerGame1 = "player1"
                        self.winAnimation(player: "player1")
                    } else { //animasi player 2 win
                        self.appDelegate.gameScore.addScore(player: "player2")
                        self.appDelegate.gameScore.winnerGame1 = "player2"
                        self.winAnimation(player: "player2")
                    }
                                
                    self.sendToPeer(send: "finish")
                    self.sendToPeer(send: "scoreBoard")
                    self.showScoreBoard()
                }
            }
                
            if x <= -1.0 && self.goUp == false{
                self.goUp = true
            }
                
            }
//            else{ //kondisi masih belum main
//                if x > 1.5{
//                    self.htpLadder.run(SKAction.animate(with: self.howToPlayLadder, timePerFrame: 0.1))
//                }
//            }
        }
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first {
//            if playerOneCount == 31{
//                self.winAnimation(player: "player1")
//            }
            
//            background.position.y = background.position.y - frame.height / 128 * 5.2
//            playerOneCount += 1
//            if playerOne.texture == playerOneLeftUp {
//                playerOne.texture = playerOneRightUp
//            } else {
//                playerOne.texture = playerOneLeftUp
//            }
//            if self.play == false{
//                if player == "player1"{
//                    playerOneReady = true
//                } else if player == "player2"{
//                    playerTwoReady = true
//                }
//
//                sendToPeer(send: "playerReady")
//
//                if playerOneReady == true && playerTwoReady == true{
//                    hideHowToPlay()
//                    print("masuk game")
//                    DispatchQueue.main.async {
//                        self.counterTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.decrementCounter), userInfo: nil, repeats: true)
//                    }
//                }
//            } else {
//                if self.finish == true{
//
//                } else {
//                    if self.player == "player1"{
//                        self.animationChanged(pos: "player1Up")
//                    } else if self.player == "player2"{
//                        self.animationChanged(pos: "player2Up")
//                    }
//
//                    self.sendToPeer(send: "enemyUp")
//                    self.goUp = false
//                }
//
//                if self.playerOneCount == 31 && self.finish == false || self.playerTwoCount == 31 && self.finish == false {
//                    self.finish = true
//                    self.wcSession.sendMessage(["watchactivation":"stop"], replyHandler: nil, errorHandler: { (error) -> Void in
//                        print("failed with error \(error)")
//                    })
//
//                    if self.playerOneCount > self.playerTwoCount{ //animasi player 1 win
//                        appDelegate.gameScore.addScore(player: "player1")
//                        appDelegate.gameScore.winnerGame1 = "player1"
//                        winAnimation(player: "player1")
//                    } else { //animasi player 2 win
//                        appDelegate.gameScore.addScore(player: "player2")
//                        appDelegate.gameScore.winnerGame1 = "player2"
//                        winAnimation(player: "player2")
//                    }
//
//                    self.sendToPeer(send: "finish")
//                    sendToPeer(send: "scoreBoard")
//                    showScoreBoard()
//                }
//            }

            // if naik ke 32 = background stop, ganti ke animasi 2 tangan gantung -> siap berdiri, beridiri, animasi selebrasi

//        }
//    }
    
    @objc func enemyUp(notification: Notification){
        if player == "player1"{
            animationChanged(pos: "player2Up")
        } else if player == "player2"{
            animationChanged(pos: "player1Up")
        }
    }
    
    @objc func continueToGame2(notification: Notification){
        Timer.scheduledTimer(withTimeInterval: 6, repeats: false, block: {_ in
            let transition = SKTransition.fade(withDuration: 1)
            let scene = GamePumpTittle(size: self.size)
            scene.player = self.player
            scene.appDelegate.MPC = self.appDelegate.MPC
            scene.appDelegate.musicPlayer = self.appDelegate.musicPlayer
            scene.appDelegate.gameScore = self.appDelegate.gameScore
            self.view?.presentScene(scene, transition: transition)
        })
    }
    
    func sendToPeer(send: String){
        if appDelegate.MPC.session.connectedPeers.count > 0{
            var message: Data = Data(send.utf8)
            appDelegate.MPC.sendData(data: message)
        } else{
            print("no connected peers")
        }
    }
    
    
    // MARK: - FUNCTIONS
    
    func naikTurun(water:SKSpriteNode){
        let moveUp = SKAction.moveBy(x: 0, y: 12, duration: 0.8)
        moveUp.timingMode = SKActionTimingMode.easeInEaseOut
        let moveDown = SKAction.moveBy(x: 0, y: -12, duration: 0.8)
        moveDown.timingMode = SKActionTimingMode.easeInEaseOut
        water.run(SKAction.repeatForever(SKAction.sequence([moveUp,moveDown])))
    }

    func moveViewController(){
        Timer.scheduledTimer(withTimeInterval: 6, repeats: false, block: {_ in
            let transition = SKTransition.fade(withDuration: 1)
            let scene = GamePumpTittle(size: self.size)
            scene.appDelegate.MPC = self.appDelegate.MPC
            scene.appDelegate.musicPlayer = self.appDelegate.musicPlayer
            scene.player = self.player
            scene.appDelegate.gameScore = self.appDelegate.gameScore
            self.view?.presentScene(scene, transition: transition)
//            self.sendToPeer(send: "move")
        })
    }
    
    
//    func moveViewController(){
//        Timer.scheduledTimer(withTimeInterval: 6, repeats: false, block: {_ in
//            let transition = SKTransition.fade(withDuration: 1)
//            let scene = MenuScene(size: self.size)
//            self.view?.presentScene(scene, transition: transition)
//        })
//    }
    
    func hideHowToPlay(){
        backgroundHowToPlay.isHidden = true
        dimPanelHowToPlay.isHidden = true
        htpAnimation.isHidden = true
//        htpLadder.isHidden = true
            MusicPlayer.shared.readySoundEffect()
    }
    
    func animationChanged(pos: String){
        if pos == "player1Up" {
            if player == "player1"{
                background.position.y = background.position.y - frame.height / 128 * 5.2
                longWater.position.y = longWater.position.y - frame.height / 128 * 5.2
                if playerOneCount >= 19{
                    backgroundSky.position.y = backgroundSky.position.y - frame.height / 128 * 5.2
                }
                if playerOne.texture == playerOneLeftUp {
                    playerOne.texture = playerOneRightUp
                } else {
                    playerOne.texture = playerOneLeftUp
                }
                playerTwo.position.y = playerTwo.position.y - frame.height / 128 * 5.2
            } else if player == "player2"{
                if playerOne.texture == playerOneRightUp {
                    playerOne.texture = playerOneLeftUp
                } else {
                    playerOne.texture = playerOneRightUp
                }
                playerOne.position.y = playerOne.position.y + frame.height / 128 * 5.2
            }
            print("player one : \(playerOneCount)")
            player1Progress.position.y = player1Progress.position.y + frame.height / 64 * 0.86
            playerOneCount += 1
            
        } else if pos == "player2Up"{
            if player == "player1"{
                if playerTwo.texture == playerTwoRightUp {
                    playerTwo.texture = playerTwoLeftUp
                } else {
                    playerTwo.texture = playerTwoRightUp
                }
                playerTwo.position.y = playerTwo.position.y + frame.height / 128 * 5.2
            } else if player == "player2"{
                background.position.y = background.position.y - frame.height / 128 * 5.2
                longWater.position.y = longWater.position.y - frame.height / 128 * 5.2
                if playerTwoCount >= 19{
                    backgroundSky.position.y = backgroundSky.position.y - frame.height / 128 * 5.2
                }
                if playerTwo.texture == playerTwoRightUp {
                    playerTwo.texture = playerTwoLeftUp
                } else {
                    playerTwo.texture = playerTwoRightUp
                }
                playerOne.position.y = playerOne.position.y - frame.height / 128 * 5.2
            }
            print("player two : \(playerTwoCount)")
            player2Progress.position.y = player2Progress.position.y + frame.height / 64 * 0.86
            playerTwoCount += 1
        }
    }
    
    func winAnimation(player: String){
        if player == "player1"{
            let animationSequence = SKAction.sequence([SKAction.setTexture(SKTexture(imageNamed: "player1 finish 1")), SKAction.moveBy(x: 0, y: 0, duration: 0.1), SKAction.wait(forDuration: 0.1),
                                                       SKAction.setTexture(SKTexture(imageNamed: "player1 finish 2")), SKAction.moveBy(x: 0, y: 15, duration: 0.1), SKAction.wait(forDuration: 0.1),
                                                       SKAction.setTexture(SKTexture(imageNamed: "player1 finish 3")), SKAction.moveBy(x: 0, y: 55, duration: 0.1), SKAction.wait(forDuration: 0.5),
                                    SKAction.repeatForever(SKAction.animate(with: boyWinAnimation, timePerFrame: 0.5))])
            playerOne.run(animationSequence)
        } else if player == "player2"{
            let animationSequence = SKAction.sequence([SKAction.setTexture(SKTexture(imageNamed: "player2 finish 1")), SKAction.moveBy(x: 0, y: 0, duration: 0.1), SKAction.wait(forDuration: 0.1),
                                                       SKAction.setTexture(SKTexture(imageNamed: "player2 finish 2")), SKAction.moveBy(x: 0, y: 15, duration: 0.1), SKAction.wait(forDuration: 0.1),
                                                       SKAction.setTexture(SKTexture(imageNamed: "player2 finish 3")), SKAction.moveBy(x: 0, y: 55, duration: 0.1), SKAction.wait(forDuration: 0.5),
                                    SKAction.repeatForever(SKAction.animate(with: girlWinAnimation, timePerFrame: 0.5))])
            playerTwo.run(animationSequence)
        }
    }
    
    func runTimerCloud(){
        firstCloud()
        Timer.scheduledTimer(withTimeInterval: TimeInterval(Double.random(in: 3.0...3.3)), repeats: true, block: {_ in
            self.createCloud()
        })
    }
    
    @objc func showScoreBoard(){
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: {_ in
            self.addChild(self.dimPanel)
            self.dimPanel.run(SKAction.fadeAlpha(to: 0.9, duration: 1))
        })
        
        var win: Bool?
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: {_ in
            var scoreBoard = SKSpriteNode()
            if self.player == "player1"{
                if self.playerOneCount > self.playerTwoCount{
                    //score board win player 1
                    scoreBoard = SKSpriteNode(imageNamed: "player 1 win score")
                    win = true
                } else {
                    scoreBoard = SKSpriteNode(imageNamed: "player 1 lose score")
                    win = false
                }
            } else if self.player == "player2"{
                if self.playerOneCount > self.playerTwoCount{
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
            
        })
        
        moveViewController()
    }
    
    func firstCloud(){
        for _ in 1...2{
            let cloudSprite = SKSpriteNode(imageNamed: "cloud\(Int.random(in: 1...5))")
            cloudSprite.position = CGPoint(x: CGFloat.random(in: frame.origin.x - frame.width / 16...frame.width / 4 * 3),
                                           y: CGFloat.random(in: frame.origin.y + frame.height / 16 * 13 ... frame.origin.y + frame.height * 1.1))
            let jarak = Double.random(in: 0.1...0.7)
            cloudSprite.zPosition = CGFloat((jarak * 10) - 20)
            let moveToRight = SKAction.moveTo(x: frame.maxX * 2, duration: 30 / jarak)
            cloudSprite.scale(to: CGSize(width: Double(cloudSprite.size.width) * jarak,
                                        height: Double(cloudSprite.size.height) * jarak))
            addChild(cloudSprite)
            cloudSprite.run(moveToRight, completion: cloudSprite.removeFromParent)
        }
    }
        
        func createCloud() {
            let cloudSprite = SKSpriteNode(imageNamed: "cloud\(Int.random(in: 1...5))")
            cloudSprite.position = CGPoint(x: CGFloat.random(in: frame.origin.x - frame.width...frame.origin.x),
                                           y: CGFloat.random(in: frame.origin.y + frame.height / 16 * 10 ... frame.origin.y + frame.height * 1.1))
            let jarak = Double.random(in: 0.1...0.7)
            cloudSprite.zPosition = CGFloat((jarak * 10) - 20)
            let moveToRight = SKAction.moveTo(x: frame.maxX * 2, duration: 30 / jarak)
            cloudSprite.scale(to: CGSize(width: Double(cloudSprite.size.width) * jarak,
                                        height: Double(cloudSprite.size.height) * jarak))
            addChild(cloudSprite)
            cloudSprite.run(moveToRight, completion: cloudSprite.removeFromParent)
        }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let transition = SKTransition.fade(withDuration: 1)
//        let scene = MenuScene(size: self.size)
//
//        self.appDelegate.MPC.turnOffAdvertiser()
//        self.wcSession.sendMessage(["turnOffWorkoutSession":"yes"], replyHandler: nil, errorHandler: { (error) -> Void in
//            print("failed with error \(error)")
//        })
//        self.view?.presentScene(scene, transition: transition)
//    }
}
