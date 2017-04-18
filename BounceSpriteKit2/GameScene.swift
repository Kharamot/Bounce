//
//  GameScene.swift
//  BounceSpriteKit2
//
//  Created by Larry Holder on 4/4/17.
//  Copyright © 2017 Larry Holder. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var redBallNode: SKSpriteNode!
    var greenBallNode: SKSpriteNode!
    var startStopLabel: SKLabelNode!
    let bounceSoundAction = SKAction.playSoundFileNamed("bounce.mp3", waitForCompletion: false)
    let glassSoundAction = SKAction.playSoundFileNamed("glassbreak.mp3", waitForCompletion: false)
    var audioPlayer: AVAudioPlayer!
    
    let musicURL = Bundle.main.url(forResource: "WSU-Fight-Song.mp3", withExtension: nil)
    
    override func didMove(to view: SKView) {
        
        // Make walls bouncy
        let screenPhysicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        screenPhysicsBody.friction = 0.0
        screenPhysicsBody.categoryBitMask = 0b100
        self.physicsBody = screenPhysicsBody
        
        redBallNode = self.childNode(withName: "RedBall") as! SKSpriteNode
        startStopLabel = self.childNode(withName: "StartStop") as! SKLabelNode
        
        physicsWorld.contactDelegate = self
        
        self.initGame()
    }
    
    func initGame () {
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: musicURL!)
        }catch{
            print("error accessing music")
        }
        audioPlayer.volume = 0.25
        audioPlayer.numberOfLoops = -1
    }
    
    func insertGreenBall(_ position: CGPoint)
    {
        // Add green ball programmatically
        greenBallNode = SKSpriteNode(imageNamed: "greenball.png")
        greenBallNode.name = "GreenBall"
        greenBallNode.physicsBody = SKPhysicsBody(circleOfRadius: 50.0)
        greenBallNode.physicsBody?.affectedByGravity = false
        greenBallNode.physicsBody?.friction = 0.0
        greenBallNode.physicsBody?.restitution = 1.0
        greenBallNode.physicsBody?.linearDamping = 0.0
        greenBallNode.physicsBody?.categoryBitMask = 0b001
        greenBallNode.physicsBody?.collisionBitMask = 0b110
        greenBallNode.physicsBody?.contactTestBitMask = 0b001
        greenBallNode.position = position
        self.addChild(greenBallNode)
    }
    
    func startGame () {
        self.isPaused = false
        self.startStopLabel.text = "Stop"
        redBallNode.physicsBody?.applyImpulse(CGVector(dx: 200.0, dy: 200.0))
        self.audioPlayer.play()
    }
    
    func pauseGame () {
        self.isPaused = true
        self.startStopLabel.text = "Start"
        self.audioPlayer.pause()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var btnPressed = false
        for touch in touches {
            let point = touch.location(in: self)
            let nodeArray = nodes(at: point)
            for node in nodeArray {
                if node.name == "StartStop" {
                    btnPressed = true
                    if (self.isPaused) {
                        self.startGame()
                    } else {
                        self.pauseGame()
                    }
                }
            }
        }
        if(!btnPressed){
            for touch in touches{
                insertGreenBall(touch.location(in: self))
            }
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
          let bodyNameA = String(describing: contact.bodyA.node?.name)
          let bodyNameB = String(describing: contact.bodyB.node?.name)
          print("Contact: \(bodyNameA), \(bodyNameB)")
        
        //If a green ball is contacted remove it
        if(bodyNameA.contains("GreenBall")){
            let bodyA = contact.bodyA.node!
            run(glassSoundAction)
            bodyA.removeFromParent()
        }
        
        if(bodyNameB.contains("GreenBall")){
            let bodyB = contact.bodyB.node!
            run(glassSoundAction)
            bodyB.removeFromParent()
        }
    }

    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
