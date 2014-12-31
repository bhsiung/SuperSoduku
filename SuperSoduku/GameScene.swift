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
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if let node = self.nodesAtPoint(location){
                if object_getClass(node) == SKSpriteNode {
                    
                }
                
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    func makeGrid()
    {
        let grid = SKSpriteNode(imageNamed: "grid_big.png")
        grid.position = CGPointMake(10,-10)
        grid.anchorPoint = CGPoint(x:0,y:1);
        grid.size = CGSizeMake(300, 300)
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(grid)
    }
    func makeNumberButtons()
    {
        let xoffset = 10.0;
        let yoffset = -350.0;
        let w = 30.0;
        let h = 30.0;
        let p = 10.0;
        for(var i=1; i<10; i++){
            let _i = Double(i);
            var numberButton = SKSpriteNode(imageNamed: "number_button_\(i).png");
            numberButton.position = CGPointMake(CGFloat(xoffset+_i*(w+p)), CGFloat(yoffset));
            numberButton.size = CGSizeMake(CGFloat(w), CGFloat(h))
            numberButton.name = "number-button"
            self.addChild(numberButton)
        }
    }
    
}
