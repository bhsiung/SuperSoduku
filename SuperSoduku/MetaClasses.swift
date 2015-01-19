//
//  MetaClasses.swift
//  SuperSoduku
//
//  Created by BIINGYANN HSIUNG on 1/12/15.
//  Copyright (c) 2015 BIINGYANN HSIUNG. All rights reserved.
//

import Foundation
import SpriteKit
import iAd

struct Pos {
    var x:Int,y:Int
    init(x:Int,y:Int)
    {
        self.x = x;
        self.y = y;
    }
}
extension Array {
    mutating func shuffle() {
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swap(&self[i], &self[j])
        }
    }
}
extension UIViewController
{
    func addBanner()
    {
        var adView:ADBannerView = ADBannerView(frame:CGRectMake(0, view.frame.size.height-50, 320, 50));
        self.view.addSubview(adView)
    }
}
protocol DifficultyControllerDelegation{
    func difficultySelected(d:GameDifficulty)
}

protocol GameControllerDelegation{
    func quitFromGame()
}

protocol GridCellDelegation{
    func moveCursor(pos:Pos)
    func setNumber(number:Int,isAnnotation:Bool)
    func setColor(GridCellColor,isAnnotation:Bool)
    func clearNumber()
    func clearColor()
}
protocol GameSceneDelegation{
    func complete()
}
enum GridCellColor:Int{
    case clear = 0,red,orange,yellow,green,blue,purple,gray,cyan,brown
    
    var color:SKColor{
        switch self{
        case clear:
            return SKColor.clearColor()
        case red:
            return SKColor(red: 0.988, green: 0.533, blue: 0.415, alpha: 1)
        case orange:
            return SKColor(red: 0.996, green: 0.796,blue: 0.573, alpha: 1)
        case .yellow:
            return SKColor(red: 1.0, green: 0.968,blue: 0.49, alpha: 1)
        case green:
            return SKColor(red: 0.675, green: 0.765,blue: 0.420, alpha: 1)
        case blue:
            return SKColor(red: 0.525, green: 0.714,blue: 0.792, alpha: 1)
        case .purple:
            return SKColor(red: 0.796, green: 0.564,blue: 0.878, alpha: 1)
        case .gray:
            return SKColor(red: 0.773, green: 0.773,blue: 0.745, alpha: 1)
        case cyan:
            return SKColor(red: 0.125, green: 0.753,blue: 0.745, alpha: 1)
        case .brown:
            return SKColor(red: 0.761, green: 0.702,blue: 0.533, alpha: 1)
        }
    }
    func toInt()->Int
    {
        switch self{
        case clear:
            return 0
        case red:
            return 1
        case orange:
            return 2
        case yellow:
            return 3
        case green:
            return 4
        case blue:
            return 5
        case purple:
            return 6
        case gray:
            return 7
        case cyan:
            return 8
        case brown:
            return 9
        default:
            return 0
        }
    }
}
enum GameDifficulty:Int{
    case easy = 1,normal,hard,expert,insane,nightmare
    static let allValues = [easy,normal,hard,expert,insane,nightmare]
    var text: String{
        switch self{
        case easy:
            return "Easy";
        case normal:
            return "Normal";
        case hard:
            return "Hard";
        case expert:
            return "Expert";
        case insane:
            return "Insane";
        case nightmare:
            return "Nightmare";
        }
    }
    var dimension: Int{
        switch self{
        case easy,normal,hard:
            return 1;
        case expert,insane,nightmare:
            return 2;
        }
    }
    
    var cellShouldBeFixed: Bool{
        let diceRoll = Int(arc4random_uniform(100))
        switch self{
        case easy:
            return diceRoll > 10;
        case normal:
            return diceRoll > 50;
        case hard:
            return diceRoll > 70;
        case expert:
            return diceRoll > 10;
        case insane:
            return diceRoll > 50
        case nightmare:
            return diceRoll > 70;
        }
    }
    var expGain: Int{
        switch self{
        case easy:
            return 25;
        case normal:
            return 40;
        case hard:
            return 70;
        case expert:
            return 120;
        case insane:
            return 200;
        case nightmare:
            return 350;
        }
    }
    var isUnlocked: Bool{
        switch self{
        case easy:
            return UserProfile.lv >= 0;
        case normal:
            return UserProfile.lv > 2;
        case hard:
            return UserProfile.lv > 4;
        case expert:
            return UserProfile.lv > 6;
        case insane:
            return UserProfile.lv > 8;
        case nightmare:
            return UserProfile.lv > 10;
        }
    }
}
class ButtonOverlay:SKNode
{
    let body:SKLabelNode
    let container: SKShapeNode
    var initialPosition:(x:CGFloat,y:CGFloat) = (0,0);
    init(bodyText:String,width:CGFloat,height:CGFloat)
    {
        container = SKShapeNode(path: CGPathCreateWithRoundedRect(
            CGRectMake(-1 * width/2, -1 * height/2, CGFloat(width), CGFloat(height)), 4, 4, nil));
        body = SKLabelNode(fontNamed: "Avenir-Light")
        super.init()
                name = "buttonOverlay"
        drawContainer()
        if(bodyText != ""){
            drawBodyTextLabelNode(bodyText)
        }
        reset()
    }
    func drawBodyTextLabelNode(text:String)
    {
        body.text = text
        body.fontSize = 11
        body.fontColor = SKColor.whiteColor()
        body.position = CGPointMake(0, 0)
        body.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        body.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        addChild(body)
    }
    func drawContainer()
    {
        container.strokeColor = SKColor.clearColor()
        container.fillColor = SKColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 1)
        container.name = self.name
        addChild(container)
    }
    func play()
    {
        self.zPosition = 8
        self.removeActionForKey("play")
        runAction(SKAction.group([
            SKAction.moveBy(CGVectorMake(0, container.frame.height), duration: 0.1),
            SKAction.fadeAlphaTo(1, duration: 0.2)]), withKey: "play")
    }
    func reset()
    {
        self.position.y = self.initialPosition.y;
        self.zPosition = -1
        alpha = 0
    }
    func stop()
    {
        self.removeActionForKey("play")
        self.runAction(SKAction.fadeOutWithDuration(0.4), completion: reset)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class HintButton:SKNode
{
    var overlay:ButtonOverlay?
    var overlayEnabled = false
    let borderNode:SKShapeNode
    let radius:CGFloat = 4
    
    init(height:CGFloat,width:CGFloat)
    {
        
        borderNode = SKShapeNode(path: CGPathCreateWithRoundedRect(CGRectMake(-1*width/2, -1*height/2, width, height), radius, radius, nil))
        borderNode.strokeColor = SKColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        borderNode.fillColor = SKColor.clearColor()
        borderNode.name = "borderNode"
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func enableOverlay(titleText:String, bodyText:String,width:CGFloat,height:CGFloat)
    {
        overlayEnabled = true
        overlay = ButtonOverlay(bodyText: bodyText,width:width,height:height)
        addChild(overlay!)
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        if(!overlayEnabled){
            return
        }
        let touch:UITouch = touches.anyObject() as UITouch;
        let location = touch.locationInNode(self);
        for touchedObject in nodesAtPoint(location){
            if var touchedNode:SKNode = touchedObject as? SKNode{
                if(touchedNode.name == "borderNode"){
                    overlay!.play()
                    return
                }
            }
        }
    }
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent)
    {
        if(overlayEnabled){
            overlay!.stop()
        }
    }
}