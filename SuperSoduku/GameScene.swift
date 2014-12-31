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
    var number:Int?{
        didSet{
            self.numberNode.text = String(format: "%d", number!);
        }
    }
    init(x:Int,y:Int,width:Float)
    {
        self.bgNode = SKShapeNode(rect: CGRectMake(0, 0, CGFloat(width), CGFloat(width)))
        self.bgNode.fillColor = SKColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        self.bgNode.position = CGPointMake(0, CGFloat(-1.0 * width));
        
        self.numberNode = SKLabelNode(fontNamed: "Chalkduster");
        self.numberNode.fontSize = 16;
        self.numberNode.fontColor = SKColor.blackColor();
        self.numberNode.position = CGPointMake(CGFloat(width/2), CGFloat(-1*width/2));
        self.numberNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        self.numberNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        
        self.x = x
        self.y = y
        self.width = width
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
        //todo
    }
    func stopFlashing()
    {
        //todo
    }
    func error()
    {
        //todo
    }
    func unerror()
    {
        //todo
    }
}
class GridCellController:GridCellDelegation{
    let width:Int, numberOfRow: Int, scene: SKScene
    var cells:[[GridCell]];
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
        for _x in 0...numberOfRow-1 {
            self.cells.append(Array(count: numberOfRow, repeatedValue: GridCell(x:0,y:0,width:cellWidth)));
            for _y in 0...numberOfRow-1{
                var gridCell:GridCell = GridCell(x: _x, y: _y, width: cellWidth);
                gridCell.controllerDelegate = self;
                var xMovement = Float(_x)*cellWidth;
                var yMovement = Float(_y)*cellWidth;
                gridCell.position = CGPointMake(CGFloat(x+xMovement), CGFloat(y-yMovement));
                //gridCell.number = _x+1+_y*numberOfRow;
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
        // todo
        return false;
    }
    func completeValidate() ->Bool
    {
        //todo
        return false
    }
    func validate(pos:Pos)->Bool{
        //todo
        return true;
    }
    func assignCellNumbers()
    {
        //todo
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