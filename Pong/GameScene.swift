//
//  GameScene.swift
//  Pong
//
//  Created by Sally on 6/13/18.
//  Copyright © 2018 Sally. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // Main gaming objects
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var main = SKSpriteNode()
    var enemyspeed = 1.0
    
    // test: new line to commit
    // Data objects
    var score = ["main": 0,
                 "enemy": 0]
    var winner:String? = nil
    var wins = 0
    
    // Label/notification objects
    var scorenotif = SKLabelNode()
    var scoreenemy = SKLabelNode()
    var scoremain = SKLabelNode()
    var endgame = SKLabelNode()
    
    // Customization objects
    var balltexture = SKTexture(image: #imageLiteral(resourceName: "600px-Circle_-_black_simple.svg"))
    var ballsize = CGSize(width: 30, height: 30)
    
    override func didMove(to view: SKView) {
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        ball.texture? = balltexture
        ball.size = ballsize
        ball.physicsBody?.applyImpulse(CGVector(dx: 20, dy: 20))
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        main = self.childNode(withName: "main") as! SKSpriteNode
        scorenotif = self.childNode(withName: "scorenotif") as! SKLabelNode
        scorenotif.isHidden = true
        endgame = self.childNode(withName: "endgame") as! SKLabelNode
        endgame.isHidden = true
        scoreenemy = self.childNode(withName: "scoreenemy") as! SKLabelNode
        scoremain = self.childNode(withName: "scoremain") as! SKLabelNode
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
        
    }
    
    func endgame(_ s: String) {
        endgame.text = "Winner: \(s)"
        endgame.isHidden = false
    }
    
    func reset() {
        endgame.isHidden = true
        if (winner! == "main") {
            wins += 1
            enemyspeed = 1.0/(2*Double(wins))
            if (wins == 1) {
                balltexture = SKTexture(image: #imageLiteral(resourceName: "pixel bubble"))
                ballsize = CGSize(width: 60, height: 60)
            }
            if (wins == 5) {
                balltexture = SKTexture(image: #imageLiteral(resourceName: "tech bubble-1"))
                ballsize = CGSize(width: 60, height: 60)
            }
            ball.texture? = balltexture
            ball.size = ballsize
        }
        winner = nil
        score = ["main": 0,
                 "enemy": 0]
        scoremain.text = "0"
        scoreenemy.text = "0"
    }
    
    func pause(scorer s: String) {
        super.isPaused = true
        score[s]! += 1
        if s == "main" {
            scoremain.text = String(score[s]!)
        }
        else {
            scoreenemy.text = String(score[s]!)
        }
        if score[s] == 5 {
            winner = s
            endgame(winner!)
        }
        else {
            scorenotif.isHidden = false
        }
    }
    
    func unpause() {
        scorenotif.isHidden = true
        if winner != nil {
            reset()
        }
        ball.position.x = 0
        ball.position.y = 0
        enemy.position.x = 0
        enemy.position.y = 550
        main.position.x = 0
        main.position.y = -550
        print(wins)
        super.isPaused = false
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if super.isPaused == true {
            unpause()
        }
        for touch in touches {
            let location = touch.location(in: self)
            main.run(SKAction.moveTo(x: location.x, duration: 0.2))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            main.run(SKAction.moveTo(x: location.x, duration: 0.2))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        enemy.run(SKAction.moveTo(x:ball.position.x, duration: (enemyspeed)))
        if (ball.position.y > enemy.position.y + 25) {
            pause(scorer: "main")
        }
        else if (ball.position.y < main.position.y - 25) {
            pause(scorer: "enemy")
        }
    }
}
