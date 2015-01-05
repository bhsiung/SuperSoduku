import SpriteKit


class DifficultySelectorScene: SKScene
{
    var gameControllerDelegation: GameControllerDelegation?
    override func didMoveToView(view: SKView)
    {
        self.backgroundColor = SKColor(red: 0.50, green: 0.89, blue: 0.66, alpha: 1)
        var logoNode = SKSpriteNode(imageNamed: "logo")
        logoNode.position = CGPointMake(110, -100)
        logoNode.anchorPoint = CGPointMake(0, 1)
        self.addChild(logoNode)
        createSelector()
    }
    func createSelector()
    {
        var i = 0
        let yOffset = -220
        let h = 25;
        let padding = 10
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
    let difficulty:GameDifficulty
    var gameControllerDelegation:GameControllerDelegation?
    init(d:GameDifficulty)
    {
        labelNode = SKLabelNode(fontNamed: "Cochin-Bold")
        labelNode.text = d.text
        labelNode.fontSize = 16;
        
        difficulty = d
        super.init()
        self.userInteractionEnabled = true
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