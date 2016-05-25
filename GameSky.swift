//
//  Gamesky.swift
//  FlappyBird
//
//  Created by 韩志峰 on 16/3/20.
//  Copyright © 2016年 Zhifeng Han. All rights reserved.
//

import SpriteKit

class GameSky {
    
    /* 游戏天空区域起始点 */
    var startPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    /* 游戏天空区域高度 */
    var height: CGFloat = 0
    
    /* 天空node */
    var skyNode: SKSpriteNode
    
    
    init(containerSize: CGSize){
        skyNode = SKSpriteNode(imageNamed: "Background")
        skyNode.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        skyNode.position = CGPoint(x: containerSize.width/2, y: containerSize.height)
        skyNode.zPosition = imageLayers.background.rawValue
        
        startPoint = CGPoint(x: 0, y: containerSize.height - skyNode.size.height)
        height = skyNode.size.height
        makeSkyPhysics()
        
    }
    
    
    func makeSkyPhysics(){
    
        let leftBottomPoint = CGPoint(x: -skyNode.size.width/2, y: -skyNode.size.height)
        let rightBottomPoint = CGPoint(x: skyNode.size.width/2, y: -skyNode.size.height)
        
        
        skyNode.physicsBody = SKPhysicsBody(edgeFromPoint: leftBottomPoint, toPoint: rightBottomPoint)

        skyNode.physicsBody?.categoryBitMask = PhysicsLayer.land
        skyNode.physicsBody?.collisionBitMask = 0
        skyNode.physicsBody?.contactTestBitMask = PhysicsLayer.gameRole
        
    }

}