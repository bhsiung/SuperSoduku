//
//  MetaClasses.swift
//  SuperSoduku
//
//  Created by BIINGYANN HSIUNG on 1/12/15.
//  Copyright (c) 2015 BIINGYANN HSIUNG. All rights reserved.
//

import Foundation
import SpriteKit

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
protocol GridCellDelegation{
    func moveCursor(pos:Pos)
    func setNumber(number:Int,isAnnotation:Bool)
    func setColor(GridCellColor,isAnnotation:Bool)
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
            return SKColor(red: 0.81, green: 0.627, blue: 0.564, alpha: 1)
        case orange:
            return SKColor(red: 0.996, green: 0.796,blue: 0.573, alpha: 1)
        case .yellow:
            return SKColor(red: 0.894, green: 0.851,blue: 0.671, alpha: 1)
        case green:
            return SKColor(red: 0.675, green: 0.765,blue: 0.420, alpha: 1)
        case blue:
            return SKColor(red: 0.525, green: 0.714,blue: 0.792, alpha: 1)
        case .purple:
            return SKColor(red: 0.616, green: 0.647,blue: 0.929, alpha: 1)
        case .gray:
            return SKColor(red: 0.831, green: 0.773,blue: 0.745, alpha: 1)
        case cyan:
            return SKColor(red: 0.125, green: 0.753,blue: 0.745, alpha: 1)
        case .brown:
            return SKColor(red: 0.761, green: 0.702,blue: 0.533, alpha: 1)
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
            return diceRoll > 5;
        case normal:
            return diceRoll > 30;
        case hard:
            return diceRoll > 50;
        case insane:
            return diceRoll > 10
        case expert:
            return diceRoll > 50;
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