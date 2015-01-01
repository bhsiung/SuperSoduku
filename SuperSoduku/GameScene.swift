//
//  GameScene.swift
//  SuperSoduku
//
//  Created by BIINGYANN HSIUNG on 12/20/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

import SpriteKit

class GameScene: SKScene
{
    var gridCellController:GridCellController?
    override func didMoveToView(view: SKView) {
        makeGrid()
        makeNumberButtons()
        self.backgroundColor = SKColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch:UITouch = touches.anyObject() as UITouch;
        let location = touch.locationInNode(self);
        let touchedNode = nodeAtPoint(location)
        println("\(touchedNode)")
        if touchedNode is SKSpriteNode{
            if let button:NumberButton = touchedNode as? NumberButton{
                if let buttonName:String = button.name {
                    if(buttonName == "number-button"){
                        self.gridCellController?.setNumber(button.i)
                    }
                }
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    func makeGrid()
    {
        let offsetX:Float = 10, offsetY:Float = -10;
        let grid = SKSpriteNode(imageNamed: "grid_big.png")
        grid.position = CGPointMake(CGFloat(offsetX),CGFloat(offsetY))
        grid.anchorPoint = CGPoint(x:0,y:1);
        grid.size = CGSizeMake(300, 300)
        self.addChild(grid);
        self.gridCellController = GridCellController(width: 300, numberOfRow: 9, scene: self,x: offsetX,y: offsetY);
    }
    func makeNumberButtons()
    {
        let xoffset = 5.0;
        let yoffset = -350.0;
        let w = 25.0;
        let h = 25.0;
        let p = 5.0;
        for(var i=1; i<10; i++){
            let _i = Double(i);
            var numberButton = NumberButton(buttonIndex: i);
            numberButton.position = CGPointMake(CGFloat(xoffset+_i*(w+p)), CGFloat(yoffset));
            numberButton.size = CGSizeMake(CGFloat(w), CGFloat(h))
            self.addChild(numberButton)
        }
    }
}
class NumberButton: SKSpriteNode
{
    var i:Int
    init(buttonIndex:Int)
    {
        let texture = SKTexture(imageNamed: "number_button_\(buttonIndex).png");
        self.i = buttonIndex
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.name = "number-button"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
protocol GridCellDelegation{
    func moveCursor(pos:Pos)
}
class GridCell:SKNode
{
    var controllerDelegate:GridCellDelegation?
    let numberNode:SKLabelNode,bgNode:SKShapeNode
    let x:Int,y:Int,width:Float
    
    let errorFontColor:SKColor = SKColor.redColor()
    let normalFontColor:SKColor = SKColor.greenColor()
    let definedFontColor:SKColor = SKColor.blackColor()
    let isFixed:Bool
    
    var number:Int?{
        didSet{
            self.numberNode.text = String(format: "%d", number!);
        }
    }
    init(x:Int,y:Int,width:Float,isFixed:Bool)
    {
        self.bgNode = SKShapeNode(rect: CGRectMake(0, 0, CGFloat(width), CGFloat(width)))
        self.bgNode.fillColor = SKColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        self.bgNode.position = CGPointMake(0, CGFloat(-1.0 * width));
        
        self.numberNode = SKLabelNode(fontNamed: "Chalkduster");
        self.numberNode.fontSize = 16;
        if(isFixed){
            self.numberNode.fontColor = definedFontColor;
        }else{
            self.numberNode.fontColor = normalFontColor;
        }
        self.numberNode.position = CGPointMake(CGFloat(width/2), CGFloat(-1*width/2));
        self.numberNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        self.numberNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        
        self.x = x
        self.y = y
        self.width = width
        self.isFixed = isFixed
        super.init();
        self.userInteractionEnabled = true;
        self.addChild(bgNode)
        self.addChild(numberNode)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.controllerDelegate?.moveCursor(Pos(x:self.x,y:self.y));
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
        self.numberNode.fontColor = SKColor.redColor();
    }
    func unerror()
    {
        self.numberNode.fontColor = SKColor.blackColor();
    }
}
enum GameDifficulty:Int{
    case easy = 1,intermedia,hard,insane,nightmare
    var cellShouldBeFixed: Bool{
        let diceRoll = Int(arc4random_uniform(100))
        switch self{
            case easy:
                return diceRoll > 20;
            case intermedia:
                return diceRoll > 50;
            case hard:
                return diceRoll > 70;
            case insane:
                return diceRoll > 90;
            case nightmare:
                return diceRoll > 95;
        }
    }
}
class GridCellController:GridCellDelegation
{
    let width:Int, numberOfRow: Int, scene: SKScene
    var cells:[[GridCell]];
    let difficulty:GameDifficulty
    
    var currentPos:Pos{
        willSet{
            println("\(self.currentPos.x),\(newValue.x)")
            cells[self.currentPos.x][self.currentPos.y].stopFlashing()
            cells[newValue.x][newValue.y].startFlashing()
        }
    }
    
    init(width:Int,numberOfRow:Int,scene:SKScene,x:Float,y:Float)
    {
        self.width = width
        self.numberOfRow = numberOfRow
        self.scene = scene
        self.currentPos = Pos(x: 0,y: 0)
        var cellWidth:Float = Float(width/numberOfRow);
        self.cells = Array<Array<GridCell>>()
        self.difficulty = GameDifficulty.nightmare // todo
        
        for _x in 0...numberOfRow-1 {
            self.cells.append(Array(count: numberOfRow, repeatedValue: GridCell(x:0,y:0,width:cellWidth,isFixed: true)));
            for _y in 0...numberOfRow-1{
                var gridCell:GridCell = GridCell(x: _x, y: _y, width: cellWidth, isFixed: self.difficulty.cellShouldBeFixed);
                gridCell.controllerDelegate = self;
                var xMovement = Float(_x)*cellWidth;
                var yMovement = Float(_y)*cellWidth;
                gridCell.position = CGPointMake(CGFloat(x+xMovement), CGFloat(y-yMovement));
                scene.addChild(gridCell)
                self.cells[_x][_y] = gridCell;
            }
        }
        self.assignCellNumbers();
    }
    func setNumber(number:Int)
    {
        let currentCell:GridCell = self.cells[self.currentPos.x][self.currentPos.y];
        currentCell.number = number;
        if(self.isBoardComplete()){
            if(self.completeValidate()){
                return self.congretz()
            }
        }
        if(self.validate(self.currentPos)){
            currentCell.unerror();
        }else{
            currentCell.error();
        }
    }
    func congretz()
    {
        //todo
        println("yaya!!")
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