//
//  GameViewController.swift
//  SuperSoduku
//
//  Created by BIINGYANN HSIUNG on 12/20/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController,GameControllerDelegation
{
    var diffculty:GameDifficulty = GameDifficulty.easy
    override func viewDidLoad()
    {
        UserProfile.playCount++
        super.viewDidLoad()
        navigationController?.navigationBar.hidden = true
        UIApplication.sharedApplication().statusBarHidden = false;
        if(view.frame.height>480){
            addBanner()
        }
        goGame()
    }
    func goGame()
    {
        let scene = GameScene();
        scene.gameControllerDelegation = self
        let skView = self.view as SKView;
        
        scene.scaleMode = .ResizeFill
        scene.anchorPoint = CGPoint(x:0,y:1);
        scene.size = CGSizeMake(skView.bounds.size.width, skView.bounds.size.height)
        scene.difficulty = diffculty
        skView.presentScene(scene)
    }
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    func quitFromGame() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}