
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
    class func complete (bugPresent:Bool) {
        sharedInstance.spriteKitBugTestComplete = true
        sharedInstance.spriteKitBugPresent = bugPresent
        sharedInstance.completion?()
    }
    
    public class SpriteKitBugScene:SKScene {
        //SpriteKit Bug
        var bugPresent:Bool = true
        var bugTestInProgress:Bool = true
        var bugTimer:Timer?
        var blockTimer:Timer?
        public var launchImage:String?
        
        public override func didMove(to view: SKView) {
            if launchImage != nil {
                let background = SKSpriteNode(imageNamed: launchImage!)
                background.size = self.size
                background.position = CGPoint(x: size.width/2, y: size.height/2)
                background.zPosition = -2
                addChild(background)
            }
            let bugTest1 = SKNode()
            bugTest1.name = "Bug Test 1"
            bugTest1.position = CGPoint.zero
            addChild(bugTest1)
            let bugTest2 = SKNode()
            bugTest2.name = "Bug Test 2"
            bugTest2.position = CGPoint.zero
            bugTest1.addChild(bugTest2)
            let wait:TimeInterval = 0.003
            func removeAndMove(_ card:SKNode) {
                let oldParent = card.parent
                card.removeFromParent()
                addChild(card)
                self.run(SKAction.wait(forDuration: wait)){
                    card.removeFromParent()
                    oldParent!.addChild(card)
                    self.bugTestInProgress = false
                }
            }
            removeAndMove(bugTest2)
            bugTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(SpriteKitBugScene.bugTest2), userInfo: nil, repeats: true)
        }
        
        @objc func bugTest2 () {
            if bugTestInProgress {
                return
            }
            bugTimer?.invalidate()
            let bugTest1 = childNode(withName: "Bug Test 1")!
            let bugTest2 = bugTest1.childNode(withName: "Bug Test 2")!
            if bugTest2.parent != nil {
                self.bugPresent = false
                NSLog("Bug not present")
                SpriteKitBugTester.complete(bugPresent:false)
            } else {
                SpriteKitBugTester.complete(bugPresent:true)
                NSLog("Bug present")
            }
        }
        
    }
    
    
}
