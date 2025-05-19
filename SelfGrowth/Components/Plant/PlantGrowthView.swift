//
//  PlantGrowthView.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/18/25.
//

import SwiftUI
import SpriteKit

// MARK: - Step 3: UIViewControllerRepresentable for SwiftUI Integration
struct PlantGrowthView: UIViewControllerRepresentable {
    // Binding to track current growth stage
    var activityCount: Int
    
    // Function to create the UIViewController
    func makeUIViewController(context: Context) -> PlantViewController {
        let controller = PlantViewController()
        
        // Set the completion handler
        controller.activityCount = activityCount
        
        return controller
    }
    
    // Function to update the UIViewController
    func updateUIViewController(_ uiViewController: PlantViewController, context: Context) {
        uiViewController.activityCount = activityCount
    }
    
    // Coordinator for handling callbacks and user interaction
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: PlantGrowthView
        
        init(_ parent: PlantGrowthView) {
            self.parent = parent
        }
    }
}
