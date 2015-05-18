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
    
    Important Notes:
    The orientation of the grid is fairly important
    if its a 3x3 it would be
    6 7 8
    3 4 5
    0 1 2
    
    truthfully I don't think it matters which way its oriented as long as 0, the first element in the grid
    is visualized as being on the bottom so that physically a ball at 0 in the array in on the bottom of 
    the screen
    
    actually this reveals a flaw in this algorithm. 0 is on the bottom because the bottom needs to be checked
    first, but when the orientation changes the order of falling will no longer be correct for fully half the orientations
    ex:
     <- if this is portrait imagine it becoming right landscape, the checking order is fine because it still moves bottom to top, but imagine it flipping to left landscape, now it would be checking top to bottom
    portrait and right landscape need to start at 8, upside down portrait and left landscape need to start at 0
    
    0 1 2 3 4 5 6 7 8 9 10 11
    
    0 1 2   2 5 8
    3 4 5   1 4 7
    6 7 8   0 3 6
    
    6 3 0   8 7 6
    7 4 1   5 4 3
    8 5 2   2 1 0

*/
    enum Direction {
        case PortraitUpsideDown
        case Portrait
        case LandscapeRight
        case LandscapeLeft
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
        currentDirection = .Portrait
        updateInterval = 2.5
        gridWidth = 11
        gridCount = gridWidth * gridWidth
        
        ballGrid = Array<Ball?>(count: gridCount, repeatedValue: Ball?()) //Array<Ball> is the same as [Ball]
        
        lastUpdateInterval = 0.0
        super.init(coder: aDecoder)
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        */
        //UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "detectOrientation",
            name:UIDeviceOrientationDidChangeNotification,
            object:nil)
        
        spawnBall()
    }
    
    func detectOrientation() {
        switch UIDevice.currentDevice().orientation {
        case .Portrait:
            currentDirection = .Portrait
            println("Portrait")
        case .LandscapeLeft:
            currentDirection = .LandscapeLeft
            println("LandscapeLeft")
        case .LandscapeRight:
            currentDirection = .LandscapeRight
            println("LandscapeRight")
        case .PortraitUpsideDown:
            currentDirection = .PortraitUpsideDown
            println("PortraitUpsideDown")
        default:
            println(UIDevice.currentDevice().orientation.rawValue)
        }
    }
    
    func spawnBall() {
        //spawns new balls, calls gameover if it can't
        let newBall = Ball(imageNamed: "redball")
        //assert(self.childNodeWithName("ballPit") != nil, "null")
        let ballPit = self.childNodeWithName("BallPit")!
        ballPit.addChild(newBall)
        newBall.position = CGPointMake(0, 0)
        if (ballGrid[center] == nil) {
            ballGrid[center] = newBall
            
        } else {
            gameOver()
        }
        
        let newBall2 = Ball(imageNamed: "blueball")
        ballPit.addChild(newBall2)
        ballGrid[center + gridWidth] = newBall2
        newBall2.position = CGPointMake(0, 58)
        printGrid()
        
    }
    
    func printGrid() {
        for index in 0..<ballGrid.count {
            if (index % gridWidth == 0) { println() }
            //print(index)
            if ballGrid[index] == nil { print("0") }
            if ballGrid[index] != nil {
                if ballGrid[index]?.falling == false {
                    print("1")
                    
                }
                else if ballGrid[index]?.falling == true {
                    print("2")
                }
            }
            
        }
    }
    
    func dropBall(index: Int) {
        //tries tomove a single ball down a space in the grid
        /*if on left edge: index % gridwidth == 0
        if on right edge: index % gridwidth == gridwidth - 1
        I hate magic numbers so might refactor this later
        
        Also very little point in not directly tapping UIDevice.currentDevice().orientation
        so I may change this later
        */
        if (ballGrid[index]?.falling == false) {
            //ballGrid[index]?.falling = true
            switch currentDirection {
            case .PortraitUpsideDown:
                let position = index - gridWidth
                if (position > 0) {
                    if (ballGrid[position] == nil) {
                        ballGrid[position] = ballGrid[index]
                        ballGrid[index] = nil
                    }
                }
                println("up")
            case .Portrait:
                let position = index + gridWidth
                if (position < gridCount) {
                    if (ballGrid[position] == nil) {
                        ballGrid[position] = ballGrid[index]
                        ballGrid[index] = nil
                        ballGrid[position]?.position.y -= 50
                        println("moved")
                    }
                }
                println("down")
            case .LandscapeLeft:
                let position = index - 1
                if (index % gridWidth != 0) {
                //if (index % gridWidth != gridWidth - 1) {
                    if (ballGrid[position] == nil) {
                        ballGrid[position] = ballGrid[index]
                        ballGrid[index] = nil
                    }
                }
                println("East")
                
            case .LandscapeRight:
                let position = index + 1
                if (index % gridWidth != gridWidth - 1) {
                //if (index % gridWidth != 0) {
                    if (ballGrid[position] == nil) {
                        ballGrid[position] = ballGrid[index]
                        ballGrid[index] = nil
                    }
                }
                println("left")
            default:
                assertionFailure("No direction specified")
                
            }
            
        }
    }
    
    func dropAllBalls() {
        //tries to move all balls down a space
        //this is an incredibly unsexy bit of code fix later
        //the grid must be traversed in different order based on orientation
        
        if (currentDirection == .Portrait || currentDirection == .LandscapeRight)
        {
            for (var index = ballGrid.count-1; index >= 0; index--) {
                if (ballGrid[index] != nil) {
                    dropBall(index)
                }
            }
        } else {
            for (var index = 0; index < ballGrid.count; index++) { //index in 0..<ballGrid.count {
                if (ballGrid[index] != nil) { //not 100% sure this check is needed
                    dropBall(index)
                }
            }
        }
        
    }
    
    func moveBalls() {
        //move the balls physically if they're flagged to move
        //temporarily just moving them instantly for testing
        //actions later
    }
    
    
    
    func gameOver() {
        //end game if a ball already exists at the spawn point
        println("Game Over")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        //println(UIDevice.currentDevice().orientation.rawValue)
        dropAllBalls()
        printGrid()
        /*
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }*/
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        var timeSinceLast = currentTime - lastUpdateInterval
        
        
        if (timeSinceLast >= updateInterval) {
            lastUpdateInterval = currentTime
            //code here happenes every updateInterval
        }
        //println("timeSinceLast\(timeSinceLast) , lastUpdateInterval \(lastUpdateInterval) , currentTime \(currentTime)")
/*
        the whole point of actions was so we dno't have to manually move things, but we could here if needed, that would be the second approach I'd try though. for now we will simply use this to call dropAllBalls 

*/
    }
    
}

    