//
//  GameScene.swift
//  SliceAndDice
//
//  Created by Prudhvi Gadiraju on 4/26/19.
//  Copyright © 2019 Prudhvi Gadiraju. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // MARK: - Properties
    
    var score: Int = 0
    var lives: Int = 3
    var livesSpriteArray = [SKSpriteNode]()
    var activeSlicePoints = [CGPoint]()
    var isSwooshSoundActive = false
    
    // MARK: - Elements
    
    var activeSliceBG: SKShapeNode!
    var activeSliceFG: SKShapeNode!
    
    var scoreLabel: SKLabelNode = {
        let l = SKLabelNode(fontNamed: "Chalkduster")
        l.text = "Score: 0"
        l.horizontalAlignmentMode = .left
        l.fontSize = 48
        return l
    }()
    
    //M MARK: - Init
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupGravity()
        
        createScore()
        createLives()
        createSlices()
    }

    
    // MARK: - Touch
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSlicePoints.removeAll(keepingCapacity: true)
        guard let touchLocation = touches.first?.location(in: self) else { return }
        activeSlicePoints.append(touchLocation)
        redrawActiveSlice()
        
        activeSliceBG.removeAllActions()
        activeSliceFG.removeAllActions()
        
        activeSliceBG.alpha = 1
        activeSliceFG.alpha = 1
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocation = touches.first?.location(in: self) else { return }
        activeSlicePoints.append(touchLocation)
        redrawActiveSlice()
        
        if !isSwooshSoundActive {
            playSwooshSound()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let fadeAction = SKAction.fadeOut(withDuration: 0.25)
        
        activeSliceFG.run(fadeAction)
        activeSliceBG.run(fadeAction)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    // MARK: - Update
    
    override func update(_ currentTime: TimeInterval) {
    }
    
    func createScore() {
        addChild(scoreLabel)
        scoreLabel.position = CGPoint(x: 12, y: 48)
    }
    
    func redrawActiveSlice() {
        if activeSlicePoints.count < 2 {
            activeSliceBG.path = nil
            activeSliceFG.path = nil
            return
        }
        
        while activeSlicePoints.count > 12 {
            activeSlicePoints.remove(at: 0)
        }
        
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        
        for i in 1 ..< activeSlicePoints.count {
            path.addLine(to: activeSlicePoints[i])
        }
        
        activeSliceBG.path = path.cgPath
        activeSliceFG.path = path.cgPath
    }
    
    func createLives() {
        for i in 0 ..< 3 {
            let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
            spriteNode.position = CGPoint(x: 834 + ( i * 70 ), y: 700)
            addChild(spriteNode)
            livesSpriteArray.append(spriteNode)
        }
    }
    
    func createSlices() {
        activeSliceBG = SKShapeNode()
        activeSliceBG.zPosition = 2
        
        activeSliceFG = SKShapeNode()
        activeSliceFG.zPosition = 2
        
        activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
        activeSliceBG.lineWidth = 9
        
        activeSliceFG.strokeColor = UIColor.white
        activeSliceFG.lineWidth = 5
        
        addChild(activeSliceBG)
        addChild(activeSliceFG)
    }
    
    func playSwooshSound() {
        isSwooshSoundActive = true
        
        let randomSwoosh = Int.random(in: 1...3)
        let swooshName = "swoosh\(randomSwoosh).caf"
        let swooshAction = SKAction.playSoundFileNamed(swooshName, waitForCompletion: true)

        run(swooshAction) { [unowned self] in
            self.isSwooshSoundActive = false
        }
    }
}


// MARK: - Setup Functions
extension GameScene {
    
    fileprivate func setupGravity() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85
    }
    
    fileprivate func setupBackground() {
        let background = SKSpriteNode(imageNamed: "sliceBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
    }
}
