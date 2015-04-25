//
//  GameScene.swift
//  Flip
//
//  Created by Matthew Stoton on 2015-03-17.
//  Copyright (c) 2015 Sacina. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
/*
    Short term goals:
    Spawn balls, which will involve asset management feeding us graphics
    have them fall, which will require the grid/actions to be working
    end the game when a column fills
    
    Going to do a lot of things lazily and later refactor it into subclasses and protocols
    Ex, Image preloading will go into AssetManagement, 

*/
    
   
    //MARK: Properties
    //
    let gridsize = 11
    let gridspace = 5
    var lastUpdateInterval: Double = 0.0
    var center: Int {
        get {
            return ((gridsize / 2) + 1)
        }
    }
    var ballArray = [Ball?]()
    /*
    override init(size: CGSize) {
        
        
        ballArray = Array<Ball?>(count: 11, repeatedValue: Ball?()) //Array<Ball> is the same as [Ball]
        println("size init")
        
        super.init(size: size)
    }*/
    
    required init?(coder aDecoder: NSCoder) {
        ballArray = Array<Ball?>(count: 11, repeatedValue: Ball?()) //Array<Ball> is the same as [Ball]
        lastUpdateInterval = 0.0
        super.init(coder: aDecoder)
    }
    
    

    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        spawnBall()
        self.addChild(myLabel)
    }
    
    func spawnBall() {
        //spawns new balls, calls gameover if it can't
        let newBall = Ball(imageNamed: "blackball")
        //assert(self.childNodeWithName("ballPit") != nil, "null")
        if (self.childNodeWithName("BallPit") != nil) {
            println("found ballpit")
        }
        let ballPit = self.childNodeWithName("BallPit")!
        ballPit.addChild(newBall)
        if (ballArray[center] == nil) {
            ballArray[center] = newBall
            println("added ball")
        } else {
            gameOver()
        }
    }
    
    func dropBall() {
        //tries tomove a single ball down a space
    }
    
    func dropAllBalls() {
        //tries to drop all balls
    }
    
    func gameOver() {
        //end game if a ball already exists at the spawn point
        println("Game Over")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        var timeSinceLast = currentTime - lastUpdateInterval
        lastUpdateInterval = currentTime
        //println("timeSinceLast\(timeSinceLast) , lastUpdateInterval \(lastUpdateInterval) , currentTime \(currentTime)")
/*
        the whole point of actions was so we dno't have to manually move things, but we could here if needed, that would be the second approach I'd try though. for now we will simply use this to call dropAllBalls 

*/
    }
    
}

    