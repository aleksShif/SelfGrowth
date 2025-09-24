//
//  GrowthProgressPanel.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/18/25.
//

import SwiftUI

// Growth Progress Panel View - reflects activities logged and plant's progress to next growth stage
struct GrowthProgressPanelView: View {
    var activityCount: Int
    
    // Calculate stage and progress
    var currentStage: Int {
        if activityCount >= 20 { return 3 }
        else if activityCount >= 15 { return 2 }
        else if activityCount >= 5 { return 1 }
        else { return 0 }
    }
    
    var nextMilestone: Int {
        switch currentStage {
        case 0: return 5
        case 1: return 15
        case 2: return 20
        default: return 20
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text(stageTitle)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.51, green: 0.49, blue: 0.75))
            
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color(red: 0.45, green: 0.66, blue: 0.46))
                Text("\(activityCount) activities logged")
                    .fontWeight(.medium)
            }
            
            if currentStage < 3 {
                Text("\(nextMilestone - activityCount) more to reach next stage")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                Text("Fully grown! Great job!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            // Progress bar
            ProgressView(value: progressValue)
                .progressViewStyle(GrowthProgressStyle())
        }
        .padding()
        .padding(.horizontal)
    }
    
    // Helper computed properties
    private var stageTitle: String {
        switch currentStage {
        case 0: return "Tiny Seed"
        case 1: return "Small Sprout"
        case 2: return "Growing Plant"
        case 3: return "Flourishing Plant"
        default: return "Plant"
        }
    }
    
    private var progressValue: Double {
        if currentStage == 3 { return 1.0 }
        
        let previousMilestone: Int
        switch currentStage {
        case 0: previousMilestone = 0
        case 1: previousMilestone = 5
        case 2: previousMilestone = 15
        default: previousMilestone = 0
        }
        
        let range = nextMilestone - previousMilestone
        return Double(activityCount - previousMilestone) / Double(range)
    }
}

// Custom Progress Style - this is what accounts for ratio of completed/uncompleted progress bar
struct GrowthProgressStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 0.45, green: 0.66, blue: 0.46))
                    .frame(width: (configuration.fractionCompleted ?? 0) * geometry.size.width)
            }
        }
        .frame(height: 12)
    }
}
