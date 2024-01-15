//
//  GameScene.swift
//  test-game Shared
//
//  Created by Josh Jarvis on 14/01/2024.
//

import SpriteKit

class GameScene: SKScene {
    
    
    fileprivate var label : SKLabelNode?
    fileprivate var spinnyNode : SKShapeNode?
    var sprite: SKSpriteNode?
    var isWalking: Bool = false
    var walkingLocation: CGPoint = CGPoint.zero
    
    let walkFramesFor = [
        SKTexture(imageNamed: "Walk_1.png"),
        SKTexture(imageNamed: "Walk_2.png"),
        SKTexture(imageNamed: "Walk_3.png"),
        SKTexture(imageNamed: "Walk_4.png"),
        SKTexture(imageNamed: "Walk_5.png"),
        SKTexture(imageNamed: "Walk_6.png"),
        SKTexture(imageNamed: "Walk_7.png"),
        SKTexture(imageNamed: "Walk_8.png")
    ]
    let walkFramesBac = [
        SKTexture(imageNamed: "Walk_1_backwards.png"),
        SKTexture(imageNamed: "Walk_2_backwards.png"),
        SKTexture(imageNamed: "Walk_3_backwards.png"),
        SKTexture(imageNamed: "Walk_4_backwards.png"),
        SKTexture(imageNamed: "Walk_5_backwards.png"),
        SKTexture(imageNamed: "Walk_6_backwards.png"),
        SKTexture(imageNamed: "Walk_7_backwards.png"),
        SKTexture(imageNamed: "Walk_8_backwards.png")
    ]
    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    func setUpScene() {
        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
//        
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//        
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 4.0
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
        
        // Attempt to load the sprite image
        
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "5")
        background.zPosition = -1
        addChild(background)
        
        self.sprite = SKSpriteNode(imageNamed: "Idle_1.png")

        // Set sprite position and add it to the scene
        self.sprite?.zPosition = 1
        self.sprite?.physicsBody = SKPhysicsBody(rectangleOf: sprite?.size ?? CGSize.zero)
        self.sprite?.physicsBody?.affectedByGravity = true
        addChild(self.sprite ?? SKSpriteNode(imageNamed: "Idle_1.png"))
        
        let floor = SKShapeNode(rectOf: CGSize(width: 1334, height: 128))
        floor.position = CGPoint(x: 0, y: -190)
        
        // Load the floor texture
       let floorTexture = SKTexture(imageNamed: "Ground_11")

       // Calculate the number of tiles needed to cover the width of the floor
       let numberOfTiles = Int(1334 / 128) + 1

       // Create a repeating pattern of floor tiles
       for i in -10..<numberOfTiles {
           let tile = SKSpriteNode(texture: floorTexture)
           tile.position = CGPoint(x: i * Int(floorTexture.size().width), y: -60)
           tile.anchorPoint = CGPoint.zero
           floor.addChild(tile)
       }
        
        // Create a physics body for the floor
        let floorBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 128))
        floorBody.isDynamic = false // Make it a static object

        // Assign the physics body to the floor node
        floor.physicsBody = floorBody

        // Add the floor to the scene
        addChild(floor)
        

        self.setUpScene()
    }

    func makeSpinny(at pos: CGPoint, color: SKColor) {
        if let spinny = self.spinnyNode?.copy() as! SKShapeNode? {
            spinny.position = pos
            spinny.strokeColor = color
            self.addChild(spinny)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            let walkDistance = location.x - (self.sprite?.position.x ?? 0)

            let desiredSpeed: CGFloat = 125
            let distanceToTravel = abs(walkDistance)
            let walkDuration = TimeInterval(distanceToTravel / desiredSpeed)
            
            var walkFrames = walkFramesFor
            
            if (walkDistance < 0) {
                walkFrames = walkFramesBac
            }

            if let sprite = self.sprite {
                
                // Set up the sprite for walking animation
                let walkingAnimation = SKAction.animate(with: walkFrames, timePerFrame: 0.1)
                
                let repeatAction = SKAction.repeatForever(walkingAnimation)
                sprite.run(repeatAction, withKey: "walkingAnimation")

                // Move the sprite to the touched location
                
                let walkAction = SKAction.moveBy(x: walkDistance, y: 0, duration: walkDuration)
                
                sprite.run(walkAction, withKey: "walking")
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {

            let location = touch.location(in: self)
            
            let walkDistance = location.x - (self.sprite?.position.x ?? 0)

            let desiredSpeed: CGFloat = 125
            let distanceToTravel = abs(walkDistance)
            let walkDuration = TimeInterval(distanceToTravel / desiredSpeed)

            if let sprite = self.sprite {
                
                // Set up the sprite for walking animation
                let walkingAnimation = SKAction.animate(with: walkFramesFor, timePerFrame: 0.1)
                
                let repeatAction = SKAction.repeatForever(walkingAnimation)
                sprite.run(repeatAction, withKey: "walkingAnimation")

                // Move the sprite to the touched location
                
                let walkAction = SKAction.moveBy(x: walkDistance, y: 0, duration: walkDuration)
                
                sprite.run(walkAction, withKey: "walking")
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isWalking = false

        // Stop walking animation
        self.sprite?.removeAction(forKey: "walking")
        self.sprite?.removeAction(forKey: "walkingAnimation")
        
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
        }
    }
    
   
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {

    override func mouseDown(with event: NSEvent) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        self.makeSpinny(at: event.location(in: self), color: SKColor.green)
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.makeSpinny(at: event.location(in: self), color: SKColor.blue)
    }
    
    override func mouseUp(with event: NSEvent) {
        self.makeSpinny(at: event.location(in: self), color: SKColor.red)
    }

}
#endif

