//
//  PlantGrowthScene.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/18/25.
//

import SwiftUI
import SpriteKit

// SpriteKit Scene - importing my images, creating funcs for setting up scene and updating plant growth
class PlantGrowthScene: SKScene {
    
    // The plant sprite that will be animated
    private var plantSprite: SKSpriteNode!
    
    // Array to hold the growth stage textures
    private var growthStages: [SKTexture] = []
    
    private var currentStage: Int = 0
    
    // Progress within the current stage will be from 0.0 to 1.0
    private var stageProgress: CGFloat = 0.0
    
    override func didMove(to view: SKView) {
        setupScene()
        loadGrowthTextures()
        setupPlant()
    }
    
    private func setupScene() {
        backgroundColor = .clear
    }
    
    private func loadGrowthTextures() {
        // Load the textures for each growth stage
        let stage1 = SKTexture(imageNamed: "plant_stage1") // Seed in pot
        let stage2 = SKTexture(imageNamed: "plant_stage2") // Small sprout
        let stage3 = SKTexture(imageNamed: "plant_stage3") // Medium plant
        let stage4 = SKTexture(imageNamed: "plant_stage4") // Full-grown plant
        
        growthStages = [stage1, stage2, stage3, stage4]
    }
    
    private func setupPlant() {
        // Start with the first growth stage
        plantSprite = SKSpriteNode(texture: growthStages[0])
        plantSprite.position = CGPoint(x: frame.midX, y: frame.midY)
        plantSprite.setScale(0.5) // Adjust scale as needed
        addChild(plantSprite)
    }
    
    func updatePlantGrowth(activityCount: Int) {
        // milestones for each stage
        let milestones = [0, 5, 15, 20]
        let maxStage = milestones.count - 1
        
        // Determine current stage
        var newStage = 0
        for i in 1..<milestones.count {
            if activityCount >= milestones[i] {
                newStage = i
            }
        }
        
        // Calculate progress within current stage
        var progress: CGFloat = 0.0
        
        if newStage < maxStage {
            let stageMin = milestones[newStage]
            let stageMax = milestones[newStage + 1]
            let stageRange = stageMax - stageMin
            
            if stageRange > 0 {
                progress = CGFloat(activityCount - stageMin) / CGFloat(stageRange)
            }
        } else {
            // Final stage
            progress = 1.0
        }
        
        // Update the plant if stage changed
        if newStage != currentStage {
            // Change to the new texture
            let changeTexture = SKAction.setTexture(growthStages[newStage])
            
            plantSprite.run(SKAction.sequence([changeTexture]))
            
            currentStage = newStage
        }
        
        stageProgress = progress
    }

    // Get the current growth stage
    func getCurrentStage() -> Int {
        return currentStage
    }
    
    // Get the total number of growth stages
    func getTotalStages() -> Int {
        return growthStages.count
    }
}

// UIKit View Controller for SpriteKit - responsible for actually configuring the plant scene i developed, also a step in integrating my spritekit scene in my swiftui views
class PlantViewController: UIViewController {
    
    var plantScene: PlantGrowthScene!
    
    var activityCount: Int = 0 {
        didSet {
            plantScene?.updatePlantGrowth(activityCount: activityCount)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the SKView for displaying the scene
        let skView = SKView(frame: view.bounds)
        skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(skView)
        
        // Workaround for transparent background in the scene to counter how SK handles transparency
        skView.allowsTransparency = true
        skView.backgroundColor = .clear
        
        // Create and configure the scene
        plantScene = PlantGrowthScene(size: skView.bounds.size)
        plantScene.scaleMode = .aspectFill
        
        // Present the scene
        skView.presentScene(plantScene)
        
        plantScene.updatePlantGrowth(activityCount: activityCount)
    }
}

