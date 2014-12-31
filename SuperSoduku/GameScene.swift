//
//  GameScene.swift
//  SuperSoduku
//
//  Created by BIINGYANN HSIUNG on 12/20/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        
        makeGrid()
        makeNumberButtons()
        self.backgroundColor = SKColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch:UITouch = touches.anyObject() as UITouch;
        let location = touch.locationInNode(self);
        let touchedNode = nodeAtPoint(location)
        if touchedNode is SKSpriteNode{
            let button:NumberButton = touchedNode as NumberButton;
            if let buttonName:String = button.name {
                if(buttonName == "number-button"){
                    println("\(button.i)")
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
        
        var gridCellController:GridCellController = GridCellController(width: 300, numberOfRow: 9, scene: self,x: offsetX,y: offsetY);
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
class GridCell:SKNode
{
    let numberNode:SKLabelNode,bgNode:SKShapeNode
    let x:Int,y:Int,width:Float
    var number:Int?{
        didSet{
            self.numberNode.text = String(format: "%d", number!);
        }
    }
    init(x:Int,y:Int,width:Float){

        self.bgNode = SKShapeNode(rect: CGRectMake(0, 0, CGFloat(width), CGFloat(width)))
        self.bgNode.fillColor = SKColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        self.bgNode.position = CGPointMake(0, 0);
        
        self.numberNode = SKLabelNode(fontNamed: "Chalkduster");
        self.numberNode.fontSize = 16;
        self.numberNode.fontColor = SKColor.blackColor();
        self.x = x
        self.y = y
        self.width = width
        super.init();
        self.addChild(bgNode)
        self.addChild(numberNode)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class GridCellController{
    let width:Int, numberOfRow: Int, scene: SKScene
    init(width:Int,numberOfRow:Int,scene:SKScene,x:Float,y:Float)
    {
        self.width = width
        self.numberOfRow = numberOfRow
        self.scene = scene
        var cellWidth:Float = Float(width/numberOfRow);
        for _x in 0...numberOfRow-1 {
            for _y in 0...numberOfRow-1{
                var gridCell:GridCell = GridCell(x: _x, y: _y, width: cellWidth);
                var xMovement = Float(_x)*cellWidth;
                var yMovement = Float(_y)*cellWidth;
                gridCell.position = CGPointMake(CGFloat(x+xMovement), CGFloat(y-yMovement));
                println("\(gridCell.position)")
                gridCell.number = _x+1+_y*numberOfRow;
                scene.addChild(gridCell)
            }
        }
    }
}