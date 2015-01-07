//
//  GameScene.swift
//  SuperSoduku
//
//  Created by BIINGYANN HSIUNG on 12/20/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

import SpriteKit

protocol GridCellDelegation{
    func moveCursor(pos:Pos)
    func setNumber(number:Int)
    func setAnnotation(number:Int)
}
protocol GameSceneDelegation{
    func complete()
}
enum GameDifficulty:Int{
    case easy = 1,intermedia,hard,insane,nightmare
    static let allValues = [easy,intermedia,hard,insane,nightmare]
    var text: String{
        switch self{
        case easy:
            return "Easy";
        case intermedia:
            return "Medium";
        case hard:
            return "Hard";
        case insane:
            return "Insane";
        case nightmare:
            return "Nightmare";
        }
    }
    var cellShouldBeFixed: Bool{
        let diceRoll = Int(arc4random_uniform(100))
        switch self{
        case easy:
            return diceRoll > 5;
        case intermedia:
            return diceRoll > 30;
        case hard:
            return diceRoll > 50;
        case insane:
            return diceRoll > 70;
        case nightmare:
            return diceRoll > 90;
        }
    }
}
class GridCell:SKNode
{
    var controllerDelegate:GridCellDelegation?
    let numberNode:SKLabelNode,bgNode:SKShapeNode
    let x:Int,y:Int,width:Float
    let fontSize:CGFloat = 13
    var annotationLabels:[SKLabelNode]
    
    let errorFontColor:SKColor = SKColor.redColor()
    let normalFontColor:SKColor = SKColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1)
    let definedFontColor:SKColor = SKColor(red: 0.20, green: 0.65, blue: 0.23, alpha: 1)
    let isFixed:Bool
    
    var number:Int?{
        didSet{
            self.numberNode.text = String(format: "%d", number!);
        }
    }
    init(x:Int,y:Int,width:Float,isFixed:Bool,backgroundColor: SKColor)
    {
        self.bgNode = SKShapeNode(rect: CGRectMake(0, 0, CGFloat(width), CGFloat(width)))
        self.bgNode.fillColor = backgroundColor
        self.bgNode.strokeColor = SKColor.clearColor()
        self.bgNode.position = CGPointMake(0, CGFloat(-1.0 * width));
        
        self.numberNode = SKLabelNode(fontNamed: GameScene.systemFont);
        self.numberNode.fontSize = fontSize;
        if(isFixed){
            self.numberNode.fontColor = definedFontColor;
        }else{
            self.numberNode.fontColor = normalFontColor;
        }
        self.numberNode.position = CGPointMake(CGFloat(width/2), CGFloat(-1*width/2));
        self.numberNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        self.numberNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        self.numberNode.text = ""
        self.annotationLabels = Array<SKLabelNode>()
        
        self.x = x
        self.y = y
        self.width = width
        self.isFixed = isFixed
        super.init();
        makeAnnotation()
        
        self.userInteractionEnabled = true;
        self.addChild(bgNode)
        self.addChild(numberNode)
    }
    func makeAnnotation()
    {
        self.annotationLabels = Array(count: 9, repeatedValue: SKLabelNode())
        for i in 0...8{
            annotationLabels[i] = SKLabelNode(fontNamed: GameScene.systemFont);
            annotationLabels[i].fontSize = 6;
            annotationLabels[i].fontColor = definedFontColor;
            annotationLabels[i].position = CGPointMake(CGFloat(width/2), CGFloat(-1*width/2));
            annotationLabels[i].text = "\(i+1)"
            //self.addChild(annotationLabels[i])
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if(!self.isFixed){
            self.controllerDelegate?.moveCursor(Pos(x:self.x,y:self.y));
        }
    }
    func startFlashing()
    {
        self.stopFlashing()
        self.runAction(SKAction.repeatActionForever(SKAction.sequence(
            [SKAction.fadeAlphaTo(0.5, duration: 0.5),SKAction.fadeAlphaTo(1, duration: 0.2)]
            )), withKey: "flash")
    }
    func stopFlashing()
    {
        removeActionForKey("flash");
        self.alpha = 1
    }
    func error()
    {
        if(!self.isFixed){
            self.numberNode.fontColor = errorFontColor;
        }
    }
    func unerror()
    {
        if(!self.isFixed){
            self.numberNode.fontColor = normalFontColor;
        }
    }
}



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
        makeAnnotationNumberButtons()
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
        /*
        if touchedNode is SKSpriteNode{
            if let button:NumberButton = touchedNode as? NumberButton{
                if let buttonName:String = button.name {
                    if(buttonName == "number-button"){
                        self.gridCellController?.setNumber(button.i)
                    }
                }
            }
        }
        */
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
        /*
        let grid = SKSpriteNode(imageNamed: "grid_big")
        grid.position = CGPointMake(CGFloat(offsetX),CGFloat(offsetY))
        grid.anchorPoint = CGPoint(x:0,y:1);
        grid.size = CGSizeMake(300, 300)
        self.addChild(grid);
        */
        self.gridCellController = GridCellController(width: 300, numberOfRow: 9, scene: self,x: offsetX,y: offsetY,d: self.difficulty);
    }
    func makeNumberButtons()
    {
        let xoffset = 10.0;
        let yoffset = -320.0;
        let p = 5.0;
        let numberOfColumnPerRow = 3.0
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
    func makeAnnotationNumberButtons()
    {
        let xoffset = 120.0;
        let yoffset = -320.0;
        let p = 5.0;
        let numberOfColumnPerRow = 3.0
        for(var i=1; i<10; i++){
            let _i = Double(i);
            var numberButton = AnnotationNumberButton(buttonIndex: i);
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
        label.text = "Congratulations!!\nScore:\(score)";
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
        self.bgNode = SKShapeNode(rect: CGRectMake(0, 0, CGFloat(width), CGFloat(width)))
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
        self.gridCellControllerDelegation?.setNumber(self.i)
        bgNode.runAction(SKAction.fadeAlphaTo(0.6, duration: 0.3))
    }
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        bgNode.runAction(SKAction.fadeAlphaTo(1, duration: 0.1))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class AnnotationNumberButton:NumberButton
{
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.gridCellControllerDelegation?.setAnnotation(self.i)
        bgNode.runAction(SKAction.fadeAlphaTo(0.6, duration: 0.3))
    }
}
class GridCellController:GridCellDelegation
{
    let width:Int, numberOfRow: Int, scene: SKScene
    var cells:[[GridCell]];
    var gameSceneDelegation:GameSceneDelegation
    let difficulty:GameDifficulty
    
    var currentPos:Pos{
        willSet{
            println("\(self.currentPos.x),\(newValue.x)")
            cells[self.currentPos.x][self.currentPos.y].stopFlashing()
            cells[newValue.x][newValue.y].startFlashing()
        }
    }
    
    init(width:Int,numberOfRow:Int,scene:GameScene,x:Float,y:Float,d:GameDifficulty)
    {
        self.width = width
        self.numberOfRow = numberOfRow
        self.scene = scene
        self.currentPos = Pos(x: 0,y: 0)
        var cellWidth:Float = Float(width/numberOfRow);
        self.cells = Array<Array<GridCell>>()
        self.difficulty = d
        self.gameSceneDelegation = scene
        var padding:Float = 1
        let xOffset = x+padding
        let yOffset = y+padding
        var cellBackgroundColor:SKColor
        for _x in 0...numberOfRow-1 {
            self.cells.append(Array(count: numberOfRow, repeatedValue: GridCell(x:0,y:0,width:cellWidth,isFixed: true,backgroundColor: SKColor.whiteColor())));
            for _y in 0...numberOfRow-1{
                if(cellGourpNumberFromPosition(_x,y:_y) % 2 == 0){
                    cellBackgroundColor = SKColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
                }else{
                    cellBackgroundColor = SKColor.whiteColor()
                }
                var gridCell:GridCell = GridCell(
                    x: _x, y: _y, width: cellWidth - padding,
                    isFixed: self.difficulty.cellShouldBeFixed,backgroundColor:cellBackgroundColor);
                gridCell.controllerDelegate = self;
                var xMovement = Float(_x)*cellWidth;
                var yMovement = Float(_y)*cellWidth;
                gridCell.position = CGPointMake(CGFloat(xOffset+xMovement), CGFloat(yOffset-yMovement));
                scene.addChild(gridCell)
                self.cells[_x][_y] = gridCell;
            }
        }
        self.assignCellNumbers();
    }
    func cellGourpNumberFromPosition(x:Int,y:Int)->Int
    {
        var w = sqrtf(Float(numberOfRow))
        var i = floor(Float(x)/w)
        i += w*floor(Float(y)/w)
        return Int(i)
    }
    func setNumber(number:Int)
    {
        let currentCell:GridCell = self.cells[self.currentPos.x][self.currentPos.y];
        currentCell.number = number;
        if(self.isBoardComplete()){
            if(self.completeValidate()){
                return self.gameSceneDelegation.complete()
            }
        }
        if(self.validate(self.currentPos)){
            currentCell.unerror();
        }else{
            currentCell.error();
        }
    }
    func setAnnotation(number: Int) {
        println("\(number)")
    }
    func isBoardComplete() ->Bool
    {
        for x in 0...numberOfRow-1 {
            for y in 0...numberOfRow-1{
                if(cells[x][y].number == nil){
                    return false
                }
            }
        }
        return true;
    }
    func completeValidate() ->Bool
    {
        for x in 0 ... numberOfRow-1{
            for y in 0 ... numberOfRow-1{
                if(!validate(Pos(x: x,y:y))){
                    return false;
                }
            }
        }
        return true;
    }
    func validate(pos:Pos)->Bool
    {
        cells[pos.x][pos.y].error()
        if(!validateRow(pos.x,y:pos.y)){
            return false
        }
        if(!validateCol(pos.x,y:pos.y)){
            return false
        }
        if(!validateGroup(pos.x,y:pos.y)){
            return false
        }
        cells[pos.x][pos.y].unerror()
        return true;
    }
    func validateRow(x:Int,y:Int)->Bool
    {
        for _x in 0 ... numberOfRow-1{
            if(_x != x && cells[x][y].number == cells[_x][y].number){
                return false
            }
        }
        return true;
    }
    func validateCol(x:Int,y:Int)->Bool
    {
        for _y in 0 ... numberOfRow-1{
            if(_y != y && cells[x][y].number == cells[x][_y].number){
                return false
            }
        }
        return true;
    }
    func validateGroup(x:Int,y:Int)->Bool
    {
        let groupSize = sqrtf(Float(numberOfRow))
        let xStart = Int(floorf(Float(x)/groupSize)*groupSize);
        let xEnd = xStart+Int(groupSize)-1
        let yStart = Int(floorf(Float(y)/groupSize)*groupSize);
        let yEnd = yStart+Int(groupSize)-1
        //println("(\(xStart)...\(xEnd)),(\(yStart)...\(yEnd)) pos:(\(x),\(y)), num: \(cells[x][y].number)")
        for(var _x=xStart; _x<=xEnd; _x++){
            for(var _y=yStart; _y<=yEnd; _y++){
                if(_y != y && _x != x && cells[x][y].number == cells[_x][_y].number){
                    return false
                }
            }
        }
        return true;
    }
    func assignCellNumbers()
    {
        var sample:[[Int]] = [
            [8,1,2,9,7,4,3,6,5],
            [9,3,4,6,5,1,7,8,2],
            [7,6,5,8,2,3,9,4,1],
            [5,7,1,4,8,2,6,9,3],
            [2,8,9,3,6,5,4,1,7],
            [6,4,3,7,1,9,2,5,8],
            [1,9,6,5,3,7,8,2,4],
            [3,2,8,1,4,6,5,7,9],
            [4,5,7,2,9,8,1,3,6]];
        var shuffleMapping:Array<Int> = [1,2,3,4,5,6,7,8,9]
        shuffleMapping.shuffle()
        
        for x in 0 ... numberOfRow-1{
            for y in 0 ... numberOfRow-1{
                if(cells[x][y].isFixed){
                    cells[x][y].number = shuffleMapping[sample[x][y]-1];
                }
            }
        }
    }
    func moveCursor(pos:Pos)
    {
        self.currentPos = pos;
    }
}

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