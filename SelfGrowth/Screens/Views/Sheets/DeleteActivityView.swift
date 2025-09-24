//
//  DeleteActivityView.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/14/25.
//

import SwiftUI
import SwiftData

struct DeleteActivityView: View {
    let activity: Activity
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: TrackViewModel
    @Environment(\.modelContext) private var modelContext
    
    // Animation state
    @State private var isShaking = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                let screenHeight = geometry.size.height
                let isSmallDevice = screenHeight < 700
                let contentPadding: CGFloat = isSmallDevice ? 10 : 16
                
                ScrollView {
                    VStack(spacing: isSmallDevice ? 15 : 25) {
                        // Warning section with icon and text
                        warningSection(isSmallDevice: isSmallDevice, screenWidth: screenWidth, contentPadding: contentPadding)
                        
                        // Warning description
                        warningDescription(isSmallDevice: isSmallDevice, screenWidth: screenWidth, contentPadding: contentPadding)
                        
                        // Activity preview card
                        activityPreviewCard(isSmallDevice: isSmallDevice, screenWidth: screenWidth, contentPadding: contentPadding)
                        
                        Spacer(minLength: isSmallDevice ? 15 : 30)
                        
                        // Action buttons
                        actionButtons(isSmallDevice: isSmallDevice, screenWidth: screenWidth, contentPadding: contentPadding)
                    }
                    .padding(.horizontal, contentPadding)
                    .frame(minHeight: screenHeight * 0.8)
                }
                .navigationBarTitle("Delete Activity", displayMode: .inline)
                .toolbarBackground(Color(#colorLiteral(red: 0.4514811635, green: 0.6588239074, blue: 0.4605069757, alpha: 1)), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .background(Color(#colorLiteral(red: 0.5906556249, green: 0.8661773801, blue: 0.599182725, alpha: 1)))
                .foregroundColor(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
            }
        }
        .presentationDetents([.medium])
    }
    
    // View Components
    
    private func warningSection(isSmallDevice: Bool, screenWidth: CGFloat, contentPadding: CGFloat) -> some View {
        HStack(alignment: .center, spacing: isSmallDevice ? 10 : 15) {
            // Warning icon
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.1))
                    .frame(width: isSmallDevice ? 60 : 80, height: isSmallDevice ? 60 : 80)
                
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: isSmallDevice ? 30 : 40))
                    .foregroundColor(.red)
                    .rotationEffect(.degrees(isShaking ? 5 : -5))
                    .animation(
                        Animation.easeInOut(duration: 0.1)
                            .repeatCount(5, autoreverses: true),
                        value: isShaking
                    )
                    .onAppear {
                        isShaking = true
                    }
            }
            .padding(.top, isSmallDevice ? 50 : 70)
            
            // Warning text
            Text("Are you sure you want to delete \"\(activity.name)\"?")
                .fixedSize(horizontal: false, vertical: true)
                .font(isSmallDevice ? .subheadline : .headline)
                .multilineTextAlignment(.leading)
                .padding(.top, isSmallDevice ? 50 : 70)
        }
        .frame(width: screenWidth - (contentPadding * 2))
    }
    
    private func warningDescription(isSmallDevice: Bool, screenWidth: CGFloat, contentPadding: CGFloat) -> some View {
        Text("This will permanently remove this activity and you won't be able to log it anymore. This action cannot be undone. Previously logged entries will remain unchanged.")
            .fixedSize(horizontal: false, vertical: true)
            .font(isSmallDevice ? .caption : .subheadline)
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .padding(.horizontal, contentPadding)
            .frame(width: screenWidth - (contentPadding * 2))
    }
    
    private func activityPreviewCard(isSmallDevice: Bool, screenWidth: CGFloat, contentPadding: CGFloat) -> some View {
        HStack(spacing: isSmallDevice ? 10 : 15) {
            ZStack {
                Circle()
                    .fill(activity.color)
                    .frame(width: isSmallDevice ? 40 : 50, height: isSmallDevice ? 40 : 50)
                
                Image(systemName: activity.icon)
                    .font(.system(size: isSmallDevice ? 20 : 24))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading) {
                Text(activity.name)
                    .font(isSmallDevice ? .callout : .headline)
                    .foregroundColor(.primary)
                
                Text("\(activity.duration) minutes")
                    .font(isSmallDevice ? .caption : .subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(isSmallDevice ? 10 : 16)
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.1)))
        .frame(width: screenWidth - (contentPadding * 2))
    }
    
    private func actionButtons(isSmallDevice: Bool, screenWidth: CGFloat, contentPadding: CGFloat) -> some View {
        HStack(spacing: isSmallDevice ? 10 : 15) {
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
                viewModel.deleteActivity(activity, context: modelContext)
                isPresented = false
            }) {
                Text("Delete")
                    .fontWeight(.bold)
                    .font(isSmallDevice ? .callout : .body)
                    .foregroundColor(.white)
                    .padding(isSmallDevice ? 12 : 16)
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(15)
            }
        }
        .frame(width: screenWidth - (contentPadding * 2))
    }
    
    // Not used anymore. Instead uses trackviewmodel func to delete the activity since this view is ultimately embedded in trackview
    func deleteActivity() {
        // Attempt to delete the activity
        modelContext.delete(activity)
        
        try? modelContext.save()
    }
}
