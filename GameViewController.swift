//
//  GameViewController.swift
//  FlappyBird
//
//  Created by 韩志峰 on 16/3/17.
//  Copyright (c) 2016年 Zhifeng Han. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController : UIViewController {

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let skView = self.view as? SKView {
            if skView.scene == nil {
                //创建场景
                let aspectRatio = skView.bounds.size.height / skView.bounds.size.width
                let scene = GameScene(size:CGSize(width: 320, height: 320 * aspectRatio))
                scene.scaleMode = .AspectFill
                
                //设置一些场景参数
                skView.showsFPS = true
                skView.showsNodeCount = true
                skView.showsPhysics = true
                skView.ignoresSiblingOrder = true
                
                //显示视图
                skView.presentScene(scene)
                
            }
        
        }
        
        
        
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}