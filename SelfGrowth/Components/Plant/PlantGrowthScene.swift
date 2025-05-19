import SwiftUI
import SpriteKit

// MARK: - Step 1: The SpriteKit Scene
class PlantGrowthScene: SKScene {
    
    // The plant sprite that will be animated
    private var plantSprite: SKSpriteNode!
    
    // Array to hold the growth stage textures
    private var growthStages: [SKTexture] = []
    
    private var currentStage: Int = 0
    
    private var growthMeter: SKShapeNode!
    private var growthFill: SKShapeNode!
    
    // Progress within the current stage will be from 0.0 to 1.0
    private var stageProgress: CGFloat = 0.0
    
    override func didMove(to view: SKView) {
        setupScene()
        loadGrowthTextures()
        setupPlant()
        setupGrowthMeter()
    }
    
    private func setupScene() {
        // Set up your scene background, etc.
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
    
    private func setupGrowthMeter() {
        let meterWidth: CGFloat = 200
        let meterHeight: CGFloat = 20
        
        growthMeter = SKShapeNode(rectOf: CGSize(width: meterWidth, height: meterHeight), cornerRadius: 10)
        growthMeter.position = CGPoint(x: frame.midX, y: frame.midY - 200) // Position below plant
        growthMeter.fillColor = .clear
        growthMeter.strokeColor = SKColor(red: 0.51, green: 0.49, blue: 0.75, alpha: 1.0) // Your purple color
        growthMeter.lineWidth = 2
        addChild(growthMeter)
        
        // Create the fill portion of the meter (shows progress)
        growthFill = SKShapeNode(rectOf: CGSize(width: 0, height: meterHeight - 4), cornerRadius: 8)
        growthFill.position = CGPoint(x: -meterWidth/2 + 2, y: 0) // Left-aligned within meter
        growthFill.fillColor = SKColor(red: 0.51, green: 0.49, blue: 0.75, alpha: 1.0) // Your purple color
        growthFill.strokeColor = .clear
//        growthFill.anchorPoint = CGPoint(x: 0, y: 0.5) // Anchor at left side
        growthMeter.addChild(growthFill)
    }
    
    func updatePlantGrowth(activityCount: Int) {
        // Define the milestones for each stage
        let milestones = [0, 5, 15, 20]
        let maxStage = milestones.count - 1
        let maxActivityCount = 20
        
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
            
            // Add a small scale increase animation
//            let scaleUp = SKAction.scale(by: 1.1, duration: 0.5)
//            let scaleDown = SKAction.scale(to: 1.0, duration: 0.3)
            
            plantSprite.run(SKAction.sequence([changeTexture]))
            
            currentStage = newStage
        }
        
        // Update progress meter
        updateGrowthMeter(progress)
        stageProgress = progress
    }
    
    private func updateGrowthMeter(_ progress: CGFloat) {
        let meterWidth: CGFloat = 200 - 4 // Total width minus padding
        let targetWidth = meterWidth * progress
        
        // Animate the meter fill
        let fillAction = SKAction.resize(toWidth: targetWidth, duration: 0.3)
        growthFill.run(fillAction)
    }
    
//    // Public method to start the growth animation
//    func startGrowthAnimation(growthDuration: TimeInterval = 10.0) {
//        // Calculate time per growth stage
//        let timePerStage = growthDuration / Double(growthStages.count - 1)
//        
//        var actions: [SKAction] = []
//        
//        // Create sequence of texture changes with delays between stages
//        for i in 1..<growthStages.count {
//            // Add a wait action before changing to the next stage
//            actions.append(SKAction.wait(forDuration: timePerStage))
//            
//            // Change to the next texture
//            actions.append(SKAction.setTexture(growthStages[i]))
//            
//            // Add a small scale increase for additional growth effect
//            let scaleUp = SKAction.scale(by: 1.1, duration: 0.3)
//            let scaleDown = SKAction.scale(to: 1.0, duration: 0.2)
//            actions.append(SKAction.sequence([scaleUp, scaleDown]))
//            
//            // Update current stage
//            let updateStage = SKAction.run { [weak self] in
//                self?.currentStage = i
//                self?.updateGrowthMeter(CGFloat(i) / CGFloat(self?.growthStages.count ?? 1 - 1))
//            }
//            actions.append(updateStage)
//        }
//        
//        // Run the complete growth sequence
//        plantSprite.run(SKAction.sequence(actions))
//    }
//    
//    // For interactive growth, call this to advance to the next stage
//    func advanceToNextStage() {
//        guard currentStage < growthStages.count - 1 else { return }
//        
//        // Move to next stage
//        currentStage += 1
//        
//        // Animate to next stage
//        let changeTexture = SKAction.setTexture(growthStages[currentStage])
////        let scaleUp = SKAction.scale(by: 1.1, duration: 0.3)
////        let scaleDown = SKAction.scale(to: 1.0, duration: 0.2)
//        
//        plantSprite.run(SKAction.sequence([changeTexture]))
//        
//        // Update progress meter
//        updateGrowthMeter(CGFloat(currentStage) / CGFloat(growthStages.count - 1))
//    }
    
    // Get the current growth stage
    func getCurrentStage() -> Int {
        return currentStage
    }
    
    // Get the total number of growth stages
    func getTotalStages() -> Int {
        return growthStages.count
    }
}

// MARK: - Step 2: UIKit View Controller for SpriteKit
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
        
        // Workaround for transparent background in the scene
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

