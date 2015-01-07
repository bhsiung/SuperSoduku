import SpriteKit


class DifficultySelectorScene: SKScene
{
    var gameControllerDelegation: GameControllerDelegation?
    class var systemFont:String {
        return "Futura-Medium"
    }
    override func didMoveToView(view: SKView)
    {
        self.backgroundColor = SKColor(red: 0.60, green: 0.6, blue: 0.5, alpha: 1)
        var logoNode = SKSpriteNode(imageNamed: "logo")
        logoNode.position = CGPointMake(110, -80)
        logoNode.anchorPoint = CGPointMake(0, 1)
        self.addChild(logoNode)
        createSelector()
    }
    func createSelector()
    {
        var i = 0
        let yOffset = -240
        let h = 30;
        let padding = 15
        for d in GameDifficulty.allValues{
            var link = GameLink(d: d)
            link.position = CGPointMake(160,CGFloat(yOffset-i*(h+padding)))
            link.gameControllerDelegation = self.gameControllerDelegation
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
    init(d:GameDifficulty)
    {
        labelNode = SKLabelNode(fontNamed: DifficultySelectorScene.systemFont)
        labelNode.text = d.text
        labelNode.fontSize = 12;
        labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        let w = 90
        let h = 30
        let r = 4
        
        borderNode = SKShapeNode(path: CGPathCreateWithRoundedRect(CGRectMake(CGFloat(-1*w/2), CGFloat(-1*h/2), CGFloat(w), CGFloat(h)), CGFloat(r), CGFloat(r), nil))
        borderNode.strokeColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)
        borderNode.fillColor = SKColor.clearColor()
        
        difficulty = d
        super.init()
        self.userInteractionEnabled = true
        self.addChild(borderNode)
        self.addChild(labelNode)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        self.gameControllerDelegation?.difficultySelected(self.difficulty)
    }
}