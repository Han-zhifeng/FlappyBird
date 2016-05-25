//
//  GameLand.swift
//  FlappyBird
//
//  Created by 韩志峰 on 16/3/20.
//  Copyright © 2016年 Zhifeng Han. All rights reserved.
//

import SpriteKit

class GameLand {
    
    /* land区域数量 */
    let landNum: Int = 2
    /* land区域移动速度 */
    let landMoveSpeed: CGPoint = CGPoint(x: -150.0, y: 0)
    
    /* landNode */
    var landNodes:[SKSpriteNode] = [SKSpriteNode]()
    /* land高度 */
    var landHeight: CGFloat
    
    init(initLandHeight: CGFloat){
        landHeight = initLandHeight
        //初始化landNode
        for i in 0..<landNum {
            let land = SKSpriteNode(imageNamed: "Ground")
            land.anchorPoint = CGPoint(x: 0, y: 1.0)
            land.position = CGPoint(x: CGFloat(i) * land.size.width, y: initLandHeight)
            land.zPosition = imageLayers.landground.rawValue
            land.name = "landground"
            landNodes.append(land)
        }
    }
    
    
    func moveWithInterval(interval: CGFloat){
        
        for landNode in landNodes {
            
            landNode.position += self.landMoveSpeed * CGFloat(interval)
            
            if landNode.position.x <= -landNode.size.width {
                landNode.position += CGPoint(x: landNode.size.width * CGFloat(self.landNum), y: 0)
            }
        }
        
    }
    
}
