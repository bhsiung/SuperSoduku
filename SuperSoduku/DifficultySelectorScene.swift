import SpriteKit


class DifficultySelectorScene: SKScene
{
    var gameControllerDelegation: GameControllerDelegation?
    class var systemFont:String {
        return "Futura-Medium"
    }
    override func didMoveToView(view: SKView)
    {
        self.backgroundColor = SKColor(red: 0.788, green: 0.788, blue: 0.788, alpha: 1)
        var logoNode = SKSpriteNode(imageNamed: "logo")
        logoNode.position = CGPointMake(CGFloat((view.frame.width-logoNode.frame.width)/2), -0)
        println("\(logoNode.frame.width),\(view.frame.width)")
        logoNode.anchorPoint = CGPointMake(0, 1)
        self.addChild(logoNode)
        createSelector()
        createUserInfo()
    }
    func createUserInfo()
    {
        let lines:[(CGFloat,String)] = [(16,"level: \(UserProfile.lv)"),(16,"EXP: \(UserProfile.exp)")]
        var i = 0
        let yoffset:CGFloat = 60
        let xoffset:CGFloat = 10
        for (fontSize,text) in lines{
            var levelLabel = SKLabelNode(fontNamed: DifficultySelectorScene.systemFont)
            levelLabel.fontSize = fontSize
            levelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
            levelLabel.fontColor = SKColor.blackColor()
            levelLabel.text = text
            var y = Float(i) * Float(fontSize) * Float(1.6)
            levelLabel.position = CGPointMake(
                self.view!.frame.width - xoffset,
                yoffset + (self.view!.frame.height * -1) + CGFloat(y))
            addChild(levelLabel)
            i++
        }
    }
    func createSelector()
    {
        var i = 0
        let yOffset = -250
        let h = 25;
        let padding = 10
        for d in GameDifficulty.allValues{
            var link = GameLink(d: d,height:h)
            link.position = CGPointMake(160,CGFloat(yOffset-i*(h+padding)))
            link.gameControllerDelegation = self.gameControllerDelegation
            link.zPosition = 3
            addChild(link)
            i++
        }
    }
}
class GameLink:SKNode
{
    let labelNode:SKLabelNode
    let borderNode:SKShapeNode
    let difficulty:GameDifficulty
    var gameControllerDelegation:GameControllerDelegation?
    init(d:GameDifficulty,height: Int)
    {
        labelNode = SKLabelNode(fontNamed: DifficultySelectorScene.systemFont)
        labelNode.text = d.text
        labelNode.fontSize = 12;
        labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        labelNode.fontColor = SKColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        let w = 90
        let r = 4
        
        borderNode = SKShapeNode(path: CGPathCreateWithRoundedRect(CGRectMake(CGFloat(-1*w/2), CGFloat(-1*height/2), CGFloat(w), CGFloat(height)), CGFloat(r), CGFloat(r), nil))
        borderNode.strokeColor = SKColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        borderNode.fillColor = SKColor.clearColor()
        
        difficulty = d
        super.init()
        self.userInteractionEnabled = true
        self.addChild(borderNode)
        self.addChild(labelNode)
        if(!self.difficulty.isUnlocked){
            self.alpha = 0.5
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        if(self.difficulty.isUnlocked){
            self.gameControllerDelegation?.difficultySelected(self.difficulty)
        }
    }
}