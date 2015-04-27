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
    enum Direction {
        case North
        case South
        case East
        case West
    }
   
    //MARK: Properties
    //
    var gridWidth: Int
    var gridCount: Int
    let gridSpace = 5
    var lastUpdateInterval: Double = 0.0
    var updateInterval: Double
    var ballGrid = [Ball?]()
    var currentDirection: Direction
    var center: Int {
        get {
            return (gridCount / 2)
        }
    }
    
    /*
    override init(size: CGSize) {
        
        
        ballGrid = Array<Ball?>(count: 11, repeatedValue: Ball?()) //Array<Ball> is the same as [Ball]
        println("size init")
        
        super.init(size: size)
    }*/
    
    required init?(coder aDecoder: NSCoder) {
        currentDirection = .South
        updateInterval = 2.5
        gridWidth = 11
        gridCount = gridWidth * gridWidth
        
        ballGrid = Array<Ball?>(count: gridCount, repeatedValue: Ball?()) //Array<Ball> is the same as [Ball]
        
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
        let ballPit = self.childNodeWithName("BallPit")!
        ballPit.addChild(newBall)
        if (ballGrid[center] == nil) {
            ballGrid[center] = newBall
            
        } else {
            gameOver()
        }
        
        dropBall(center)
    }
    
    func dropBall(index: Int) {
        //tries tomove a single ball down a space in the grid
        /*if on left edge: index % gridwidth == 0
        if on right edge: index % gridwidth == gridwidth - 1
        I hate magic numbers so might refactor this later
        */
       // if (ballGrid[index]?.falling == false) {
            switch currentDirection {
            case .North:
                let position = index - gridWidth
                if (position > 0) {
                    if (ballGrid[position] == nil) {
                        ballGrid[position] = ballGrid[index]
                        ballGrid[index] = nil
                    }
                }
                println("North")
            case .South:
                let position = index + gridWidth
                if (position < gridCount) {
                    if (ballGrid[position] == nil) {
                        ballGrid[position] = ballGrid[index]
                        ballGrid[index] = nil
                    }
                }
                println("South")
            case .East:
                let position = index - 1
                if (index % gridWidth != 0) {
                    if (ballGrid[position] == nil) {
                        ballGrid[position] = ballGrid[index]
                        ballGrid[index] = nil
                    }
                }
                println("East")
                
            case .West:
                let position = index + 1
                if (index % gridWidth != gridWidth - 1) {
                    if (ballGrid[position] == nil) {
                        ballGrid[position] = ballGrid[index]
                        ballGrid[index] = nil
                    }
                }
                println("West")
            default:
                assertionFailure("No direction specified")
                
            }
          //  ballGrid[index]?.falling = true
       // }
    }
    
    func dropAllBalls() {
        //tries to move all balls down a space
        for index in 0..<ballGrid.count {
            dropBall(index)
        }
    }
    
    func printArray() {
        for column in 0..<11 {
            for row in 0..<11 {
                println(ballGrid[row])
            }
        }
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
        
        
        if (timeSinceLast >= updateInterval) {
            lastUpdateInterval = currentTime
        }
        //println("timeSinceLast\(timeSinceLast) , lastUpdateInterval \(lastUpdateInterval) , currentTime \(currentTime)")
/*
        the whole point of actions was so we dno't have to manually move things, but we could here if needed, that would be the second approach I'd try though. for now we will simply use this to call dropAllBalls 

*/
    }
    
}

    