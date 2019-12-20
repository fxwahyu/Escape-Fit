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

struct layer {
    static let background:CGFloat = -21
    static let titleGame:CGFloat = 0
    //    awan random -20 sampai 0 || title game berada di tengah = -10
    static let part1:CGFloat = -1   //asap bawah
    static let part2:CGFloat = 0   //mushroom asap
    static let part3:CGFloat = 1   //asap tengah
    static let ground:CGFloat = 0
    static let mountain:CGFloat = 2
    static let firstCharacter:CGFloat = 3
}

class MenuScene: SKScene {
    
    var timer: Timer?
    var timerSmoke: Timer?

    var background = SKSpriteNode()
    var playButton = SKSpriteNode()
    var alert = SKSpriteNode()
    var volumeButton = SKSpriteNode()
    var dimPanel = SKSpriteNode()
    var okButton = SKSpriteNode()
    var muted: Bool = false
    var appDelegate: AppDelegate = AppDelegate()
    var wcSessionConnected: Bool = false
    var wcSession = WCSession.default

    override func didMove(to view: SKView) {
        
//        self.wcSession.sendMessage(["gameStarts":"starts"], replyHandler: nil, errorHandler: { (error) -> Void in
//            print("failed with error \(error)")
//        })
        
//        appDelegate.MPC.turnOffAdvertiser()
        appDelegate.musicPlayer.startMenuBackgroundMusic()
        notificationCenter()
//        appDelegate.musicPlayer.startMenuBackgroundMusic()
        
        playButton.size = CGSize(width: 200, height: 44.5)
        playButton.texture = SKTexture(imageNamed: "playButtonEdit")
        playButton.position = CGPoint(x: frame.midX, y: 110)
        playButton.zPosition = 9
//        playButton.setScale(0.8)
        addChild(playButton)
        
//        volumeButton.size = CGSize(width: 44, height: 46)
//        volumeButton.texture = SKTexture(imageNamed: "soundon")
//        volumeButton.position = CGPoint(x: frame.maxX - 50, y: frame.maxY - 70)
//        volumeButton.zPosition = 10
//        addChild(volumeButton)
        
        alert.size = CGSize(width: 486.65, height: 680)
        alert.texture = SKTexture(imageNamed: "alert watch app")
        alert.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        alert.zPosition = 12
        alert.setScale(0.6)
        addChild(alert)
        alert.isHidden = true
        
        okButton.size = CGSize(width: 239, height: 62)
        okButton.texture = SKTexture(imageNamed: "okbutton_fix")
        okButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 160)
        okButton.zPosition = 13
        okButton.setScale(0.6)
        addChild(okButton)
        okButton.isHidden = true
        
        dimPanel = SKSpriteNode(color: UIColor.black, size: self.size)
        dimPanel.alpha = 0.75
        dimPanel.zPosition = 11
        dimPanel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        addChild(dimPanel)
        dimPanel.isHidden = true
        
        runCreatetitleGame()
        runTimerCloud()
        runCreateCharacter()
        runCreateGround()
        runCreateBackground()
        runExplotion()
        firstCloud()
    }
    
    func notificationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(watchConnectivity), name: NSNotification.Name(rawValue: "watchConnectivity"), object: nil)
    }
    
    @objc func watchConnectivity(notification: Notification){
        let info = notification.userInfo!
        DispatchQueue.main.async {
            if info["watchConnectivity"] as! String == "ready"{
                if let view = self.view {
                    let transition:SKTransition = SKTransition.fade(withDuration: 1)
                    let scene = CreateRoom(size: self.size)
                    scene.appDelegate.musicPlayer = self.appDelegate.musicPlayer
                    self.view?.presentScene(scene, transition: transition)
                }
            } else if info["watchConnectivity"] as! String == "not ready"{
                // tampilkan alert
                self.alert.isHidden = false
                self.dimPanel.isHidden = false
                self.okButton.isHidden = false
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
//            print("node is : \(node)")
            if node == playButton {
                MusicPlayer.shared.clickSoundEffect()
                
//                if let view = self.view {
//                    let transition:SKTransition = SKTransition.fade(withDuration: 1)
//                    let scene = CreateRoom(size: self.size)
//                    scene.appDelegate.musicPlayer = self.appDelegate.musicPlayer
//                    self.view?.presentScene(scene, transition: transition)
//                }
                
                if wcSession.isReachable{
                    self.wcSession.sendMessage(["watchConnectivity":"check"], replyHandler: nil, errorHandler: { (error) -> Void in
                        print("failed with error \(error)")
                    })
                } else{
                    alert.isHidden = false
                    dimPanel.isHidden = false
                    okButton.isHidden = false
                }
                
//            else if node == volumeButton{
//                if muted == false{
//                    muted = true
//                    volumeButton.texture = SKTexture(imageNamed: "soundoff")
//                    appDelegate.musicPlayer.mute()
//                } else{
//                    muted = false
//                    MusicPlayer.shared.clickSoundEffect()
//                    volumeButton.texture = SKTexture(imageNamed: "soundon")
//                    appDelegate.musicPlayer.unMute()
//                }
            } else if node == okButton{
                alert.isHidden = true
                dimPanel.isHidden = true
                okButton.isHidden = true
            }
        }
    }
    
    func runExplotion(){
            runMushroomExplotion()
            runMiddleExplotion()
            runBottomExplotion()
        }
        
        func firstCloud(){
            for _ in 1...5{
                let cloudSprite = SKSpriteNode(imageNamed: "cloud\(Int.random(in: 1...5))")
                cloudSprite.position = CGPoint(x: CGFloat.random(in: frame.origin.x - frame.width / 4...frame.width / 2), y: CGFloat.random(in: frame.origin.y + frame.height / 2 ... frame.origin.y + frame.height / 10 * 8))
                let jarak = Double.random(in: 0.1...2.0)
                cloudSprite.zPosition = CGFloat((jarak * 10) - 20)
                let moveToRight = SKAction.moveTo(x: frame.maxX * 2, duration: 30 / jarak)
                cloudSprite.scale(to: CGSize(width: Double(cloudSprite.size.width) * jarak,
                                            height: Double(cloudSprite.size.height) * jarak))
                addChild(cloudSprite)
                cloudSprite.run(moveToRight, completion: cloudSprite.removeFromParent)
            }
        }
        
        func runBottomExplotion() {
            let part1 = SKSpriteNode(imageNamed: "explotion1")
            part1.setScale(0.17 * 0.67)
            part1.position = CGPoint(x: frame.origin.x + frame.width / 2, y: frame.origin.y + frame.height / 10 * 4)
            part1.anchorPoint = CGPoint(x: 0.5, y: 0)
            part1.zPosition = layer.part1
            
            let scale = SKAction.scale(by: 1.3, duration: 1)
            scale.timingMode = SKActionTimingMode.easeOut
            part1.run(scale)
            addChild(part1)
        }
        
        func runMushroomExplotion(){
            let part2 = SKSpriteNode(imageNamed: "explotion2")
            part2.setScale(0.1 * 0.67)
            part2.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            part2.position = CGPoint(x: frame.origin.x + frame.width / 2, y: frame.origin.y + frame.height / 16 * 8.5)
            part2.zPosition = layer.part2
            
            let scale = SKAction.scale(by: 3.9, duration: 1)
            scale.timingMode = SKActionTimingMode.easeOut
            part2.run(scale)
            addChild(part2)
        }
        
        func runMiddleExplotion(){
            let part3 = SKSpriteNode(imageNamed: "explotion3")
            part3.setScale(0.1 * 0.67)
            part3.anchorPoint = CGPoint(x: 0.5, y: 0.4)
            part3.position = CGPoint(x: frame.origin.x + frame.width / 2, y: frame.origin.y + frame.height / 2)
            part3.zPosition = layer.part3
            part3.alpha = 0
            let wait = SKAction.wait(forDuration: 0)
            let appear = SKAction.fadeIn(withDuration: 0)
            let firstScale = SKAction.scale(by: 3.9, duration: 1.5)
            firstScale.timingMode = SKActionTimingMode.easeOut
            part3.run(SKAction.sequence([wait,appear]))
            part3.run(SKAction.sequence([wait, firstScale]))
            addChild(part3)
        }

        func runCreateBackground(){
            let backgroundMainMenu = SKSpriteNode(imageNamed: "backgroundMainMenu")
            backgroundMainMenu.position = CGPoint(x: frame.origin.x + frame.width / 2, y: frame.origin.y + frame.height / 2)
            backgroundMainMenu.zPosition = layer.background
            backgroundMainMenu.setScale(0.4 * 0.67)
            addChild(backgroundMainMenu)
        }
        
        func runCreateGround(){
            let groundMainMenu = SKSpriteNode(imageNamed: "groundMainMenu")
            groundMainMenu.position = CGPoint(x: frame.origin.x + frame.width / 2, y: frame.origin.y + frame.height / 2)
            groundMainMenu.setScale(0.4 * 0.67)
            groundMainMenu.zPosition = layer.ground
            addChild(groundMainMenu)
        }
        
        func runCreateCharacter(){
            let characterGame = SKSpriteNode(imageNamed: "characterMainMenu")
            characterGame.position = CGPoint(x: frame.origin.x + frame.width / 32 * 15 ,
                                             y: frame.origin.y + frame.height / 4)
            characterGame.zPosition = layer.firstCharacter
            characterGame.setScale(0.4 * 0.67)
            addChild(characterGame)
        }
        
        func runCreatetitleGame(){
            let titleGame = SKSpriteNode(imageNamed: "titleMainMenu")
            titleGame.position = CGPoint(x: frame.origin.x + frame.width / 2, y: frame.origin.y + frame.height / 16 * 10.9)
            titleGame.anchorPoint = CGPoint(x: 0.5, y: 0)
            titleGame.zPosition = layer.titleGame
            titleGame.setScale(0.1 * 0.67)
            addChild(titleGame)
            titleGame.alpha = 0
            let tunggu = SKAction.wait(forDuration: 0.5)
            let muncul = SKAction.fadeIn(withDuration: 0.5)
            let membesar = SKAction.scale(by: 3.9, duration: 0.5)
            membesar.timingMode = SKActionTimingMode.easeInEaseOut
            titleGame.run(SKAction.sequence([tunggu,muncul]))
            titleGame.run(SKAction.sequence([tunggu, membesar]))
        }
        
        
        
        func runTimerCloud(){
    //        for _ in 1...5{
    //            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: {_ in
    //                self.createCloud()
    //            })
    //        }
            Timer.scheduledTimer(withTimeInterval: TimeInterval(Int.random(in: 3...5)), repeats: true, block: {_ in
                self.createCloud()
            })
        }
        
        func createCloud() {
            let cloudSprite = SKSpriteNode(imageNamed: "cloud\(Int.random(in: 1...5))")
            cloudSprite.position = CGPoint(x: frame.origin.x - frame.width / 2, y: CGFloat.random(in: frame.origin.y + frame.height / 2 ... frame.origin.y + frame.height))
            let jarak = Double.random(in: 0.1...2.0)
            cloudSprite.zPosition = CGFloat((jarak * 10) - 20)
            let moveToRight = SKAction.moveTo(x: frame.maxX * 2, duration: 30 / jarak)
            cloudSprite.scale(to: CGSize(width: Double(cloudSprite.size.width) * jarak,
                                        height: Double(cloudSprite.size.height) * jarak))
            addChild(cloudSprite)
            cloudSprite.run(moveToRight, completion: cloudSprite.removeFromParent)
        }
    
}
