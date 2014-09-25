//
//  StartScene.swift
//  flappyBird
//
//  Created by Chris Rasch on 9/25/14.
//  Copyright (c) 2014 __Flip Flop Studios__. All rights reserved.
//

import UIKit
import SpriteKit

class StartScene: SKScene, SKPhysicsContactDelegate {
    
    
    
    //Define Sprites
    var bird = SKSpriteNode()
    var background = SKSpriteNode()
    var pipe1 = SKSpriteNode()
    var pipe2 = SKSpriteNode()
    var restartButton = SKSpriteNode()
    var backToMenuButton = SKSpriteNode()
    
    //Define collision masks
    let birdGroup: UInt32 = 1
    let objectGroup: UInt32 = 2
    let gapGroup: UInt32 = 0 << 3
    
    var movingObjects = SKNode()
    
    var gameOver = 0
    var score = 0
    var scoreLabel = SKLabelNode()
    var gameOverLabel = SKSpriteNode()
    var startDirections = SKLabelNode()
    
    var labelHolder = SKNode()
    var startGame = 1
    
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        movingObjects.speed = 0
        
        self.addChild(movingObjects)
        self.addChild(labelHolder)
        
        //Give Scene Gravity
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, -9.8)
        
        //Create label for score
        scoreLabel.fontName = "04b"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 + 300)
        scoreLabel.alpha = 0
        scoreLabel.zPosition = 20
        self.addChild(scoreLabel)
        
        
        //Create label for start directions
        startDirections.fontName = "Chalkduster"
        startDirections.fontSize = 40
        startDirections.text = "Tap To Start!"
        startDirections.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 + 100)
        startDirections.zPosition = 20
        self.addChild(startDirections)
        
        //Create bird texture
        var birdTexture = SKTexture (imageNamed: "flappy1.png")
        var birdTexture2 = SKTexture (imageNamed: "flappy2.png")
        
        //Init background
        makeBackground()
        
        //Create bird animation
        var animation = SKAction.animateWithTextures([birdTexture,birdTexture2], timePerFrame: 0.1)
        var makeBirdFlap = SKAction.repeatActionForever(animation)
        
        //Setup bird position and physics
        bird = SKSpriteNode (texture: birdTexture)
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        bird.zPosition = 10
        bird.physicsBody = SKPhysicsBody (circleOfRadius: bird.size.height / 2)
        bird.physicsBody?.dynamic = false
        bird.physicsBody?.allowsRotation = false
        bird.physicsBody?.categoryBitMask = birdGroup
        bird.physicsBody?.collisionBitMask = gapGroup
        bird.physicsBody?.contactTestBitMask = objectGroup
        
        self.addChild(bird)
        bird.runAction(makeBirdFlap)
        
        
        
        //Make scene a collider
        var ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody (edgeLoopFromRect: self.frame)
        ground.physicsBody?.categoryBitMask = objectGroup
        self.addChild(ground)
        
        //Create timer for pipes
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("makePipes"), userInfo: nil, repeats: true)
        
        
        
    }
    
    func makeBackground() {
        
        
        var backgroundTexture = SKTexture (imageNamed: "bg.png")
        
        var moveBg = SKAction.moveByX(-backgroundTexture.size().width, y: 0, duration: 9)
        var replaceBg = SKAction.moveByX(backgroundTexture.size().width, y: 0, duration: 0)
        
        var moveBgForever = SKAction.repeatActionForever(SKAction.sequence([moveBg,replaceBg]))
        
        for var i: CGFloat = 0; i < 3; i++ {
            
            background = SKSpriteNode (texture: backgroundTexture)
            background.position = CGPoint(x: backgroundTexture.size().width / 2 + backgroundTexture.size().width * i, y: CGRectGetMidY(self.frame))
            background.size.height = self.frame.height
            background.zPosition = 0
            
            background.runAction(moveBgForever)
            movingObjects.addChild(background)
            
            
        }
        
        
    }
    
    func makePipes() {
        
        if gameOver == 0 && movingObjects.speed == 1 {
            
            var pipe1texture = SKTexture (imageNamed: "pipe1.png")
            var pipe2texture = SKTexture (imageNamed: "pipe2.png")
            
            let gapHeight = bird.size.height * 4
            var movementAmount = arc4random() % UInt32(self.frame.height / 2)
            var pipeOffset = CGFloat(movementAmount) - self.frame.size.height / 4
            
            
            var movePipes = SKAction.moveByX(-self.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.size.width / 100))
            var removePipes = SKAction.removeFromParent()
            var pipeSeq = SKAction.sequence([movePipes,removePipes])
            
            
            pipe1 = SKSpriteNode (texture: pipe1texture)
            pipe1.position = CGPointMake(self.frame.width / 2 + self.frame.width, self.frame.height / 2 + pipe1.size.height / 2 + gapHeight / 2 + pipeOffset)
            pipe1.zPosition = 1
            pipe1.physicsBody = SKPhysicsBody (rectangleOfSize: pipe1texture.size())
            pipe1.physicsBody?.dynamic = false
            pipe1.physicsBody?.categoryBitMask = objectGroup
            
            
            
            movingObjects.addChild(pipe1)
            pipe1.runAction(pipeSeq)
            
            pipe2 = SKSpriteNode (texture: pipe2texture)
            pipe2.position = CGPointMake(self.frame.width / 2 + self.frame.width, self.frame.height / 2 - pipe2.size.height / 2 - gapHeight / 2 + pipeOffset)
            pipe2.zPosition = 2
            pipe2.physicsBody = SKPhysicsBody (rectangleOfSize: pipe2texture.size())
            pipe2.physicsBody?.dynamic = false
            pipe2.physicsBody?.categoryBitMask = objectGroup
            
            movingObjects.addChild(pipe2)
            pipe2.runAction(pipeSeq)
            
            var gap = SKNode()
            gap.position = CGPointMake(self.frame.width / 2 + self.frame.width, self.frame.height / 2 + pipeOffset)
            gap.physicsBody = SKPhysicsBody (rectangleOfSize: CGSize(width: pipe1.frame.size.width / 4, height: gapHeight))
            gap.physicsBody?.dynamic = false
            gap.physicsBody?.collisionBitMask = gapGroup
            gap.physicsBody?.categoryBitMask = gapGroup
            gap.physicsBody?.contactTestBitMask = birdGroup
            movingObjects.addChild(gap)
            gap.runAction(pipeSeq)
            
        }
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        
        if contact.bodyA.categoryBitMask == gapGroup || contact.bodyB.categoryBitMask == gapGroup {
            
            score++
            scoreLabel.text = String(score)
            
            
            
        } else {
            
            if gameOver == 0 {
                
                gameOver = 1
                movingObjects.speed = 0
                
                var pulseRed = SKAction.sequence([SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: 1.0, duration: 0.1), SKAction.colorizeWithColorBlendFactor(0.0, duration: 0.2)])
                
                bird.runAction(pulseRed)
                
                
                var gameOverTexture = SKTexture (imageNamed: "gameOver.png")
                gameOverLabel = SKSpriteNode (texture: gameOverTexture)
                gameOverLabel.position = CGPointMake(self.frame.width / 2, self.frame.height + 10)
                
                var moveLabelTo = SKAction.moveToY(self.frame.height / 2 + 50, duration: 0.5)
                var scaleLabel = SKAction.scaleTo(2, duration: 0.5)
                var redLabel = SKAction.colorizeWithColor(SKColor .redColor(), colorBlendFactor: 1, duration: 0.5)
                
                var groupLabel = SKAction.group([moveLabelTo,scaleLabel,redLabel])
                gameOverLabel.runAction(groupLabel)
                
                gameOverLabel.zPosition = 20
                labelHolder.addChild(gameOverLabel)
                
                var restartButtonTexture = SKTexture(imageNamed: "refresh.png")
                restartButton = SKSpriteNode (texture: restartButtonTexture)
                restartButton.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 - 500)
                restartButton.size = CGSizeMake(75, 75)
                var moveRestart = SKAction.moveToY(self.frame.size.height / 2 - 150, duration: 0.5)
                self.addChild(restartButton)
                restartButton.runAction(moveRestart)
                restartButton.zPosition = 20
                restartButton.name = "restartButton"
                
                var backToMenuButtonTexture = SKTexture(imageNamed: "back.png")
                backToMenuButton = SKSpriteNode (texture: backToMenuButtonTexture)
                backToMenuButton.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 - 500)
                backToMenuButton.size = CGSizeMake(75, 75)
                var moveBack = SKAction.moveToY(self.frame.size.height / 2 - 250, duration: 0.5)
                self.addChild(backToMenuButton)
                backToMenuButton.runAction(moveBack)
                backToMenuButton.zPosition = 100
                backToMenuButton.name = "backToMenuButton"
                
                
            }
        }
        
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        
        if gameOver == 0 {
            
            startDirections.alpha = 0
            scoreLabel.alpha = 1
            bird.physicsBody?.velocity = CGVectorMake(0, 0)
            bird.physicsBody?.applyImpulse(CGVectorMake(0, 60))
            startGame = 0
            
            if startGame == 0 {
                
                bird.physicsBody?.dynamic = true
                movingObjects.speed = 1
                
            }
            
        } else {
            
            var touch: AnyObject? = touches.anyObject()
            var location = touch?.locationInNode(self)
            var node = nodeAtPoint(location!)
            
            if node.name == "restartButton" {
                
                score = 0
                scoreLabel.text = "0"
                startDirections.alpha = 1
                scoreLabel.alpha = 0
                movingObjects.removeAllChildren()
                makeBackground()
                bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
                labelHolder.removeAllChildren()
                bird.physicsBody?.velocity = CGVectorMake(0, 0)
                startGame = 1
                bird.physicsBody?.dynamic = false
                
                gameOver = 0
                
                
                
                movingObjects.speed = 0
                restartButton.alpha = 0
                backToMenuButton.alpha = 0

                
            } else if node.name == "backToMenuButton" {
                
                let transitionToMenu = SKTransition.fadeWithColor(SKColor.whiteColor(), duration: 1)
                let scene = GameScene(size: self.size)
                scene.scaleMode = SKSceneScaleMode.AspectFill
                
                self.scene?.view?.presentScene(scene, transition: transitionToMenu)
                
                
            }
            
            
            
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

    
