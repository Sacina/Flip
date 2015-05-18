//
//  Ball.swift
//  Flip
//
//  Created by Matthew Stoton on 2015-04-11.
//  Copyright (c) 2015 Sacina. All rights reserved.
//

import Foundation
import SpriteKit

class Ball: SKSpriteNode {
    
    //Once I get to doing asset management I will probably use these enums for KVC so they will need string values
    
    enum Type {
        //ball types goin here
        //some types seem like colours, ex: Gray, but are types due to mechanics
        
        case Normal //Ordinary ball
        case Bomb //Becomes Gray ball if not cleared within a time limit
        case Switch //Randomized existing ball's colours but not types
        case Numbered //Must be cleared multiple times
        case Gray //An expired bomb, can only be cleared by level up
        case Black //Becomes frozen in place once it touches another ball
        
    }
    
    enum Colour {
        //ball colours
        //some colours seem to be missing, ex: Gray, but just aren't here because their colour and type are synonymous
        //rainbow has no particular mechanics so isn't a type
        case Blue
        case Orange
        case Red
        case Yellow
        case Green
        case Purple
        case Rainbow
    }
    
    var falling: Bool
    var ballType: Type
    var ballColour: Colour //Canadian spelling 🇨🇦
    
   /* override convenience init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        self.init(texture: nil, color: SKColor.whiteColor(), size: CGSize(width: 0, height: 0))
        
        //falling = false
        println("initializaed falling")
    }*/
    
    /*convenience init(imageNamed name: String) {
        self.init(texture: nil, color: SKColor.whiteColor(), size: CGSize(width: 0, height: 0))
    }*/
    
    init() {
        falling = false
        ballType = .Normal
        ballColour = .Blue
        super.init(texture:nil, color: nil, size: CGSize(width: 40, height: 40))
        
    }
    
    convenience init(imageNamed name: String) {
        self.init()
        let texture = SKTexture(imageNamed: name)
        self.texture = texture
        self.size = texture.size()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}