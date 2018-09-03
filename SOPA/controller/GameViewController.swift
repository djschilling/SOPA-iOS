//
//  GameViewController.swift
//  SOPA
//
//  Created by David Schilling on 21.10.17.
//  Copyright © 2017 David Schilling. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ResourcesManager.prepareManager(appDelegate: UIApplication.shared.delegate as! AppDelegate)
        ResourcesManager.getInstance().levelService?.updateLevelInfos()
        //let level = ResourcesManager.getInstance().levelService!.getLevelById(id: 1)!
        //let scene = LevelModeGameScene(size: view.bounds.size, level: level)
        let scene = LevelChoiceScene(size: view.bounds.size, levelService: ResourcesManager.getInstance().levelService!)
        let skView = view as! SKView
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

