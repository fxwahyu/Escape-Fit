//
//  mpc.swift
//  WatchTest
//
//  Created by Wahyu Herdianto on 15/10/19.
//  Copyright © 2019 Wahyu Herdianto. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class mpc: NSObject, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    var peerID:MCPeerID!
    var session:MCSession!
    var browser:MCBrowserViewController!
    var advertiser:MCAdvertiserAssistant? = nil
    
    func setupConnection(){
        peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
    }
    
    func sendData(data: Data){
        do {
            let str = String(decoding: data, as: UTF8.self)
//            print("inside mpc : \(session.connectedPeers) with data : \(str)")
            try self.session.send(data, toPeers: self.session.connectedPeers, with: .reliable)
        }
        catch {
          print("Error sending message")
        }
    }

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")

        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")

        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do{
            DispatchQueue.main.async {
                // send chat message
                let str = String(decoding: data, as: UTF8.self)
                
                if Array(str)[0] == "y"{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "enemyPosition"), object: self, userInfo:["y":str])
                }
                
//                print("inside the message : \(str)")
                if str == "playerAdded"{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playerAdded"), object: self, userInfo:["":""])
                } else if str == "moveviewcontroller"{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "moveviewcontroller"), object: self, userInfo:["":""])
                } else if str == "playerReady"{
                     NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playerReady"), object: self, userInfo:["":""])
                } else if str == "enemyUp"{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "enemyUp"), object: self, userInfo:["":""])
                } else if str == "move"{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "continueToGame2"), object: self, userInfo:["":""])
                } else if str == "enemyPump"{
                     NotificationCenter.default.post(name: NSNotification.Name(rawValue: "enemyPump"), object: self, userInfo:["":""])
                } else if str == "finish"{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ladderFinished"), object: self, userInfo:["":""])
                } else if str == "scoreBoard"{
                   NotificationCenter.default.post(name: NSNotification.Name(rawValue: "scoreBoard"), object: self, userInfo:["":""])
                } else if str == "skipStory"{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "skipStory"), object: self, userInfo:["":""])
                } else if str == "gameStarts"{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gameStarts"), object: self, userInfo:["":""])
                } else if str == "enemyFlap"{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "enemyFlap"), object: self, userInfo:["":""])
                } else if str == "player1Crash"{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "player1Crash"), object: self, userInfo:["":""])
                } else if str == "player2Crash"{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "player2Crash"), object: self, userInfo:["":""])
                } else if str == "gameDone"{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gameDone"), object: self, userInfo:["":""])
                }
            }
        }catch{
            fatalError("Unable to process recieved data")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func setupAdvertiser(){
        advertiser = MCAdvertiserAssistant(serviceType: "escape-fit", discoveryInfo: nil, session: session)
        advertiser!.start()
    }
    
    func setupBrowser(){
        browser = MCBrowserViewController(serviceType: "escape-fit", session: session)
        browser.delegate = self
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "peersConnected"), object: self, userInfo: ["peers":"connected"])
        AppDelegate.sharedInstance().window?.rootViewController!.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        AppDelegate.sharedInstance().window?.rootViewController!.dismiss(animated: true, completion: nil)

    }
    
    func turnOffAdvertiser(){
        advertiser?.stop()
    }
}
