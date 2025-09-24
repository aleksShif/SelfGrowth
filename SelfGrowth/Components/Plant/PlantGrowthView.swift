//
//  PlantGrowthView.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/18/25.
//

import SwiftUI
import SpriteKit

// UIViewControllerRepresentable - a wrapper that embeds my plantviewcontroller in a view. i can now use plantgrowthview as any other view
struct PlantGrowthView: UIViewControllerRepresentable {
    // Binding to track current growth stage by activities logged
    var activityCount: Int
    
    // Function to create the UIViewController
    func makeUIViewController(context: Context) -> PlantViewController {
        let controller = PlantViewController()
        
        // Set the completion handler
        controller.activityCount = activityCount
        
        // For Demo, 2nd stage
        // controller.activityCount = 6
        
        // For Demo, 3rd stage
        // controller.activityCount = 16
        
        // For Demo, 4th stage
//         controller.activityCount = 20
        
        return controller
    }
    
    // Function to update the UIViewController
    func updateUIViewController(_ uiViewController: PlantViewController, context: Context) {
        uiViewController.activityCount = activityCount
        
        // For Demo, 2nd stage
        // uiViewController.activityCount = 6
        
        // For Demo, 3rd stage
        // uiViewController.activityCount = 16
        
        // For Demo, 4th stage
//         uiViewController.activityCount = 20
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
