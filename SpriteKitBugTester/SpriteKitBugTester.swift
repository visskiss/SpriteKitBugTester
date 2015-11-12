//
//  BugScene.swift
//  Spin Solitaire
//
//  Created by visskiss on 9/16/15.
//  Copyright © 2015 visskiss. All rights reserved.
//

import Foundation
import SpriteKit

public class SpriteKitBugTester {
    public var completion:(()->())?
    //singleton class
    public static let  sharedInstance = SpriteKitBugTester(completion: nil)
    init (completion:(()->())?) {
        self.completion = completion
    }
    var spriteKitBugTestComplete:Bool = false
    var spriteKitBugPresent:Bool = true
    class var testComplete:Bool {
        get {
        return sharedInstance.spriteKitBugTestComplete
        }
        set (value) {
            sharedInstance.spriteKitBugTestComplete = value
        }
    }
    public class var bugPresent:Bool {
        get {
            return sharedInstance.spriteKitBugPresent
        }
    }
    class func complete (bugPresent bugPresent:Bool) {
        sharedInstance.spriteKitBugTestComplete = true
        sharedInstance.spriteKitBugPresent = bugPresent
        sharedInstance.completion?()
    }
    
    public class SpriteKitBugScene:SKScene {
        //SpriteKit Bug
        var bugPresent:Bool = true
        var bugTestInProgress:Bool = true
        var bugTimer:NSTimer?
        var blockTimer:NSTimer?
        var launchImage:String?
        
        public override func didMoveToView(view: SKView) {
            if launchImage != nil {
                let background = SKSpriteNode(imageNamed: launchImage!)
                background.size = self.size
                background.position = CGPoint(x: size.width/2, y: size.height/2)
                background.zPosition = -2
                addChild(background)
            }
            let bugTest1 = SKSpriteNode(imageNamed: "SKBTBlank")
            bugTest1.name = "Bug Test 1"
            bugTest1.size = CGSizeMake(1, 1)
            bugTest1.position = CGPointZero
            addChild(bugTest1)
            let bugTest2 = SKSpriteNode(imageNamed: "SKBTBlank")
            bugTest2.name = "Bug Test 2"
            bugTest2.size = CGSizeMake(1, 1)
            bugTest2.position = CGPointZero
            bugTest1.addChild(bugTest2)
            let wait:NSTimeInterval = 0.003
            func removeAndMove(card:SKNode) {
                let oldParent = card.parent
                card.removeFromParent()
                addChild(card)
                self.runAction(SKAction.waitForDuration(wait)){
                    card.removeFromParent()
                    oldParent!.addChild(card)
                    self.bugTestInProgress = false
                }
            }
            removeAndMove(bugTest2)
            bugTimer = NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: "bugTest2", userInfo: nil, repeats: true)
        }
        
        func bugTest2 () {
            if bugTestInProgress {
                return
            }
            bugTimer?.invalidate()
            let bugTest1 = childNodeWithName("Bug Test 1")!
            let bugTest2 = bugTest1.childNodeWithName("Bug Test 2")!
            if bugTest2.parent != nil {
                self.bugPresent = false
                print("Bug not present")
                SpriteKitBugTester.complete(bugPresent:false)
            } else {
                SpriteKitBugTester.complete(bugPresent:true)
                print("Bug present")
            }
        }
        
    }
    
    
}