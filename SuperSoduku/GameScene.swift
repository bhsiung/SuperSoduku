//
//  GameScene.swift
//  SuperSoduku
//
//  Created by BIINGYANN HSIUNG on 12/20/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

import SpriteKit



class GameScene: SKScene,GameSceneDelegation
{
    class var systemFont:String {
        return "Futura-Medium"
    }

    let exitButtonFont = "GillSans-Bold";
    var difficulty:GameDifficulty = GameDifficulty.easy
    var gameControllerDelegation: GameControllerDelegation?
    var gridCellController:GridCellController?
    override func didMoveToView(view: SKView) {
        makeGrid()
        makeNumberButtons()
        if(difficulty.dimension >= 2){
            makeColorButtons()
        }
        makeUtil()
        self.backgroundColor = SKColor(red: 0.90, green: 0.90, blue: 0.85, alpha: 1)
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch:UITouch = touches.anyObject() as UITouch;
        let location = touch.locationInNode(self);
        let touchedNode = nodeAtPoint(location)
        if touchedNode is SKLabelNode{
            if let button:SKLabelNode = touchedNode as? SKLabelNode{
                if let buttonName:String = button.name {
                    if(buttonName == "exit-button"){
                        self.gameControllerDelegation?.quitFromGame()
                    }
                }
            }
        }
    }
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    func makeUtil()
    {
        var exitButtonNode = SKLabelNode(fontNamed: exitButtonFont)
        exitButtonNode.text = "quit"
        exitButtonNode.fontSize = 18
        let y:CGFloat = 80;
        let x:CGFloat = 270;
        exitButtonNode.position = CGPointMake(x, -1*(self.frame.height-y))
        exitButtonNode.fontColor = SKColor.blackColor()
        exitButtonNode.name = "exit-button"
        self.addChild(exitButtonNode)
    }
    func makeGrid()
    {
        let offsetX:Float = 10, offsetY:Float = -10;
        self.gridCellController = GridCellController(width: 300, numberOfRow: 9, scene: self,x: offsetX,y: offsetY,d: self.difficulty);
    }
    func makeNumberButtons()
    {
        let xoffset = 10.0;
        let yoffset = -350.0;
        let p = 5.0;
        let numberOfColumnPerRow = 3.0
        
        var numberButtonLabel = SKLabelNode(fontNamed: GameScene.systemFont)
        numberButtonLabel.text = "Number"
        numberButtonLabel.fontSize = 16
        numberButtonLabel.position = CGPointMake(CGFloat(xoffset), CGFloat(yoffset+16))
        numberButtonLabel.fontColor = SKColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        numberButtonLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        addChild(numberButtonLabel)
        
        for(var i=1; i<10; i++){
            let _i = Double(i);
            var numberButton = NumberButton(buttonIndex: i);
            numberButton.gridCellControllerDelegation = gridCellController
            var w = Double(numberButton.width)
            var newY = CGFloat(yoffset - (w+p)*floor((_i-1.0)/numberOfColumnPerRow))
            numberButton.position = CGPointMake(CGFloat(xoffset+((_i-1)%numberOfColumnPerRow)*(w+p)), newY);
            self.addChild(numberButton)
        }
    }
    func makeColorButtons()
    {
        let xoffset = 120.0;
        let yoffset = -350.0;
        let p = 5.0;
        let numberOfColumnPerRow = 3.0
        
        var numberButtonLabel = SKLabelNode(fontNamed: GameScene.systemFont)
        numberButtonLabel.text = "Color"
        numberButtonLabel.fontSize = 16
        numberButtonLabel.position = CGPointMake(CGFloat(xoffset), CGFloat(yoffset+16))
        numberButtonLabel.fontColor = SKColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        numberButtonLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        addChild(numberButtonLabel)
        
        for(var i=1; i<10; i++){
            let _i = Double(i);
            var numberButton = ColorButton(index: i)
            numberButton.gridCellControllerDelegation = gridCellController
            var w = Double(numberButton.width)
            var newY = CGFloat(yoffset - (w+p)*floor((_i-1.0)/numberOfColumnPerRow))
            numberButton.position = CGPointMake(CGFloat(xoffset+((_i-1)%numberOfColumnPerRow)*(w+p)), newY);
            self.addChild(numberButton)
        }
    }
    func userSetNumber(i: Int) {
        self.gridCellController?.setNumber(i)
    }
    func complete() {
        CompleteEffect.complete(self,score:1234)
        UserProfile.exp += difficulty.expGain
    }
}
class CompleteEffect: SKNode
{
    var score: Int
    let gameScene:GameScene
    let label:SKLabelNode
    let background: SKShapeNode
    let overlay: SKShapeNode
    let exitButtonNode: SKLabelNode
    let titleFont = "AvenirNextCondensed-HeavyItalic"
    let utilFont = "GillSans-Bold"
    let overlayColor = SKColor(red: 0.8, green: 0.36, blue: 0.36, alpha: 1);
    
    class func complete(scene:GameScene,score:Int)
    {
        let node = CompleteEffect(score: score,scene: scene);
        scene.addChild(node)
        node.zPosition = 2;

        node.play()
    }
    init(score:Int,scene:GameScene)
    {
        self.score = score
        self.gameScene = scene
        
        label = SKLabelNode(fontNamed: titleFont)
        background = SKShapeNode(rect: CGRectMake(0, 0, self.gameScene.frame.width, self.gameScene.frame.height));
        overlay = SKShapeNode(rect: CGRectMake(0, 0, self.gameScene.frame.width, 100));
        exitButtonNode = SKLabelNode(fontNamed: utilFont)

        super.init()
        createTitle()
        createBackground()
        createOverlay()
        createUtil()

        self.addChild(background)
        self.addChild(overlay)
        self.addChild(label)

    }
    func createUtil()
    {
        let padding:CGFloat = 10
        exitButtonNode.text = "quit"
        exitButtonNode.fontSize = 15
        exitButtonNode.fontColor = SKColor.whiteColor()
        exitButtonNode.position = CGPointMake(
            overlay.position.x + overlay.frame.width - padding,
            overlay.position.y + padding
        )
        exitButtonNode.zPosition = 2
        exitButtonNode.alpha = 0
        exitButtonNode.name = "exit-button"
        exitButtonNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        exitButtonNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        self.addChild(exitButtonNode)
    }
    func createOverlay()
    {
        overlay.fillColor = overlayColor
        overlay.strokeColor = SKColor.clearColor()
        overlay.position = CGPointMake(0, -1 * ((gameScene.frame.height + overlay.frame.height) / 2))
        overlay.alpha = 0
    }
    func createBackground()
    {
        background.fillColor = SKColor(red: 0, green: 0, blue: 0, alpha: 0.4);
        background.strokeColor = SKColor.clearColor()
        background.position = CGPointMake(0, -1 * background.frame.height)
        background.alpha = 0

    }
    func createTitle()
    {
        label.fontColor = SKColor.whiteColor()
        label.text = "Congratulations!!";
        label.fontSize = 20;
        label.alpha = 0
        label.position = CGPointMake(CGFloat(gameScene.frame.width/2), CGFloat(-1*self.gameScene.frame.height/2));
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
    }
    func play()
    {
        background.runAction(SKAction.fadeAlphaTo(1.0, duration: 0.3), completion: {
            self.overlay.runAction(SKAction.fadeAlphaTo(1.0, duration: 0.3))
            self.label.runAction(SKAction.fadeAlphaTo(1.0, duration: 0.3),completion:{
                self.exitButtonNode.runAction(SKAction.fadeAlphaTo(1, duration: 0.6))
            })
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class NumberButton: SKNode
{
    var i:Int
    let bgNode:SKShapeNode
    let numberNode:SKLabelNode
    let width = 30.0
    let fontSize:CGFloat = 18
    var gridCellControllerDelegation:GridCellDelegation?
    init(buttonIndex:Int)
    {
        self.bgNode = SKShapeNode(path: CGPathCreateWithRoundedRect(
            CGRectMake(0, 0, CGFloat(width), CGFloat(width)), 4, 4, nil));
        self.bgNode.strokeColor = SKColor.clearColor()
        self.bgNode.fillColor = SKColor.whiteColor()
        self.bgNode.position = CGPointMake(0, CGFloat(-1.0 * width));
        
        self.numberNode = SKLabelNode(fontNamed: GameScene.systemFont);
        self.numberNode.fontSize = fontSize;
        self.numberNode.fontColor = SKColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        
        self.numberNode.position = CGPointMake(CGFloat(width/2), CGFloat(-1*width/2));
        self.numberNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        self.numberNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        self.numberNode.text = NSString(format: "%d", buttonIndex)
        self.i = buttonIndex
        
        super.init();
        self.userInteractionEnabled = true;
        self.addChild(bgNode)
        self.addChild(numberNode)
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.gridCellControllerDelegation?.setNumber(self.i,isAnnotation: false)
        bgNode.runAction(SKAction.fadeAlphaTo(0.2, duration: 0.3),withKey:"touchDown")
    }
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        bgNode.removeActionForKey("touchDown")
        bgNode.runAction(SKAction.fadeAlphaTo(1, duration: 0.1))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class ColorButton:SKNode
{
    var color:GridCellColor
    let bgNode:SKShapeNode
    let width = 30.0
    var gridCellControllerDelegation:GridCellDelegation?
    init(index:Int)
    {
        color = GridCellColor(rawValue: index)!
        self.bgNode = SKShapeNode(path: CGPathCreateWithRoundedRect(
            CGRectMake(0, 0, CGFloat(width), CGFloat(width)), 4, 4, nil));
        self.bgNode.strokeColor = SKColor.clearColor()
        self.bgNode.fillColor = color.color
        self.bgNode.position = CGPointMake(0, CGFloat(-1.0 * width));
        
        super.init();
        self.userInteractionEnabled = true;
        self.addChild(bgNode)
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.gridCellControllerDelegation?.setColor(color,isAnnotation:false)
        bgNode.runAction(SKAction.fadeAlphaTo(0.2, duration: 0.3),withKey:"touchDown")
    }
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        bgNode.removeActionForKey("touchDown")
        bgNode.runAction(SKAction.fadeAlphaTo(1, duration: 0.1))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
