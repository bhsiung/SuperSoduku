import SpriteKit


class DifficultyViewController:UIViewController,DifficultyControllerDelegation
{
    let bannerHeight:CGFloat = 0
    var scene:DifficultySelectorScene?
    override func viewDidLoad()
    {
        //UserProfile.exp = 30
        super.viewDidLoad()
        navigationController?.navigationBar.hidden = true
        UIApplication.sharedApplication().statusBarHidden=true;
        goDifficultySelector()
        //addBanner()
    }
    override func viewDidAppear(animated: Bool) {
        self.scene?.refreshUserInfo()
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
        self.scene = scene
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
    class var systemFont:String {
        return "Futura-Medium"
    }
    override func didMoveToView(view: SKView)
    {
        self.backgroundColor = SKColor(red: 0.788, green: 0.788, blue: 0.788, alpha: 1)
        var logoNode = SKSpriteNode(imageNamed: "logo")
        // assume logo is square
        logoNode.size = CGSizeMake(self.frame.width, self.frame.width)
        logoNode.position = CGPointMake(CGFloat((self.frame.width-logoNode.frame.width)/2), -0)
        logoNode.anchorPoint = CGPointMake(0, 1)
        self.addChild(logoNode)
        createSelector()
        createUserInfo()
        self.runAction(SKAction.repeatActionForever(SKAction.playSoundFileNamed("main.mp3", waitForCompletion: true)), withKey:"music")
    }
    func refreshUserInfo()
    {
        //todo
        println("refresh")
    }
    func createUserInfo()
    {
        let lines:[(CGFloat,String)] = [(16,"level: \(UserProfile.lv)"),(16,"exp: \(UserProfile.exp)"),(13,"User profile:")]
        let bottomPadding:CGFloat = 35
        let yoffset:CGFloat = -1 * frame.height + bottomPadding + 10
        let xoffset:CGFloat = 10
        var y:CGFloat = yoffset
        let containerWidth:CGFloat = 112
        let containerHeight:CGFloat = 85
        
        let container = SKShapeNode(rect: CGRectMake(
            frame.width - containerWidth + 12,
            -1 * frame.height + bottomPadding,
            containerWidth, containerHeight), cornerRadius: 12)
        container.fillColor = GridCellColor.green.color
        container.strokeColor = SKColor.clearColor()
        addChild(container)
        
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
        let h:CGFloat = 35;
        let w:CGFloat = 130
        let padding:CGFloat = 10
        var yOffset:CGFloat = 0
        if(frame.height <= 480){
            yOffset = -220
        }else{
            yOffset = CGRectGetMidY(frame) + h * CGFloat(GameDifficulty.allValues.count) / 4 - 50
        }
        
        let xOffset1:CGFloat = (self.frame.width - w - padding)/2
        let xOffset2:CGFloat = (self.frame.width + w + padding)/2
        
        for d in GameDifficulty.allValues{
            var link = GameLink(d: d,height:h,width:w)
            if(i>2){
                link.position = CGPointMake(
                    xOffset2,
                    yOffset-CGFloat(i%3)*(h+padding))
            }else{
                link.position = CGPointMake(
                    xOffset1,
                    yOffset-CGFloat(i%3)*(h+padding))
            }
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
        //borderNode.strokeColor = SKColor.clearColor()
        //borderNode.fillColor = GridCellColor.orange.color
        
        self.userInteractionEnabled = true
        self.addChild(borderNode)
        self.addChild(labelNode)
        if(!self.difficulty.isUnlocked){
            borderNode.alpha = 0.5
            labelNode.fontColor = SKColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            enableOverlay("", bodyText: "\(self.difficulty.text) is locked", width: 160, height: 36)
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

