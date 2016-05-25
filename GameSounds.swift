//
//  GameSounds.swift
//  FlappyBird
//
//  Created by 韩志峰 on 16/3/22.
//  Copyright © 2016年 Zhifeng Han. All rights reserved.
//

import SpriteKit

class GameSounds {
    
    /* 点击屏幕时的声音 */
    static let flap: SKAction = SKAction.playSoundFileNamed("flapping.wav", waitForCompletion: false)
    
    /* 撞击地面时的声音 */
    static let hitGround: SKAction = SKAction.playSoundFileNamed("hitGround.wav", waitForCompletion: false)
    
    /* 声音 */
    static let pop: SKAction = SKAction.playSoundFileNamed("pop.wav", waitForCompletion: false)
    
    /* 声音 */
    static let whack: SKAction = SKAction.playSoundFileNamed("whack.wav", waitForCompletion: false)
    
    /* 得分的声音 */
    static let coin: SKAction = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false)
    
    /* 声音 */
    static let ding: SKAction = SKAction.playSoundFileNamed("ding.wav", waitForCompletion: false)
    
    /* 声音 */
    static let falling: SKAction = SKAction.playSoundFileNamed("falling.wav", waitForCompletion: false)
    

}
