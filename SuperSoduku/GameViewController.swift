//
//  GameViewController.swift
//  SuperSoduku
//
//  Created by BIINGYANN HSIUNG on 12/20/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

import UIKit
import SpriteKit
import iAd


protocol GameControllerDelegation{
    func difficultySelected(d:GameDifficulty)
    func quitFromGame()
}

class GameViewController: UIViewController,GameControllerDelegation {

    let bannerHeight:CGFloat = 50
    override func viewDidLoad() {
        super.viewDidLoad()
        goDifficultySelector()
        //goGame()
        
    }
    override func viewDidAppear(animated: Bool) {
        var adView:ADBannerView = ADBannerView(frame:
            CGRectMake(0, view.frame.size.height-bannerHeight, 320, bannerHeight));
        self.view.addSubview(adView)
    }
    func goGame(d:GameDifficulty)
    {
        let scene = GameScene();
        let skView = self.view as SKView;
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        
        scene.scaleMode = .ResizeFill
        scene.anchorPoint = CGPoint(x:0,y:1);
        scene.size = CGSizeMake(skView.bounds.size.width, skView.bounds.size.height)
        scene.difficulty = d
        scene.gameControllerDelegation = self
        
        skView.presentScene(scene)
    }
    func goDifficultySelector()
    {
        let scene = DifficultySelectorScene();
        let skView = self.view as SKView;
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        
        scene.scaleMode = .ResizeFill
        scene.anchorPoint = CGPoint(x:0,y:1);
        scene.size = CGSizeMake(skView.bounds.size.width, skView.bounds.size.height-bannerHeight)
        scene.gameControllerDelegation = self
        
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

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    func difficultySelected(d: GameDifficulty) {
        println("root \(d.text)")
        goGame(d)
    }
    func quitFromGame() {
        goDifficultySelector()
    }
}
