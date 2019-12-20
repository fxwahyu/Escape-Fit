//
//  InterfaceController.swift
//  watch Extension
//
//  Created by Wahyu Herdianto on 18/10/19.
//  Copyright © 2019 Felix Kylie. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import CoreMotion
import HealthKit

class InterfaceController: WKInterfaceController, HKWorkoutSessionDelegate {
    
    @IBOutlet weak var label_: WKInterfaceLabel!
    @IBOutlet weak var startActivity: WKInterfaceButton!
    @IBOutlet weak var imageReady: WKInterfaceImage!
    
    var playBegin : Bool?
    var wcSession = WCSession.default
    var motion = CMMotionManager()
    let healthStore = HKHealthStore()
    var workoutSession: HKWorkoutSession!
    var displayedText: String?
    var game: String?
    var workoutStarted: Bool = false
    var valid = true
    var counter = 0
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        label_.setText("Waiting for the game instruction")
        startActivity.setHidden(true)
        imageReady.setHidden(true)
        notificationCenter()
//        NotificationCenter.default.addObserver(self, selector: #selector(DisplayedText), name: NSNotification.Name(rawValue: "displayedText"), object: nil)
    }
    
    func notificationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(checkWatchConnectivity), name: NSNotification.Name(rawValue: "watchConnectivity"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeGameplayStatus), name: NSNotification.Name(rawValue: "gameplay"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(turnOffWorkoutSession), name: NSNotification.Name(rawValue: "turnOffWorkoutSession"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerSetup), name: NSNotification.Name(rawValue: "playerSetup"), object: nil)
    }
    
    override func willActivate() {
        super.willActivate()
        if workoutStarted == false{
            setupWorkoutSession()
        }
        print("masuk willactivate")
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        if toState.rawValue == 2{
            print("status menjadi : running")
            workoutStarted = true
        } else if toState.rawValue == 3{
            print("status menjadi : stopped")
            workoutStarted = false
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        
    }
    
    @objc func changeGameplayStatus(notification: Notification){
        let info = notification.userInfo!
        let message = info["gameplay"] as! String
        if message == "start"{
            let displayedText = info["displayedText"] as! String
            let game_ = info["game"] as! String
//            label_.setText(displayedText)
            game = game_
            label_.setHidden(true)
            imageReady.setHidden(false)
            
            startActivity.setHidden(false)
            startActivity.setTitle("Ready")
        } else if message == "done"{
            label_.setText("Game finished! Waiting for the game instruction")
        }
    }
    
    @objc func playerSetup(notification: Notification){
        let info = notification.userInfo!
        if info["playerSetup"] as! String == "player1"{
            print("player1")
            imageReady.setImage(UIImage(named: "ready watch boy"))
            imageReady.setWidth(100)
            imageReady.setHeight(100)
        } else{
            print("player2")
            imageReady.setImage(UIImage(named: "ready watch girl"))
            imageReady.setWidth(100)
            imageReady.setHeight(120)
        }
    }
    
    @objc func checkWatchConnectivity(){
        if workoutStarted == true{
            self.wcSession.sendMessage(["watchConnectivity":"ready"], replyHandler: nil, errorHandler: { (error) -> Void in
            print("failed with error \(error)")})
        } else{
            setupWorkoutSession()
            if workoutStarted == true{
                self.wcSession.sendMessage(["watchConnectivity":"ready"], replyHandler: nil, errorHandler: { (error) -> Void in
                print("failed with error \(error)")})
            } else{
                self.wcSession.sendMessage(["watchConnectivity":"not ready"], replyHandler: nil, errorHandler: { (error) -> Void in
                print("failed with error \(error)")})
            }
        }
    }
    
    @objc func turnOffWorkoutSession(){
        workoutSession.end()
        motion.stopDeviceMotionUpdates()
        label_.setHidden(false)
        label_.setText("Game is done")
        startActivity.setHidden(true)
        imageReady.setHidden(true)
        print("game closed")
        print("workout session running : \(workoutStarted)")
    }
    
    func getTimestamp() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "HH:mm:ss.SSSS"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
    
    @IBAction func startStop() {
        startActivity.setHidden(true)
        label_.setHidden(false)
        imageReady.setHidden(true)
        if game == "pump"{
            self.label_.setText("Pump Your Baloon!")
            self.wcSession.sendMessage(["ready":"pump"], replyHandler: nil, errorHandler: { (error) -> Void in
            print("failed with error \(error)")})
        } else if game == "ladder"{
            self.label_.setText("Climb Climb Climb!")
            self.wcSession.sendMessage(["ready":"ladder"], replyHandler: nil, errorHandler: { (error) -> Void in
            print("failed with error \(error)")})
        } else if game == "flappy"{
            self.label_.setText("Flap your hand!")
            self.wcSession.sendMessage(["ready":"ladder"], replyHandler: nil, errorHandler: { (error) -> Void in
            print("failed with error \(error)")})
        }
    }
    
    func setupWorkoutSession(){
        print("workout starting")
        let workoutConfig = HKWorkoutConfiguration()
        workoutConfig.activityType = .dance
        workoutConfig.locationType = .unknown
        workoutStarted = true
        label_.setText("Waiting for the game instruction")
        
        do {
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfig)
            workoutSession.delegate = self
            workoutSession.startActivity(with: Date())
            myAccelerometer()
        } catch {
            fatalError("Unable to create the workout session!")
        }
    }
    
    @objc func myAccelerometer() {
        motion.deviceMotionUpdateInterval = 0.1
        motion.startDeviceMotionUpdates(to: OperationQueue.current!) { (data, error) in
            data as Any
            if let Data = data{
                let accx = String(Double(Data.userAcceleration.x).rounded(toPlaces: 3))
                let accy = String(Double(Data.userAcceleration.y).rounded(toPlaces: 3))
                let accz = String(Double(Data.userAcceleration.z).rounded(toPlaces: 3))
                
                let gyrox = String(Double(Data.rotationRate.x).rounded(toPlaces: 3))
                let gyroy = String(Double(Data.rotationRate.y).rounded(toPlaces: 3))
                let gyroz = String(Double(Data.rotationRate.z).rounded(toPlaces: 3))
                
                let time: String = self.getTimestamp()
                
//                self.label_.setText(accx)
                
                let message = [
                    "game":self.game,
                    "time":time,
                    "accx":accx,
                    "accy":accy,
                    "accz":accz,
                    "gyrox":gyrox,
                    "gyroy":gyroy,
                    "gyroz":gyroz
                ]
                
                let x = Double(accx)!
                let y = Double(accy)!
                let z = Double(accz)!
                
//                if self.valid == true && z >= 1.2{
//                    print("fly ke - \(self.counter)")
//                    print("\(accx)\t\(accy)\t\(accz)")
//                    self.valid = false
//                    self.counter += 1
//                }
//
//                if self.valid == false && z < 1.0{
//                    self.valid = true
//                }
                
                
//                if z > 1.5{
//                    print("fly Z")
//                    print("\(accx)\t\(accy)\t\(accz)")
//                }
            
                
                if self.wcSession.isReachable == true{
                    self.wcSession.sendMessage(message, replyHandler: nil, errorHandler: { (error) -> Void in
                        print("failed with error \(error)")
                    })
                } else{
                    print("not reachable")
                }
            }
        }
    }
}

extension Double{
    func rounded(toPlaces places:Int) -> Double{
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
