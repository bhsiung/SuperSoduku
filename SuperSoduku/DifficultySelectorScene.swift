import SpriteKit


class DifficultyViewController:UIViewController,DifficultyControllerDelegation
{
    let bannerHeight:CGFloat = 50
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationController?.navigationBar.hidden = true // for navigation bar hide
        UIApplication.sharedApplication().statusBarHidden=true;
        goDifficultySelector()
        addBanner()
    }
    func goDifficultySelector()
    {
        let scene = DifficultySelectorScene();
        let skView = self.view as SKView;
        
        scene.scaleMode = .ResizeFill
        scene.anchorPoint = CGPoint(x:0,y:1);
        scene.size = CGSizeMake(skView.bounds.size.width, skView.bounds.size.height)
        scene.difficultyControllerDelegation = self
        
        skView.presentScene(scene)
        println("\(skView.bounds.size),\(scene.size)")
    }
    func difficultySelected(d: GameDifficulty) {
        if var gameVc:GameViewController = self.storyboard!.instantiateViewControllerWithIdentifier(
            "gameVc") as? GameViewController {
                gameVc.diffculty = d;
                self.navigationController?.pushViewController(gameVc, animated: true)
        }
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

class DifficultySelectorScene: SKScene
{
    var difficultyControllerDelegation: DifficultyControllerDelegation?
    var bannerHeight:CGFloat = 50
    class var systemFont:String {
        return "Futura-Medium"
    }
    override func didMoveToView(view: SKView)
    {
        UserProfile.exp = 3000
        self.backgroundColor = SKColor(red: 0.788, green: 0.788, blue: 0.788, alpha: 1)
        var logoNode = SKSpriteNode(imageNamed: "logo")
        println("\(view.frame),\(logoNode.frame)")
        // assume logo is square
        logoNode.size = CGSizeMake(self.frame.width, self.frame.width)
        logoNode.position = CGPointMake(CGFloat((self.frame.width-logoNode.frame.width)/2), -0)
        logoNode.anchorPoint = CGPointMake(0, 1)
        self.addChild(logoNode)
        createSelector()
        createUserInfo()
    }
    func createUserInfo()
    {
        let lines:[(CGFloat,String)] = [(16,"level: \(UserProfile.lv)"),(16,"EXP: \(UserProfile.exp)"),(13,"User profile:")]
        let bottomPadding:CGFloat = 15
        let yoffset:CGFloat = -1 * frame.height + bannerHeight + bottomPadding
        let xoffset:CGFloat = 10
        var y:CGFloat = yoffset
        
        
        for (fontSize,text) in lines{

            var levelLabel = SKLabelNode(fontNamed: DifficultySelectorScene.systemFont)
            levelLabel.fontSize = fontSize
            levelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
            levelLabel.fontColor = SKColor.blackColor()
            levelLabel.text = text
            levelLabel.position = CGPointMake(
                self.view!.frame.width - xoffset,y)
            addChild(levelLabel)
            y += fontSize * 1.6
        }
    }
    func createSelector()
    {
        var i = 0
        let h:CGFloat = 25;
        let w:CGFloat = 80
        let padding:CGFloat = 10
        let yOffset:CGFloat = CGRectGetMidY(frame) + h * CGFloat(GameDifficulty.allValues.count) / 2
        let xOffset:CGFloat = self.frame.width/2
        
        println("\(self.frame.width),\(w),\(xOffset)")
        for d in GameDifficulty.allValues{
            var link = GameLink(d: d,height:h,width:w)
            link.position = CGPointMake(
                xOffset,
                yOffset-CGFloat(i)*(h+padding))
            link.difficultyControllerDelegation = self.difficultyControllerDelegation
            link.zPosition = 3
            addChild(link)
            i++
        }
    }
}
class GameLink:HintButton
{
    let labelNode:SKLabelNode
    let difficulty:GameDifficulty
    var difficultyControllerDelegation:DifficultyControllerDelegation?
    
    init(d:GameDifficulty,height: CGFloat,width: CGFloat)
    {
        labelNode = SKLabelNode(fontNamed: DifficultySelectorScene.systemFont)
        labelNode.text = d.text
        labelNode.fontSize = 12;
        labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        labelNode.fontColor = SKColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        
        difficulty = d
        super.init(height: height, width: width)
        self.userInteractionEnabled = true
        self.addChild(borderNode)
        self.addChild(labelNode)
        if(!self.difficulty.isUnlocked){
            borderNode.alpha = 0.5
            labelNode.fontColor = SKColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            enableOverlay("", bodyText: "Level \(self.difficulty.text) is locked", width: 180, height: 40)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        if(self.difficulty.isUnlocked){
            self.difficultyControllerDelegation?.difficultySelected(self.difficulty)
        }
        super.touchesBegan(touches, withEvent: event)
    }
}

