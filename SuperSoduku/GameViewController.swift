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
        UserProfile.playCount++
        super.viewDidLoad()
        var adView:ADBannerView = ADBannerView(frame:
            CGRectMake(0, view.frame.size.height-bannerHeight, 320, bannerHeight));
        self.view.addSubview(adView)
        goDifficultySelector()
        //goGame()
        
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
class UserProfile
{
    class var playCount:Int{
        get{
            if var v:Int = UserProfile.getValue("playCount") as? Int{
                return v;
            }else{
                return 0;
            }
        }
        set{
            var v:Int = UserProfile.playCount as Int
            UserProfile.setValue("playCount", value: newValue)
        }
    }
    class var exp:Int{
        get{
            if var v:Int = UserProfile.getValue("exp") as? Int{
                return v;
            }else{
                return 0;
            }
        }
        set{
            var v:Int = UserProfile.playCount as Int
            UserProfile.setValue("exp", value: newValue)
        }
    }
    class var lv:Int{
        // 50,130=50*2.6,338=50*2.6*2.6...
        var currentExp = Float(UserProfile.exp)
        var level:Float = 0
        var baseExp:Float = 50
        var requiredExp:Float = baseExp
        let maxLevel:Float = 100
        while(requiredExp <= currentExp && level < maxLevel){
            requiredExp += baseExp * pow(1.1,level);
            level++
            //println("require exp for lv:\(level) = \(requiredExp)");
        }
        return Int(level)
    }
    class func getValue(key:String)->AnyObject?
    {
        return NSUserDefaults.standardUserDefaults().objectForKey(key)
    }
    class func setValue(key:String,value:AnyObject)
    {
        NSUserDefaults.standardUserDefaults().setObject(value, forKey: key)
    }
}
