//
//  Gamerole.swift
//  FlappyBird
//
//  Created by 韩志峰 on 16/3/20.
//  Copyright © 2016年 Zhifeng Han. All rights reserved.
//
import SpriteKit

class GameRole {
    let numOfRoleImages = 4
    
    /* 游戏角色node */
    let roleNode: SKSpriteNode = SKSpriteNode(imageNamed: "Bird0")
    
    /* 游戏角色头上的帽子node */
    let hatNode: SKSpriteNode = SKSpriteNode(imageNamed: "Sombrero")
    
    /* 游戏角色初始速度 */
    var speedOfNow: CGPoint = CGPoint.zero
    /* 游戏角色上冲加速度 */
    let speedOfTouched: CGPoint = CGPoint(x: 0, y: 400.0)
    /* 游戏角色下降加速度 */
    let accelerationOfGravity: CGPoint =  CGPoint(x: 0, y: -1500.0)
    
    
    init(containerSize: CGSize, initPosition: CGPoint){
        roleNode.zPosition = imageLayers.gameRole.rawValue
        roleNode.position = initPosition
        //设置gameRole物理碰撞边界
        let offsetX = roleNode.size.width * roleNode.anchorPoint.x
        let offsetY = roleNode.size.height * roleNode.anchorPoint.y
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 4 - offsetX, 12 - offsetY)
        CGPathAddLineToPoint(path, nil, 18 - offsetX, 23 - offsetY)
        CGPathAddLineToPoint(path, nil, 29 - offsetX, 29 - offsetY)
        CGPathAddLineToPoint(path, nil, 39 - offsetX, 19 - offsetY)
        CGPathAddLineToPoint(path, nil, 33 - offsetX, 1 - offsetY)
        CGPathAddLineToPoint(path, nil, 23 - offsetX, 0 - offsetY)
        CGPathAddLineToPoint(path, nil, 3 - offsetX, 3 - offsetY)
        CGPathCloseSubpath(path)
        
        roleNode.physicsBody = SKPhysicsBody(polygonFromPath: path)
        roleNode.physicsBody?.categoryBitMask = PhysicsLayer.gameRole
        roleNode.physicsBody?.collisionBitMask = 0
        roleNode.physicsBody?.contactTestBitMask = PhysicsLayer.barrier | PhysicsLayer.land
        
        hatNode.position = CGPoint(x: 31 - hatNode.size.width/2, y: 29 - hatNode.size.height/2)
        roleNode.addChild(hatNode)
        
        makeRoleWings()
        makeRoleBob()
    }

    
    //获取游戏角色node
    func getRoleNode() -> SKSpriteNode{
        return roleNode
    }
    
    
    //设置游戏角色
    func setSpeedOfRole(speed: CGPoint) {
        speedOfNow = speed
    }
    
    func makeRoleUp(){
        speedOfNow = self.speedOfTouched
        makeHatUp()
    }
    
    func makeHatUp(){
        let upAction = SKAction.moveByX(0, y: 12, duration: 0.15)
        upAction.timingMode = .EaseInEaseOut
        
        let downAction = upAction.reversedAction()
        hatNode.runAction(SKAction.sequence([upAction,downAction]))
    }
    
    func makeRoleWings(){
        var roleImages: Array<SKTexture> = []
        
        for i in 0..<numOfRoleImages{
            roleImages.append(SKTexture(imageNamed: "Bird\(i)"))
        }
        
        for i in (numOfRoleImages-1).stride(through: 0, by: -1){
            roleImages.append(SKTexture(imageNamed: "Bird\(i)"))
        }
        
        let wingAction = SKAction.animateWithTextures(roleImages, timePerFrame: 0.01)
        roleNode.runAction(SKAction.repeatActionForever(wingAction))
    }
    
    func makeRoleBob(){
        let upAction = SKAction.moveByX(0, y: 30, duration: 0.2)
        upAction.timingMode = .EaseInEaseOut
        
        let downAction = upAction.reversedAction()
        let bobAction = SKAction.sequence([upAction,downAction])
        
        roleNode.runAction(SKAction.repeatActionForever(bobAction), withKey: "gameRoleBob")
    
    }
    
    func stopRoleBob(){
        roleNode.removeActionForKey("gameRoleBob")
    }
    
    func updateRole(timeDiff: CGFloat, minHeight: CGFloat){
        
        roleNode.position = roleNode.position + speedOfNow * CGFloat(timeDiff) + accelerationOfGravity * CGFloat(timeDiff) * CGFloat(timeDiff) / 2
        
        //检测撞击地面时，让角色停在地面上
        if roleNode.position.y - roleNode.size.height/2 < minHeight {
            roleNode.position = CGPoint(x: roleNode.position.x, y: minHeight + roleNode.size.height/2)
            speedOfNow = CGPoint.zero
        } else {
            speedOfNow = speedOfNow + accelerationOfGravity * CGFloat(timeDiff)
        }

    
    }

    
}