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
    }
    func createSelector()
    {
        var i = 0
        let yOffset = -300
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
        let w = 90
        let r = 4
        
        borderNode = SKShapeNode(path: CGPathCreateWithRoundedRect(CGRectMake(CGFloat(-1*w/2), CGFloat(-1*height/2), CGFloat(w), CGFloat(height)), CGFloat(r), CGFloat(r), nil))
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