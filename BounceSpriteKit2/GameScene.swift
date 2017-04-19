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
    var BGMusicOn: Bool = true
    var SoundOn: Bool = true
    let prefs = UserDefaults.standard
    
    let musicURL = Bundle.main.url(forResource: "WSU-Fight-Song.mp3", withExtension: nil)
    
    override func didMove(to view: SKView) {
        
        // Make walls bouncy
        let screenPhysicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        screenPhysicsBody.friction = 0.0
        screenPhysicsBody.categoryBitMask = 0b100
        screenPhysicsBody.collisionBitMask = 0b110
        screenPhysicsBody.contactTestBitMask = 0b001
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
        greenBallNode.physicsBody?.categoryBitMask = 0b100
        greenBallNode.physicsBody?.friction = 0.0
        greenBallNode.physicsBody?.restitution = 1.0
        greenBallNode.physicsBody?.linearDamping = 0.0
        greenBallNode.physicsBody?.categoryBitMask = 0b100
        greenBallNode.physicsBody?.collisionBitMask = 0b110
        greenBallNode.physicsBody?.contactTestBitMask = 0b001
        greenBallNode.position = position
        self.addChild(greenBallNode)
    }
    
    func startGame () {
        //vc = self.view!.window!.rootViewController?.
        self.isPaused = false
        self.startStopLabel.text = "Stop"
        redBallNode.physicsBody?.applyImpulse(CGVector(dx: 200.0, dy: 200.0))
        BGMusicOn = prefs.bool(forKey: "BGMusic")
        if(BGMusicOn){
            self.audioPlayer.play()
        }
        
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
                //print(node.name)
                if node.name == "StartStop" {
                    btnPressed = true
                    if (self.isPaused) {
                        self.startGame()
                    } else {
                        self.pauseGame()
                    }
                }
                if node.name == "settings"
                {
                    //self.vc.doSeg()
                    self.pauseGame()
                    self.view!.window!.rootViewController?.performSegue(withIdentifier: "gotosettings", sender: self)
                }
            }
        }
        if(!btnPressed){
            for touch in touches{
                let point = touch.location(in: self)
                let nodeArray = nodes(at: point)

                if nodeArray.count == 0
                {
                    insertGreenBall(touch.location(in: self))
                }
                
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
          let bodyNameA = String(describing: contact.bodyA.node?.name)
          let bodyNameB = String(describing: contact.bodyB.node?.name)
          print("Contact: \(bodyNameA), \(bodyNameB)")
        SoundOn = prefs.bool(forKey: "Sound")
        if(bodyNameB.contains("GreenBall") && bodyNameA.contains("GreenBall")){
            
        }
        else if (bodyNameB.contains("GreenBall") && bodyNameA.contains("RedBall")){
            let bodyB = contact.bodyB.node!
            if(SoundOn){
                run(glassSoundAction)
            }
            bodyB.removeFromParent()
        }
        else{
            if(SoundOn){
                run(bounceSoundAction)
            }
        }
        
    }

    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
