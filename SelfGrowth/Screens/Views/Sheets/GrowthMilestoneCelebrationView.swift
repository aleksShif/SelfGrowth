//
//  GrowthMilestoneCelebration.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/19/25.
//

import SwiftUI

struct GrowthMilestoneCelebrationView: View {
    let total: Int
//    let onDismiss: () -> Void
    
    private var stageTitle: String {
        if total == 5 {
            return "Your plant sprouted!"
        } else if total == 15 {
            return "Your plant is growing!"
        } else if total == 20 {
            return "Your plant is flourishing!"
        } else {
            return "Growth milestone reached!"
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
//                    onDismiss()
                }
            
            VStack(spacing: 20) {
                // Icon
                Image(systemName: "leaf.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.green)
                
                // Title
                Text(stageTitle)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                // Activity count
                Text("\(total) activities logged!")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.9))
                
                // Mini plant preview
                if UIImage(named: "plant_stage\(plantStage)") != nil {
                    Image("plant_stage\(plantStage)")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                } else {
                    // Fallback leaf icon if images aren't available yet
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.green)
                        .padding()
                }
                
                // Message
                Text("Check out your home tab to see your plant!")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(red: 0.1, green: 0.3, blue: 0.1))
            )
            .padding(30)
        }
        .zIndex(10)
        .animation(.spring, value: true)
    }
    
    private var plantStage: Int {
        if total >= 20 { return 4 }
        else if total >= 15 { return 3 }
        else if total >= 5 { return 2 }
        else { return 1 }
    }
}

#Preview {
    GrowthMilestoneCelebrationView(total: 20)
}
