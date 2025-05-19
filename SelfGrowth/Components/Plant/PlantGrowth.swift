////
////  PlantGrowth.swift
////  SelfGrowth
////
////  Created by Sasha Shifrina on 5/14/25.
////
//
//import SwiftUI
//import SceneKit
//import SwiftData
//
//// MARK: - Plant Growth Constants
//struct PlantGrowth {
//    // Growth configuration
//    static let maxGrowthStages = 5  // Total number of plant growth stages
//    static let pointsPerStage = 10  // Points needed to advance to next stage
//    
//    // Plant 3D model file names (stored in Assets.scarmaterial)
//    static let plantModelNames = [
//        "plant_seedling",  // Stage 0
//        "plant_sprout",    // Stage 1
//        "plant_small",     // Stage 2
//        "plant_medium",    // Stage 3
//        "plant_mature"     // Stage 4 (final)
//    ]
//}
//
//// MARK: - Plant Growth Manager
//class PlantGrowthManager: ObservableObject {
//    @Published var currentStage: Int = 0
//    @Published var currentGrowthPoints: Int = 0
//    @Published var isGrowing: Bool = false
//    
//    private let growthKey = "plantGrowthData"
//    
//    init() {
//        loadGrowthData()
//    }
//    
//    // Add points for completing activities
//    func addGrowthPoints(_ points: Int) {
//        currentGrowthPoints += points
//        
//        // Check if plant should advance to next stage
//        if currentGrowthPoints >= PlantGrowth.pointsPerStage {
//            growToNextStage()
//        } else {
//            // Save without growing
//            saveGrowthData()
//        }
//    }
//    
//    // Advance to next growth stage with animation flag
//    private func growToNextStage() {
//        // Only grow if not at max stage
//        if currentStage < PlantGrowth.maxGrowthStages - 1 {
//            isGrowing = true
//            
//            // Reset growth points
//            currentGrowthPoints = currentGrowthPoints - PlantGrowth.pointsPerStage
//            
//            // After a small delay to allow animation to start
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                // Advance stage
//                self.currentStage += 1
//                self.saveGrowthData()
//                
//                // After animation completes
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                    self.isGrowing = false
//                }
//            }
//        } else {
//            // At max stage, just reset points to max
//            currentGrowthPoints = PlantGrowth.pointsPerStage
//            saveGrowthData()
//        }
//    }
//    
//    // Save growth data to UserDefaults
//    private func saveGrowthData() {
//        let data = [
//            "stage": currentStage,
//            "points": currentGrowthPoints
//        ]
//        UserDefaults.standard.set(data, forKey: growthKey)
//    }
//    
//    // Load growth data from UserDefaults
//    private func loadGrowthData() {
//        if let data = UserDefaults.standard.dictionary(forKey: growthKey) {
//            currentStage = data["stage"] as? Int ?? 0
//            currentGrowthPoints = data["points"] as? Int ?? 0
//        }
//    }
//}
//
//// MARK: - Plant Scene View
//struct PlantSceneView: UIViewRepresentable {
//    @ObservedObject var growthManager: PlantGrowthManager
//    
//    func makeUIView(context: Context) -> SCNView {
//        let sceneView = SCNView()
//        sceneView.scene = createScene()
//        sceneView.backgroundColor = .clear
//        sceneView.autoenablesDefaultLighting = true
//        sceneView.allowsCameraControl = false
//        
//        return sceneView
//    }
//    
//    func updateUIView(_ sceneView: SCNView, context: Context) {
//        if let scene = sceneView.scene {
//            // Find the plant node
//            if let plantNode = scene.rootNode.childNode(withName: "plantNode", recursively: true) {
//                // Update to current plant model
//                updatePlantModel(plantNode: plantNode)
//                
//                // If growing, animate the plant
//                if growthManager.isGrowing {
//                    animatePlantGrowth(plantNode: plantNode)
//                }
//            }
//        }
//    }
//    
//    private func createScene() -> SCNScene {
//        let scene = SCNScene()
//        
//        // Create camera
//        let cameraNode = SCNNode()
//        cameraNode.camera = SCNCamera()
//        cameraNode.position = SCNVector3(x: 0, y: 1.5, z: 5)
//        scene.rootNode.addChildNode(cameraNode)
//        
//        // Create plant node
//        let plantNode = SCNNode()
//        plantNode.name = "plantNode"
//        scene.rootNode.addChildNode(plantNode)
//        
//        // Add initial plant model
//        updatePlantModel(plantNode: plantNode)
//        
//        // Add lighting
//        let ambientLightNode = SCNNode()
//        ambientLightNode.light = SCNLight()
//        ambientLightNode.light!.type = .ambient
//        ambientLightNode.light!.color = UIColor(white: 0.5, alpha: 1.0)
//        scene.rootNode.addChildNode(ambientLightNode)
//        
//        let directionalLightNode = SCNNode()
//        directionalLightNode.light = SCNLight()
//        directionalLightNode.light!.type = .directional
//        directionalLightNode.light!.color = UIColor(white: 0.8, alpha: 1.0)
//        directionalLightNode.position = SCNVector3(x: 5, y: 5, z: 5)
//        directionalLightNode.eulerAngles = SCNVector3(x: -Float.pi/4, y: Float.pi/4, z: 0)
//        scene.rootNode.addChildNode(directionalLightNode)
//        
//        return scene
//    }
//    
//    private func updatePlantModel(plantNode: SCNNode) {
//        // Remove existing plant geometry
//        plantNode.childNodes.forEach { $0.removeFromParentNode() }
//        
//        // Get model name for current stage
//        let modelIndex = min(growthManager.currentStage, PlantGrowth.plantModelNames.count - 1)
//        let modelName = PlantGrowth.plantModelNames[modelIndex]
//        
//        // Load model scene
//        if let modelScene = SCNScene(named: "\(modelName).scn") {
//            // Add all nodes from the model to our plant node
//            modelScene.rootNode.childNodes.forEach { node in
//                plantNode.addChildNode(node.clone())
//            }
//        } else {
//            // Fallback to a simple geometry if model not found
//            let geometry = SCNCylinder(radius: 0.1, height: 0.3 * CGFloat(growthManager.currentStage + 1))
//            let material = SCNMaterial()
//            material.diffuse.contents = UIColor.green
//            geometry.materials = [material]
//            
//            let geometryNode = SCNNode(geometry: geometry)
//            geometryNode.position.y = Float(geometry.height / 2)
//            plantNode.addChildNode(geometryNode)
//        }
//    }
//    
//    private func animatePlantGrowth(plantNode: SCNNode) {
//        // Scale animation
//        let scaleAnimation = CABasicAnimation(keyPath: "scale")
//        scaleAnimation.fromValue = NSValue(scnVector3: SCNVector3(x: 0.8, y: 0.8, z: 0.8))
//        scaleAnimation.toValue = NSValue(scnVector3: SCNVector3(x: 1.0, y: 1.0, z: 1.0))
//        scaleAnimation.duration = 1.5
//        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
//        
//        // Rotation animation
//        let rotationAnimation = CABasicAnimation(keyPath: "eulerAngles.y")
//        rotationAnimation.fromValue = 0
//        rotationAnimation.toValue = Float.pi * 2
//        rotationAnimation.duration = 2.0
//        
//        // Glow effect animation
//        let glowAnimation = CABasicAnimation(keyPath: "filters.emission.intensity")
//        glowAnimation.fromValue = 0.8
//        glowAnimation.toValue = 0.0
//        glowAnimation.duration = 2.0
//        
//        // Apply animations
//        plantNode.addAnimation(scaleAnimation, forKey: "growPlant")
//        plantNode.addAnimation(rotationAnimation, forKey: "rotatePlant")
//    }
//}
//
//// MARK: - Plant Progress View
//struct PlantProgressView: View {
//    @ObservedObject var growthManager: PlantGrowthManager
//    
//    var body: some View {
//        VStack {
//            ZStack(alignment: .bottom) {
//                // Plant scene
//                PlantSceneView(growthManager: growthManager)
//                    .frame(height: 300)
//                
//                // Growth meter
//                VStack {
//                    ProgressBar(progress: progress)
//                        .frame(height: 12)
//                        .padding(.horizontal, 40)
//                    
//                    Text("Growth: \(growthManager.currentGrowthPoints)/\(PlantGrowth.pointsPerStage)")
//                        .font(.caption)
//                        .foregroundColor(.white)
//                        .padding(.bottom, 10)
//                }
//            }
//            
//            if growthManager.currentStage >= PlantGrowth.maxGrowthStages - 1 {
//                Text("🎉 Your plant is fully grown! 🎉")
//                    .font(.headline)
//                    .foregroundColor(.green)
//                    .padding()
//            } else {
//                Text("Stage \(growthManager.currentStage + 1) of \(PlantGrowth.maxGrowthStages)")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//            
//            // Debug buttons - remove in production
//            HStack {
//                Button("Add Point") {
//                    growthManager.addGrowthPoints(1)
//                }
//                .buttonStyle(.bordered)
//                
//                Button("Full Growth") {
//                    growthManager.addGrowthPoints(PlantGrowth.pointsPerStage)
//                }
//                .buttonStyle(.bordered)
//            }
//            .padding()
//        }
//    }
//    
//    private var progress: Double {
//        Double(growthManager.currentGrowthPoints) / Double(PlantGrowth.pointsPerStage)
//    }
//}
//
//// MARK: - Progress Bar
//struct ProgressBar: View {
//    var progress: Double
//    
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack(alignment: .leading) {
//                // Background
//                Rectangle()
//                    .foregroundColor(.gray.opacity(0.3))
//                    .cornerRadius(5)
//                
//                // Progress
//                Rectangle()
//                    .foregroundColor(.green)
//                    .cornerRadius(5)
//                    .frame(width: geometry.size.width * CGFloat(progress))
//                    .animation(.easeInOut, value: progress)
//            }
//        }
//    }
//}
