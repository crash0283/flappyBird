//
//  Scores.swift
//  flappyBird
//
//  Created by Chris Rasch on 9/25/14.
//  Copyright (c) 2014 __Flip Flop Studios__. All rights reserved.
//

import UIKit
import SpriteKit

class Scores: GameScene {
    
    override func didMoveToView(view: SKView) {
        
        movingBackground()
        scoresTitle()
        
        
        
        
    }
    
    
    func scoresTitle() {
        
        var scoresLabel = SKLabelNode()
        scoreLabel.fontName = "04b"
        scoreLabel.text = "High Scores"
        scoreLabel.fontColor = SKColor.whiteColor()
        scoreLabel.fontSize = 42
        scoreLabel.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 + 160)
        self.addChild(scoreLabel)
        
        
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
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        let touch: AnyObject? = touches.anyObject()
        let location = touch?.locationInNode(self)
        let node = nodeAtPoint(location!)
        
        if node.name == "backToMenuButton" {
            
            let transition = SKTransition.fadeWithColor(SKColor.whiteColor(), duration: 1)
            let scene = GameScene(size: self.size)
            scene.scaleMode = SKSceneScaleMode.AspectFill
            
            self.scene?.view?.presentScene(scene, transition: transition)
            
            
        }
        
        
        
    }
   
}
