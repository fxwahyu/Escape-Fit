
import SpriteKit
import WatchConnectivity
import HealthKit

class MultipeerRoom: SKScene {
    var characterBoy = SKSpriteNode()
    var characterGirl = SKSpriteNode()
    let munculMove = SKAction.fadeIn(withDuration: 0.5)
    let membesarMove = SKAction.scale(by: 4, duration: 2)
    var textWaiting = SKSpriteNode()
    let waitMove = SKAction.wait(forDuration: 3)
    var boyAnimated = SKAction()
    var girlAnimated = SKAction()
    
    var player1 = SKSpriteNode()
    var player2 = SKSpriteNode()
    var startButton = SKSpriteNode()
    var player1_image: SKTexture!
    var player2_image: SKTexture!
    var allin: Bool = false
    var player: String?
    var appDelegate:AppDelegate! = AppDelegate()
    
    override func didMove(to view: SKView) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(addPlayer), name: NSNotification.Name(rawValue: "playerAdded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveviewcontroller), name: NSNotification.Name(rawValue: "moveviewcontroller"), object: nil)
        
        runAnimateCharacter()
        createBoyCharacter()
        
        createTextWaiting()
        runCreateBackground()
        
        //FIRST HOST SCREEN NOT YET CONNECTED
        if allin == false{
           animasiFirstHostScreen()
        } else {
            animasiFirstJoinScreen()
            sendToPeer(send: "connected")
        }
    }
    
    @objc func addPlayer(notification: Notification){
        //animasi cewek
        allin = true
        textWaiting.removeFromParent()
        createGirlCharacter()
        animasiLeave()
    }
    
    func moveToGame(){
        if let view = view {
            appDelegate.musicPlayer.stopMusic()
            let transition:SKTransition = SKTransition.fade(withDuration: 1)
            let scene = CrownAlert(size: self.size)
            scene.appDelegate.MPC = self.appDelegate.MPC
            scene.appDelegate.musicPlayer = self.appDelegate.musicPlayer
            scene.player = self.player
            self.view?.presentScene(scene, transition: transition)
            appDelegate.musicPlayer.stopMusic()
            sendToPeer(send: "move")
        }
    }
    
    @objc func moveviewcontroller(notification: Notification){
        if let view = view {
            appDelegate.musicPlayer.stopMusic()
            let transition:SKTransition = SKTransition.fade(withDuration: 1)
            let scene = CrownAlert(size: self.size)
            scene.appDelegate.MPC = self.appDelegate.MPC
            scene.appDelegate.musicPlayer = self.appDelegate.musicPlayer
            scene.player = self.player
            self.view?.presentScene(scene, transition: transition)
            appDelegate.musicPlayer.stopMusic()
        }
    }
    
    func sendToPeer(send: String){
        print("masuk send to peer")
        if appDelegate.MPC.session.connectedPeers.count > 0{
            if send == "connected"{
                var message: Data = Data("playerAdded".utf8)
                print("before sending data : \(appDelegate.MPC.session.connectedPeers) with data : \(message)")
                appDelegate.MPC.sendData(data: message)
            } else if send == "move"{
                var message: Data = Data("moveviewcontroller".utf8)
                print("before sending data : \(appDelegate.MPC.session.connectedPeers) with data : \(message)")
                appDelegate.MPC.sendData(data: message)
            }
        } else{
            print("no connected peers")
        }
    }
    
    func runCreateBackground(){
        let backgroundImage = SKSpriteNode(imageNamed: "backgroundLoadingScreen")
        backgroundImage.position = CGPoint(x: frame.origin.x + frame.width / 2, y: frame.origin.y + frame.height / 2)
        backgroundImage.setScale(0.4 * 0.67)
        backgroundImage.zPosition = -20
        addChild(backgroundImage)
    }
    
    func runAnimateCharacter(){
        var boyTextures:[SKTexture] = []
        for index in 1...2 {
            boyTextures.append(SKTexture(imageNamed: "boyLoadingScreen\(index)"))
        }
        boyAnimated = SKAction.animate(with: boyTextures, timePerFrame: 0.3)
        var girlTextures:[SKTexture] = []
        for index in 1...2{
            girlTextures.append(SKTexture(imageNamed: "girlLoadingScreen\(index)"))
        }
        girlAnimated = SKAction.animate(with: girlTextures, timePerFrame: 0.3)
    }
    
    func createBoyCharacter(){
        characterBoy = SKSpriteNode(imageNamed: "boyLoadingScreen1")
        characterBoy.position = CGPoint(x: frame.origin.x + frame.width / 4, y: frame.origin.y + frame.height / 32 * 13 )
        characterBoy.setScale(0.1 * 0.67)
        characterBoy.zPosition = 3
        characterBoy.anchorPoint = CGPoint(x: 0.5, y: 1)
        addChild(characterBoy)
        characterBoy.run(SKAction.repeatForever(boyAnimated))
        characterBoy.alpha = 0
    }
    
    func animasiFirstHostScreen(){
        characterBoy.run(SKAction.sequence([munculMove,membesarMove]))
    }
    
    func animasiSecondHostScreenConnect(){
//        let x = SKAction.fadeIn(withDuration: 0.5)
//        let y = SKAction.scale(by: 4, duration: 2)
        print("masuk function animasi")
        membesarMove.timingMode = SKActionTimingMode.easeIn
//        characterGirl.alpha = 1
        DispatchQueue.main.async {
            self.characterGirl.run(SKAction.scale(by: 4, duration: 2))
        }
    }
    
    func animasiFirstJoinScreen(){
        textWaiting.removeFromParent()
        let membesarMoveBoy = SKAction.scale(by: 4, duration: 0)
        characterBoy.alpha = 1
        characterBoy.run(membesarMoveBoy)
        membesarMove.timingMode = SKActionTimingMode.easeIn
        
        createGirlCharacter()
        animasiLeave()
        Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: {_ in
            self.moveToGame()
        })
    }

    func animasiLeave(){
        let geserBoyMove = SKAction.moveTo(x: self.frame.origin.x - self.frame.width , duration: 0.8)
        let geserGirlMove = SKAction.moveTo(x: self.frame.origin.x + self.frame.width * 2 , duration: 1)
        self.characterBoy.run(SKAction.sequence([self.waitMove,geserBoyMove]))
        self.characterBoy.run(SKAction.sequence([self.waitMove,self.membesarMove]))
        self.characterGirl.run(SKAction.sequence([self.waitMove,geserGirlMove]))
        self.characterGirl.run(SKAction.sequence([self.waitMove,self.membesarMove]))
        
    }
    
    func createGirlCharacter(){
        characterGirl = SKSpriteNode(imageNamed: "girlLoadingScreen1")
        characterGirl.position = CGPoint(x: frame.origin.x + frame.width * 3 / 4 , y: frame.origin.y + frame.height / 32 * 13 )
        characterGirl.setScale(0.1 * 0.67)
        characterGirl.zPosition = 3
        characterGirl.anchorPoint = CGPoint(x: 0.5, y: 1)
        addChild(characterGirl)
        characterGirl.alpha = 1
        characterGirl.run(SKAction.repeatForever(girlAnimated))
        characterGirl.run(SKAction.sequence([munculMove,membesarMove]))
        
    }
    
    func createTextWaiting(){
        textWaiting = SKSpriteNode(imageNamed: "waitingLoadingScreen")
        textWaiting.position = CGPoint(x: frame.origin.x + frame.width / 2, y: frame.origin.y + frame.height * 3 / 4 )
        textWaiting.setScale(0.4 * 0.67)
        textWaiting.zPosition = 1
        textWaiting.alpha = 0
        addChild(textWaiting)
        let muncul = SKAction.fadeOut(withDuration: 1)
        let hilang = SKAction.fadeIn(withDuration: 1)
        textWaiting.run(SKAction.repeatForever(SKAction.sequence([muncul, SKAction.wait(forDuration: 0.5), hilang])))
    }
    
}
