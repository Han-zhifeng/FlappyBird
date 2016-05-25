//
//  GameScene.swift
//  FlappyBird
//
//  Created by 韩志峰 on 16/3/17.
//  Copyright (c) 2016年 Zhifeng Han. All rights reserved.
//

import SpriteKit
import Foundation


class GameScene: SKScene,SKPhysicsContactDelegate {
    
    /* 游戏界面容器 */
    let worldZone = SKNode()
    /* 游戏元素：角色*/
    let gameRole:GameRole
    /* 游戏元素：天空*/
    let gameSky:GameSky
    /* 游戏元素：大地*/
    let gameLand:GameLand
    /* 游戏元素：障碍物*/
    let gameBarrier:GameBarrier
    /* 游戏得分相关*/
    let gameScore:GameScore
    
    
    
    /* 游戏帧上一次更新时间 */
    var lastUpdateTime: NSTimeInterval = 0
    /* 游戏帧之间时间差 */
    var timeDiff: NSTimeInterval = 0
    /* 游戏角色是否撞击了地板 */
    var isHitLand: Bool = false
    /* 游戏角色是否撞击了障碍物 */
    var isHitBarrier: Bool = false
    /* 游戏状态，游戏界面的update和touch的反应都是根据该状态进行的 */
    var gameStatusNow: GameStatus = GameStatus.MainMenu
    
    /* 游戏页面逻辑控制器 */
    let controllerMainMenu: GameStatusMainMenu = GameStatusMainMenu()
    let controllerTutorial: GameStatusTutorial = GameStatusTutorial()
    let controllerRoleFly: GameControllerRoleFly = GameControllerRoleFly()
    let controllerRoleFall: GameControllerRoleFall = GameControllerRoleFall()
    let controllerShowScore: GameControllerShowScore = GameControllerShowScore()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size:CGSize) {
        
        //初始化游戏元素
        gameSky = GameSky(containerSize: size)
        gameLand = GameLand(initLandHeight: gameSky.startPoint.y)
        gameLand.landHeight = gameSky.startPoint.y
        gameRole = GameRole(containerSize: size, initPosition: CGPoint(x: size.width * 0.2, y: gameSky.startPoint.y + gameSky.height * 0.4))
        gameBarrier = GameBarrier()
        gameScore = GameScore(containerSize: size)
        
        super.init(size: size)
        
        //关掉重力
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
    
    }
    
    
    
    
    /* Setup your scene here */
    override func didMoveToView(view: SKView) {
        
        switch gameStatusNow {
            case GameStatus.MainMenu:
                controllerMainMenu.showIn(self)
            case GameStatus.Tutorial:
                controllerTutorial.showIn(self)
            default:
                print("no action")
        }

       
    }
    
    

    
    /* Called when a touch begins */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        switch gameStatusNow {
            case GameStatus.MainMenu:
                controllerMainMenu.touchesBeganIn(self, withTouches: touches, withEvent: event)
            case GameStatus.Tutorial:
                controllerTutorial.touchesBeganIn(self, withTouches: touches, withEvent: event)
            case GameStatus.RoleFly:
                controllerRoleFly.touchesBeganIn(self, withTouches: touches, withEvent: event)
            case GameStatus.ShowScore:
                controllerShowScore.touchesBeganIn(self, withTouches: touches, withEvent: event)
            default:
                print("no action")
        }
        
    }
   
    /* Called before each frame is rendered */
    override func update(currentTime: CFTimeInterval) {
            
        if lastUpdateTime > 0 {
            timeDiff = currentTime - lastUpdateTime
        } else {
            timeDiff = 0
        }
            
        lastUpdateTime = currentTime
            
        switch gameStatusNow {
            case GameStatus.RoleFly:
                controllerRoleFly.updateScene(self, onCurrentTime: nil)
            case GameStatus.RoleFall:
                    controllerRoleFall.updateScene(self, onCurrentTime: nil)
            case GameStatus.ShowScore:
                controllerShowScore.updateScene(self, onCurrentTime: nil)
            default:
                print("no update")
        }

    }
    
    
    //MARK: 物理引擎
    func didBeginContact(contact: SKPhysicsContact) {
        let roleHitBody = contact.bodyA.categoryBitMask == PhysicsLayer.gameRole ? contact.bodyB : contact.bodyA
        
        switch roleHitBody.categoryBitMask {
            case PhysicsLayer.land:
                isHitLand = true
            case PhysicsLayer.barrier:
                isHitBarrier = true
            default:
                print("nothing to do")
        }
        
    }
    
    
    //MARK: 重启游戏
    func restart(){
        runAction(GameSounds.pop)
        let newGameScene = GameScene.init(size:self.size)
        view?.presentScene(newGameScene)
    }
    

    

    
    
}
