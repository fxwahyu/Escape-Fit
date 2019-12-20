
import SpriteKit
import WatchConnectivity
import HealthKit
import MultipeerConnectivity

struct Layer {
    static let wave1:CGFloat = -16
    static let wave2:CGFloat = -12
    static let wave3:CGFloat = -8
    static let wave4:CGFloat = -4
    static let buttonJoin:CGFloat = -10
    static let buttonCreate:CGFloat = -10
    static let backgroundImage:CGFloat = -25
}

class CreateRoom: SKScene {
    var gameTimer: Timer?

    var create = SKSpriteNode()
    var join = SKSpriteNode()
    var background = SKSpriteNode()
    var appDelegate:AppDelegate! = AppDelegate()
    var wcSession = WCSession.default


    override func didMove(to view: SKView) {
        appDelegate.MPC.setupConnection()
//        appDelegate.musicPlayer.stopBackgroundMusic()
        NotificationCenter.default.addObserver(self, selector: #selector(peersConnected), name: NSNotification.Name(rawValue: "peersConnected"), object: nil)
        
//        background = SKSpriteNode(imageNamed: "BackgroundJoinCreate")
//        background.size = self.frame.size
//        background.position = CGPoint(x: frame.midX, y: frame.midY)
//        background.zPosition = -2
//        addChild(background)
        
        createButton()
        runBackground()
        runTimerMeteor()
        runCreateWave()
        runTimerCloud()
        firstCloud()
        
    }
    
    func createButton(){
        create = SKSpriteNode(imageNamed: "CreateButton")
        create.size = CGSize(width: 200, height: 44.5)
        create.position = CGPoint(x: frame.midX, y: frame.midY + 30)
        create.zPosition = 1
        create.setScale(0.9)
        addChild(create)
        
        join = SKSpriteNode(imageNamed: "JoinButton")
        join.size = CGSize(width: 200, height: 44.5)
        join.position = CGPoint(x: frame.midX, y: frame.midY - 20)
        join.zPosition = 1
        join.setScale(0.9)
        addChild(join)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            MusicPlayer.shared.clickSoundEffect()

            if node == create {
                appDelegate.MPC.setupAdvertiser()
                if wcSession.isReachable{
                    self.wcSession.sendMessage(["playerSetup":"player1"], replyHandler: nil, errorHandler: { (error) -> Void in
                        print("failed with error \(error)")
                    })
                }

                if let view = view {
                    let transition:SKTransition = SKTransition.fade(withDuration: 0.1)
                    let scene = MultipeerRoom(size: self.size)
                    scene.appDelegate.MPC = self.appDelegate.MPC
                    scene.appDelegate.musicPlayer = self.appDelegate.musicPlayer
                    scene.player = "player1"
                    self.view?.presentScene(scene, transition: transition)
                }
            } else if node == join {
                appDelegate.MPC.setupBrowser()
                if wcSession.isReachable{
                    self.wcSession.sendMessage(["playerSetup":"player2"], replyHandler: nil, errorHandler: { (error) -> Void in
                        print("failed with error \(error)")
                    })
                }

                view?.window?.rootViewController?.present(appDelegate.MPC.browser, animated: true)
            }
        }
    }
    
    @objc func peersConnected(notification: Notification){
        if let view = view {
            let transition:SKTransition = SKTransition.fade(withDuration: 0)
            let scene = MultipeerRoom(size: self.size)
            scene.appDelegate.MPC = self.appDelegate.MPC
            scene.appDelegate.musicPlayer = self.appDelegate.musicPlayer
            scene.allin = true
            scene.player = "player2"
            self.view?.presentScene(scene, transition: transition)
        }
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
    
    func runTimerCloud(){
            for _ in 1...3{
                Timer.scheduledTimer(withTimeInterval: Double.random(in: 0.5 ... 1.5), repeats: false, block: {_ in
                    self.createCloud()
                })
            }
            gameTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(Int.random(in: 3...5)), repeats: true, block: {_ in
                self.createCloud()
            })
        }
        
        func runTimerMeteor(){
            for _ in 1...3{
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {_ in
                    self.createMeteor()
                })
            }
            gameTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(Int.random(in: 3...5)), repeats: true, block: {_ in
                self.createMeteor()
            })
        }
        
        func runCreateWave() {
            for index in 1...4{
                let wave = SKSpriteNode(imageNamed: "wave\(index)")
                wave.setScale(1.7 * 0.67)
                wave.position = CGPoint(x: CGFloat(frame.origin.x + frame.width / 2),
                                        y: CGFloat(Int(frame.origin.y) + index * Int(frame.height) / 15))
                wave.zPosition = CGFloat(index * -5)
                addChild(wave)
            }
        }
        
        func createCloud() {
            let cloudSprite = SKSpriteNode(imageNamed: "cloud\(Int.random(in: 1...5))")
            cloudSprite.position = CGPoint(x: frame.origin.x - frame.width / 4 * 3, y: CGFloat.random(in: frame.origin.y + frame.height / 2 ... frame.origin.y + frame.height))
            let jarak = Double.random(in: 0.1...2.0)
            cloudSprite.zPosition = CGFloat((jarak * 10) - 20)
            let moveToRight = SKAction.moveTo(x: frame.maxX * 2, duration: 30 / jarak)
            cloudSprite.scale(to: CGSize(width: Double(cloudSprite.size.width) * jarak,
                                         height: Double(cloudSprite.size.height) * jarak))
            addChild(cloudSprite)
            cloudSprite.run(moveToRight, completion: cloudSprite.removeFromParent)
        }
            
        func createMeteor(){
            let meteorSprite = SKSpriteNode(imageNamed: "meteor")
            meteorSprite.position = CGPoint(x: frame.origin.x - frame.width / 4,
                                            y: CGFloat.random(in: frame.origin.y + frame.height / 2...frame.origin.y + frame.height * 2))
            let jarak = Double.random(in: 0.1...2.0)
            meteorSprite.zPosition = CGFloat((jarak) * 10) - 20
            let fallMovement = SKAction.moveBy(x: 1125, y: -2001, duration: 10 / jarak)
            meteorSprite.scale(to: CGSize(width: Double(meteorSprite.size.width) * jarak, height: Double(meteorSprite.size.height) * jarak))
            meteorSprite.run(fallMovement, completion: meteorSprite.removeFromParent)
            addChild(meteorSprite)
            print(meteorSprite.zPosition)
    //        SUARA METEOR DI BERI DELAY
    //        JIKA JARAK JAUH MAKA DURASI LAYAR LAMA
    //        JIKA JARAK DEKAT MAKA DURASI LAYAR CEPAT
//            if meteorSprite.zPosition <= -16  {
//                Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: {_ in })
//                print("suara jauh 16-20\n")
//            }else if meteorSprite.zPosition <= -12{
//                Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: {_ in })
//                print("suara jauh 12-15\n")
//            } else if meteorSprite.zPosition <= -8{
//                Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: {_ in })
//                print("suara agak dekat 8-11\n")
//            } else if meteorSprite.zPosition <= -4{
//                Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: {_ in })
//                print("suara dekat 4-7")
//            } else if meteorSprite.zPosition <= 0{
//                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {_ in })
//                print("suara dekat besar 0-3\n")
//            }
            
            }
        
        func runBackground(){
            background = SKSpriteNode(imageNamed: "backgroundCreateJoin")
            background.size = self.frame.size
            background.position = CGPoint(x: frame.midX, y: frame.midY)
            background.zPosition = -25
            addChild(background)
        }

    
    
}
