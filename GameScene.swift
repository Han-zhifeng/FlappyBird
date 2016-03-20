//
//  GameScene.swift
//  FlappyBird
//
//  Created by 韩志峰 on 16/3/17.
//  Copyright (c) 2016年 Zhifeng Han. All rights reserved.
//

import SpriteKit


enum imageLayers: CGFloat {
    case background
    case barrier
    case landground
    case gameRole
}



class GameScene: SKScene {
    
    /* 游戏界面容器 */
    let worldZone = SKNode()
    /* 游戏角色 */
    let gameRole = SKSpriteNode(imageNamed: "Bird0")
    /* 游戏环境重力加速度 */
    let gravityAcceleration = CGPoint(x: 0, y: -1500.0)
    /* 点击屏幕角色上冲速度 */
    let upSpeedTouched = CGPoint(x: 0, y: 400.0)
    /* landGround区域数量 */
    let numOfLandGround: Int = 2
    /* landGround区域移动速度 */
    let speedOflandGroundMoves = CGPoint(x: -150.0, y: 0)
    /* 底部障碍高度相关：最小乘数 */
    let minMultiOfBottomBarrier: CGFloat = 0.1
    /* 底部障碍高度相关：最大乘数 */
    let maxMultiOfBottomBarrier: CGFloat = 0.6
    /* 障碍之间宽度相对于游戏角色的乘数 */
    let multiOfGameRoleToBarrier: CGFloat = 3.5
    /* 首次生成障碍延迟 */
    let firstMakeBarrierDelay: NSTimeInterval = 1.75
    /* 非首次生成障碍延迟 */
    let notFirstMakeBarrierDelay: NSTimeInterval = 1.5
    
    
    /* 音效：点击屏幕 */
    let soundFlap = SKAction.playSoundFileNamed("flapping.wav", waitForCompletion: false)
    
    
    /* 游戏区域起始点 */
    var startPointOfGameZone: CGFloat = 0
    /* 游戏区域高度 */
    var heightOfGameZone: CGFloat = 0
    /* 游戏帧上一次更新时间 */
    var lastUpdateTime: NSTimeInterval = 0
    /* 游戏帧之间时间差 */
    var timeDiff: NSTimeInterval = 0
    /* 游戏角色速度 */
    var gameRoleSpeed = CGPoint.zero
    
    
    /* Setup your scene here */
    override func didMoveToView(view: SKView) {
        addChild(worldZone)
        setBackground()
        setLandGround()
        setGameRole()
        keepShowBarrier()
    }
    
    /* Called when a touch begins */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        makeGameRoleUp()
        // 播放音效
        runAction(soundFlap)
    }
   
    /* Called before each frame is rendered */
    override func update(currentTime: CFTimeInterval) {
        if lastUpdateTime > 0 {
            timeDiff = currentTime - lastUpdateTime
        } else {
            timeDiff = 0
        }
        
        lastUpdateTime = currentTime
        updateGameRole()
        updateLandGround()
    }
    
    
    /* MARK : 游戏初始设置的相关方法 */
    //设置背景
    func setBackground(){
        let background = SKSpriteNode(imageNamed: "Background")
        
        background.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        background.position = CGPoint(x: size.width/2, y: size.height)
        background.zPosition = imageLayers.background.rawValue
        
        worldZone.addChild(background)
        
        startPointOfGameZone = size.height - background.size.height
        heightOfGameZone = background.size.height
    }
    
    //设置前景
    func setLandGround(){
        for i in 0..<numOfLandGround {
            let landround = SKSpriteNode(imageNamed: "Ground")
            
            landround.anchorPoint = CGPoint(x: 0, y: 1.0)
            landround.position = CGPoint(x: CGFloat(i) * landround.size.width, y: startPointOfGameZone)
            landround.zPosition = imageLayers.landground.rawValue
            landround.name = "landground"
            worldZone.addChild(landround)
        }
    }
    
    func updateLandGround(){
        worldZone.enumerateChildNodesWithName("landground", usingBlock: {matchItem, _ in
            if let landground = matchItem as? SKSpriteNode {
                landground.position += self.speedOflandGroundMoves * CGFloat(self.timeDiff)
                
                if landground.position.x <= -landground.size.width {
                    landground.position += CGPoint(x: landground.size.width * CGFloat(self.numOfLandGround), y: 0)
                }
                
            }
        
        })
    
    }
    
    
    //设置游戏角色
    func setGameRole() {
        gameRole.position = CGPoint(x: size.width * 0.2, y: startPointOfGameZone + heightOfGameZone * 0.4)
        gameRole.zPosition = imageLayers.gameRole.rawValue
        
        worldZone.addChild(gameRole)
    }
    
    
    
    /* MARK : 游戏界面更新的相关方法 */
    //更新游戏角色状态
    func updateGameRole() {
        gameRole.position = gameRole.position + gameRoleSpeed * CGFloat(timeDiff) + gravityAcceleration * CGFloat(timeDiff) * CGFloat(timeDiff) / 2
        
        //检测撞击地面时，让角色停在地面上
        if gameRole.position.y - gameRole.size.height/2 < startPointOfGameZone {
            gameRole.position = CGPoint(x: gameRole.position.x, y: startPointOfGameZone + gameRole.size.height/2)
            gameRoleSpeed = CGPoint.zero
        } else {
            gameRoleSpeed = gameRoleSpeed + gravityAcceleration * CGFloat(timeDiff)
        }
    }
    
    func makeGameRoleUp(){
        gameRoleSpeed = upSpeedTouched
    }
    
    func makeBarrier(imgName: String) -> SKSpriteNode {
        let barrier = SKSpriteNode(imageNamed: imgName)
        barrier.zPosition = imageLayers.barrier.rawValue
        return barrier;
    }
    
    func showBarrier(){
        let bottomBarrier = makeBarrier("CactusBottom")
        let startPointOfX: CGFloat = size.width + bottomBarrier.size.width/2;
        let minHeight = (startPointOfGameZone - bottomBarrier.size.height/2) + heightOfGameZone * minMultiOfBottomBarrier
        let maxHeight = (startPointOfGameZone - bottomBarrier.size.height/2) + heightOfGameZone * maxMultiOfBottomBarrier
        
        bottomBarrier.position = CGPoint(x: startPointOfX, y: CGFloat.random(min: minHeight, max: maxHeight))
        worldZone.addChild(bottomBarrier)
        
        
        let topBarrier = makeBarrier("CactusTop")
        topBarrier.zRotation = CGFloat(180).degreesToRadians()
        topBarrier.position = CGPoint(x: startPointOfX, y: bottomBarrier.position.y + bottomBarrier.size.height/2 + topBarrier.size.height/2 + gameRole.size.height * multiOfGameRoleToBarrier)
        worldZone.addChild(topBarrier)
        
        
        let moveDistanceOfX = -(size.width + bottomBarrier.size.width)
        let moveDuration = moveDistanceOfX / speedOflandGroundMoves.x
        let moveAction = SKAction.sequence([
                SKAction.moveByX(moveDistanceOfX, y: 0, duration: NSTimeInterval(moveDuration)),
                SKAction.removeFromParent()
            ])
        
        topBarrier.runAction(moveAction)
        bottomBarrier.runAction(moveAction)
        
    }
    
    func keepShowBarrier(){
        let firstShowDelay = SKAction.waitForDuration(firstMakeBarrierDelay)
        
        let showBarrier = SKAction.runBlock { () -> Void in
            self.showBarrier()
        }
        let notFirstShowDelay = SKAction.waitForDuration(notFirstMakeBarrierDelay)
        let keepShowBarrier = SKAction.sequence([showBarrier,notFirstShowDelay])
        let foreverShowBarrier = SKAction.repeatActionForever(keepShowBarrier)
        
        let allShowBarrier = SKAction.sequence([firstShowDelay,foreverShowBarrier])
        
        runAction(allShowBarrier)
        
    }
    

    
    
}
