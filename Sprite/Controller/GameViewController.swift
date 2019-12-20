//
//  GameViewController.swift
//  Sprite
//
//  Created by Felix Kylie on 24/09/19.
//  Copyright © 2019 Felix Kylie. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import WatchConnectivity
import HealthKit

class GameViewController: UIViewController {

    var appDelegate: AppDelegate = AppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = MenuScene(size: view.bounds.size)
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .resizeFill
                view.ignoresSiblingOrder = true
                view.showsFPS = false
                view.showsNodeCount = false
                
                // Present the scene
                view.presentScene(scene)
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
