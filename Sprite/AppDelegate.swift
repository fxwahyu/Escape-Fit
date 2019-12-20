//
//  AppDelegate.swift
//  Sprite
//
//  Created by Felix Kylie on 24/09/19.
//  Copyright © 2019 Felix Kylie. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {
    var MPC:mpc = mpc()
    var musicPlayer: MusicPlayer = MusicPlayer()
    var gameScore: GameScore = GameScore()
    var session: WCSession?

    var window: UIWindow?
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let data = message["game"]{ //if message is motion data from watch
            if data as! String == "pump"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "motiondataPump"), object: self, userInfo: message)
            } else if data as! String == "ladder"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "motiondataLadder"), object: self, userInfo: message)
            } else if data as! String == "flappy"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "motiondataFlappy"), object: self, userInfo: message)
            }
        }
        
        if let data = message["ready"]{
            if data as! String == "pump"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "readyToPlayPump"), object: self, userInfo: message)
            } else if data as! String == "ladder"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "readyToPlayLadder"), object: self, userInfo: message)
            }
        }
        
        if let data = message["watchConnectivity"]{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "watchConnectivity"), object: self, userInfo: message)
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.isIdleTimerDisabled = true
        if WCSession.isSupported() {
            session = WCSession.default
            session!.delegate = self
            session!.activate()
        }

        return true
    }

    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        MPC.turnOffAdvertiser()
        self.session!.sendMessage(["turnOffWorkoutSession":"yes"], replyHandler: nil, errorHandler: { (error) -> Void in
            print("failed with error \(error)")
        })
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "turnOffWorkoutSession"), object: self, userInfo: ["":""])
    }
    
    class func sharedInstance() -> AppDelegate{
       return UIApplication.shared.delegate as! AppDelegate
    }
}

