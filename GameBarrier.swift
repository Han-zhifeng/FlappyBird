//
//  GameBarrier.swift
//  FlappyBird
//
//  Created by 韩志峰 on 16/3/20.
//  Copyright © 2016年 Zhifeng Han. All rights reserved.
//

import SpriteKit

class GameBarrier {
    
    /* 障碍露出高度相关：相对于障碍本身高度的最小乘数 */
    let minPercentOfReveal: CGFloat = 0.1
    
    /* 障碍露出高度相关：相对于障碍本身高度的最大乘数 */
    let maxPercentOfReveal: CGFloat = 0.6
    
    /* 上下障碍之间间隙宽度相对于游戏角色的乘数 */
    let gapRatioToGameRole: CGFloat = 5
    
    /* 首次生成障碍延迟 */
    let firstIntervalInSequence: NSTimeInterval = 1.75
    
    /* 非首次生成障碍延迟 */
    let intervalInSequence: NSTimeInterval = 1.5
    
    /* 生产障碍动作的key名称 */
    let showBarriersActionKey = "showBarriers"
    
    
    //MARK:在游戏界面开始生产障碍
    func showBarriersIn(scene: GameScene){
        
        let makeDoubleBarrier = SKAction.runBlock { () -> Void in
            let (topBarrier, bottomBarrier) = self.getDoubleBarriersIn(scene)
            scene.worldZone.addChild(topBarrier)
            scene.worldZone.addChild(bottomBarrier)
        }
        let makeDoubleBarrierSequence = SKAction.sequence([makeDoubleBarrier, SKAction.waitForDuration(intervalInSequence)])
        let makeBarriersAction = SKAction.repeatActionForever(makeDoubleBarrierSequence)
        let showBarriersSequence = SKAction.sequence([SKAction.waitForDuration(firstIntervalInSequence), makeBarriersAction])
        
        scene.runAction(showBarriersSequence, withKey: showBarriersActionKey)
        
    }
    
    //MARK:在游戏界面停止生产障碍
    func stopShowBarriersIn(scene: GameScene){
        
        scene.removeActionForKey(showBarriersActionKey)
        
        scene.worldZone.enumerateChildNodesWithName("topBarrier", usingBlock: {matchNode, _ in
            matchNode.removeAllActions()
        })
        
        scene.worldZone.enumerateChildNodesWithName("bottomBarrier", usingBlock: {matchNode, _ in
            matchNode.removeAllActions()
        })
    }

    
    
    func getDoubleBarriersIn(scene: GameScene) -> (SKSpriteNode, SKSpriteNode) {
        
        let bottomBarrier = self.getBottomBarrierIn(scene)
        
        let topBarrier = self.getTopBarrierIn(scene, withBottom: bottomBarrier)
        
        return (topBarrier, bottomBarrier)
    }
    
    
    func getBottomBarrierIn(scene: GameScene) -> SKSpriteNode{
        let bottomBarrier = SKSpriteNode(imageNamed: "CactusBottom")
        bottomBarrier.zPosition = imageLayers.barrier.rawValue
        bottomBarrier.anchorPoint = CGPoint(x: 0, y: 1)
        
        let revealReference: CGFloat = scene.size.height - scene.gameSky.startPoint.y - scene.gameRole.roleNode.size.height * gapRatioToGameRole
        let minHeight = scene.gameSky.startPoint.y + revealReference * minPercentOfReveal
        let maxHeight = scene.gameSky.startPoint.y + revealReference * maxPercentOfReveal
        bottomBarrier.position = CGPoint(x: scene.size.width, y: CGFloat.random(min: minHeight, max: maxHeight))
        
        bottomBarrier.name = "bottomBarrier"
        
        makeBarrierPhysicsBody(bottomBarrier)
        moveBarrier(bottomBarrier, in: scene)
        
        return bottomBarrier
    }
    
    func getTopBarrierIn(scene: GameScene, withBottom bottomBarrier:SKSpriteNode) -> SKSpriteNode{
        let topBarrier = SKSpriteNode(imageNamed: "CactusTop")
        topBarrier.zPosition = imageLayers.barrier.rawValue
        topBarrier.zRotation = CGFloat(180).degreesToRadians()
        
        topBarrier.position = CGPoint(x: scene.size.width + topBarrier.size.width/2, y: bottomBarrier.position.y + scene.gameRole.roleNode.size.height * gapRatioToGameRole + topBarrier.size.height/2)
        
        topBarrier.name = "topBarrier"
        topBarrier.userData = NSMutableDictionary()
        
        makeBarrierPhysicsBody(topBarrier)
        moveBarrier(topBarrier, in: scene)
        
        return topBarrier;
        
    }


    
    
    func moveBarrier(barrier: SKSpriteNode, in scene: GameScene){
        
        let moveDistanceOfX = -(scene.size.width + barrier.size.width)
        let moveDuration = moveDistanceOfX / scene.gameLand.landMoveSpeed.x
        let moveAction = SKAction.sequence([
            SKAction.moveByX(moveDistanceOfX, y: 0, duration: NSTimeInterval(moveDuration)),
            SKAction.removeFromParent()
            ])
        
        
        barrier.runAction(moveAction, withKey: "barrierMove")
    }
    
    func makeBarrierPhysicsBody(barrier: SKSpriteNode){
        let offsetX = barrier.size.width * barrier.anchorPoint.x
        let offsetY = barrier.size.height * barrier.anchorPoint.y
        
        let path = CGPathCreateMutable()
        
        CGPathMoveToPoint(path, nil, 3 - offsetX, 0 - offsetY)
        CGPathAddLineToPoint(path, nil, 7 - offsetX, 308 - offsetY)
        CGPathAddLineToPoint(path, nil, 46 - offsetX, 309 - offsetY)
        CGPathAddLineToPoint(path, nil, 50 - offsetX, 1 - offsetY)
        
        CGPathCloseSubpath(path)
        
        barrier.physicsBody = SKPhysicsBody(polygonFromPath: path)
        
        barrier.physicsBody?.categoryBitMask = PhysicsLayer.barrier
        barrier.physicsBody?.collisionBitMask = 0
        barrier.physicsBody?.contactTestBitMask = PhysicsLayer.gameRole
    }
    
    
    
}
