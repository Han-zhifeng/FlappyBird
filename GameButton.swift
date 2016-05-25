//
//  GameButtonStart.swift
//  FlappyBird
//
//  Created by 韩志峰 on 16/3/26.
//  Copyright © 2016年 Zhifeng Han. All rights reserved.
//

import SpriteKit

class GameButton {
    
    //buttonNode的容器,统一使用button图片
    let buttonNode: SKSpriteNode = SKSpriteNode(imageNamed:"Button")
    //buttonNode
    let buttonLabel: SKSpriteNode
    
    init(buttonLabelName: String, position: CGPoint, zPosition: CGFloat){
    
        buttonNode.zPosition = zPosition
        buttonNode.position = position
        
        buttonLabel = SKSpriteNode(imageNamed: buttonLabelName)
        buttonLabel.position = CGPoint(x: 0, y: 0)
        buttonLabel.zPosition = zPosition + 1
        
        buttonNode.addChild(buttonLabel)
    }
    
    
    convenience init(buttonLabelName labelName: String) {
        self.init(buttonLabelName:labelName, position: CGPoint(x: 0, y: 0), zPosition: imageLayers.gameButton.rawValue)
    }
    
}


