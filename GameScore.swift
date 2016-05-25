//
//  GameScore.swift
//  FlappyBird
//
//  Created by 韩志峰 on 16/5/19.
//  Copyright © 2016年 Zhifeng Han. All rights reserved.
//

import SpriteKit

class GameScore {
    /* 即时展示得分区域字体名称*/
    let fontStyleName = "AmericanTypewriter-Bold"
    /* TOP位置得分标签*/
    let scoreLabelTop: SKLabelNode = SKLabelNode(fontNamed:"AmericanTypewriter-Bold")
    /* 即时展示得分区域距离屏幕上边的留白距离*/
    let scoreLabelTopGap: CGFloat = 20.0
    
    
    /* 当前得分*/
    var scoreNow = 0
    
    
    /* 历史最高分*/
    var scoreHighest = NSUserDefaults.standardUserDefaults().integerForKey("scoreHighestInHistory")
    
    /* 历史最高分存储key名称*/
    let scoreHighestKey = "scoreHighestInHistory"
    
    init(containerSize: CGSize){
        scoreLabelTop.fontColor = SKColor(red: 101.0/2255.0, green: 71.0/255.0, blue: 73.0/255.0, alpha: 1)
        scoreLabelTop.position = CGPoint(x: containerSize.width/2, y: containerSize.height - scoreLabelTopGap)
        scoreLabelTop.verticalAlignmentMode = .Top
        scoreLabelTop.text = "0"
        scoreLabelTop.zPosition = imageLayers.gameScore.rawValue
        
    }
    
    
    func updateScoreIn(scene: GameScene){
        scene.worldZone.enumerateChildNodesWithName("topBarrier", usingBlock: {matchItem, _ in
            if let barrier = matchItem as? SKSpriteNode{
                if let hasPass = barrier.userData?["hasPass"] as? NSNumber{
                    if hasPass.boolValue {
                        return
                    }
                }
                
                
                if scene.gameRole.roleNode.position.x > barrier.position.x + barrier.size.width/2 {
                    self.scoreNow += 1
                    self.scoreLabelTop.text = "\(self.scoreNow)"
                    scene.runAction(SKAction.sequence([GameSounds.coin, SKAction.waitForDuration(0.1)]))
                    barrier.userData?["hasPass"] = NSNumber(bool: true)
                    
                    if(self.scoreNow > self.scoreHighest){
                        self.setScoreHighest(self.scoreNow)
                    }
                    
                }
                
            }
        })
    }
    
    func getScoreHighest() -> Int {
        return scoreHighest
    }
    
    func setScoreHighest(score: Int){
        NSUserDefaults.standardUserDefaults().setInteger(score, forKey: scoreHighestKey)
        NSUserDefaults.standardUserDefaults().synchronize()
        scoreHighest = score
    }
    

}