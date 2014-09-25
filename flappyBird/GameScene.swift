//
//  GameScene.swift
//  flappyBird
//
//  Created by Chris Rasch on 9/22/14.
//  Copyright (c) 2014 __Flip Flop Studios__. All rights reserved.
//

import SpriteKit

class GameScene: StartScene {
    
    var startButton = SKSpriteNode()
    var scoresButton = SKSpriteNode()
    
        override func didMoveToView(view: SKView) {
        
        
            movingBackground()
            
            titleName()
            
            startButton = SKSpriteNode (imageNamed: "play.png")
            startButton.name = "startButton"
            startButton.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 - 30)
            startButton.size = CGSizeMake(self.startButton.size.width / 12, self.startButton.size.height / 12)
            self.addChild(startButton)
            
            scoresButton = SKSpriteNode (imageNamed: "score.png")
            scoresButton.name = "scoresButton"
            scoresButton.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 - 150)
            scoresButton.size = CGSizeMake(self.scoresButton.size.width / 6, self.scoresButton.size.height / 6)
            self.addChild(scoresButton)
            
            
            
            
        
        }
    

    
    
        func movingBackground () {
        
        
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
            self.addChild(background)
            
            
        }
    }
    
        
        func titleName () {
            
            var titleLabel = SKLabelNode()
            titleLabel.fontName = "04b"
            titleLabel.text = "Flappy Bird"
            titleLabel.fontSize = 42
            titleLabel.fontColor = SKColor.whiteColor()
            titleLabel.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 + 100)
            self.addChild(titleLabel)
            
            
        }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        let touch: AnyObject? = touches.anyObject()
        let location = touch?.locationInNode(self)
        let node = nodeAtPoint(location!)
        
        if node.name == "startButton" {
            
            let transition = SKTransition.fadeWithColor(SKColor.whiteColor(), duration: 1)
            let scene = StartScene(size: self.size)
            scene.scaleMode = SKSceneScaleMode.AspectFill
            
            self.scene?.view?.presentScene(scene, transition: transition)
            
            
        } else if node.name == "scoresButton" {
            
            let transition = SKTransition.fadeWithColor(SKColor.whiteColor(), duration: 1)
            let scene = Scores(size: self.size)
            scene.scaleMode = SKSceneScaleMode.AspectFill
            
            self.scene?.view?.presentScene(scene, transition: transition)
            
            
        }
        
        
        
        
        
        
        
    }
    
    
    }


