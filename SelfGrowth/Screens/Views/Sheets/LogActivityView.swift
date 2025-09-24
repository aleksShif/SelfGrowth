//
//  LogActivityView.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/14/25.
//

import SwiftUI
import SwiftData

struct LogActivityView: View {
    let activity: Activity
    @Binding var isPresented: Bool
    @Binding var duration: Int
    @Binding var description: String
    @ObservedObject var overlayState: OverlayState
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var activityLogs: [ActivityLog]
    
    private var isAtMilestone: Bool {
        let currentCount = activityLogs.count
        // # of activity logs is at the threshold for plant's stages 2, 3, or 4
        return currentCount == 5 || currentCount == 15 || currentCount == 20
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                let screenHeight = geometry.size.height
                let isSmallDevice = screenHeight < 700
                let contentPadding: CGFloat = isSmallDevice ? 10 : 16
                
                ScrollView {
                    VStack(alignment: .leading, spacing: isSmallDevice ? 8 : 10) {
                        // Activity Header
                        activityHeader(isSmallDevice: isSmallDevice)
                            .padding(.top, screenHeight * 0.05)
                            .padding(.bottom, isSmallDevice ? 5 : 10)
                        
                        // Duration Adjustment
                        durationSection(isSmallDevice: isSmallDevice, screenWidth: screenWidth)
                        
                        // Description Adjustment
                        descriptionSection(isSmallDevice: isSmallDevice, screenWidth: screenWidth)
                        
                        Spacer(minLength: isSmallDevice ? 15 : 30)
                        
                        // Action Buttons
                        actionButtons(isSmallDevice: isSmallDevice, screenWidth: screenWidth)
                    }
                    .padding(.horizontal, contentPadding)
                    .frame(minHeight: screenHeight * 0.8)
                }
                .navigationBarTitle("Log Activity", displayMode: .inline)
                .toolbarBackground(Color(#colorLiteral(red: 0.4514811635, green: 0.6588239074, blue: 0.4605069757, alpha: 1)), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .background(Color(#colorLiteral(red: 0.5906556249, green: 0.8661773801, blue: 0.599182725, alpha: 1)))
                .foregroundColor(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
            }
        }
        .presentationDetents([.medium])
    }
    
    // View Components
    
    private func activityHeader(isSmallDevice: Bool) -> some View {
        HStack {
            ZStack {
                Circle()
                    .fill(activity.colorOption.color)
                    .frame(width: isSmallDevice ? 40 : 50, height: isSmallDevice ? 40 : 50)
                
                Image(systemName: activity.icon)
                    .font(.system(size: isSmallDevice ? 20 : 24))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading) {
                Text(activity.name)
                    .font(isSmallDevice ? .title3 : .title2)
                    .fontWeight(.bold)
                
                Text("Ready to log your activity?")
                    .font(isSmallDevice ? .caption : .subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.leading, isSmallDevice ? 6 : 10)
        }
    }
    
    private func durationSection(isSmallDevice: Bool, screenWidth: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: isSmallDevice ? 6 : 10) {
            Text("Duration (minutes)")
                .font(isSmallDevice ? .subheadline : .headline)
            
            HStack {
                Button(action: {
                    if duration > 5 {
                        duration -= 5
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: isSmallDevice ? 24 : 30))
                        .foregroundColor(Color(#colorLiteral(red: 0.5081194639, green: 0.4898516536, blue: 0.7515105605, alpha: 1)))
                }
                
                Text("\(duration)")
                    .font(isSmallDevice ? .title2 : .title)
                    .frame(width: isSmallDevice ? 60 : 80)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    duration += 5
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: isSmallDevice ? 24 : 30))
                        .foregroundColor(Color(#colorLiteral(red: 0.5081194639, green: 0.4898516536, blue: 0.7515105605, alpha: 1)))
                }
            }
            .padding(isSmallDevice ? 10 : 16)
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.1)))
            .frame(maxWidth: screenWidth - 32) // Ensure proper width
            .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private func descriptionSection(isSmallDevice: Bool, screenWidth: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: isSmallDevice ? 4 : 8) {
            Text("Description (optional)")
                .font(isSmallDevice ? .subheadline : .headline)
            
            TextField("How was your activity?", text: $description)
                .padding(isSmallDevice ? 10 : 16)
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.1)))
                .frame(height: isSmallDevice ? 80 : 100)
                .frame(maxWidth: screenWidth) // Ensure proper width
        }
    }
    
    private func actionButtons(isSmallDevice: Bool, screenWidth: CGFloat) -> some View {
        HStack(spacing: isSmallDevice ? 8 : 12) {
            Button(action: {
                isPresented = false
            }) {
                Text("Cancel")
                    .fontWeight(.medium)
                    .font(isSmallDevice ? .callout : .body)
                    .padding(isSmallDevice ? 12 : 16)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
            }
            
            Button(action: {
                logActivity()
                
                if isAtMilestone {
                    overlayState.displayOverlay()
                }
                
                isPresented = false
            }) {
                Text("Log Activity")
                    .fontWeight(.bold)
                    .font(isSmallDevice ? .callout : .body)
                    .foregroundColor(.white)
                    .padding(isSmallDevice ? 12 : 16)
                    .frame(maxWidth: .infinity)
                    .background(Color(#colorLiteral(red: 0.5081194639, green: 0.4898516536, blue: 0.7515105605, alpha: 1)))
                    .cornerRadius(15)
            }
        }
        .frame(maxWidth: screenWidth) // Ensure proper width
    }
    
    // MARK: - Data Functions
    
    func logActivity() {
        // Create a new ActivityLog entry and attempt to add it to the list
        let activityLog = ActivityLog(
            activityId: activity.id,
            name: activity.name,
            duration: duration,
            activityDescription: description,
            category: activity.category,
            icon: activity.icon,
            colorOption: activity.colorOption
        )
        
        modelContext.insert(activityLog)
        
        try? modelContext.save()
        
        // Reset values
        description = activity.activityDescription
        duration = activity.duration
    }
}
