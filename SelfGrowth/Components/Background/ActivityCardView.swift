//
//  ActivityCardView.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/14/25.
//

import SwiftUI
import SwiftData

enum ActiveSheet: Identifiable {
    case log, delete
    
    var id: Int {
        switch self {
        case .log: return 0
        case .delete: return 1
        }
    }
}

struct ActivityCardView: View {
    let activity: Activity
    @State private var activeSheet: ActiveSheet?
    @State private var isArrowPressed = false
    @State private var isTrashPressed = false
    @State private var logDuration: Int
    @State private var logDescription: String = ""
    
    init(activity: Activity) {
        self.activity = activity
        _logDuration = State(initialValue: activity.duration)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Activity card with icon
            ZStack {
                // Background with clouds
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(#colorLiteral(red: 0.2997636199, green: 0.6950053573, blue: 0.7074371576, alpha: 1)))
                
                // Center oval with icon
                ZStack {
                    Ellipse()
                        .fill(activity.colorOption.color)
                        .frame(width: 250, height: 120)
                        .rotationEffect(.degrees(10))
                    
                    Image(systemName: activity.icon)
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                }
                
                if activity.name == "Workout" {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 40, height: 40)
                        .position(x: 50, y: 40)
                    // Stars/sparkles
//                    ForEach(0..<10) { i in
//                        Image(systemName: "sparkle")
//                            .font(.system(size: 10))
//                            .foregroundColor(Color.purple.opacity(0.5))
//                            .position(
//                                x: CGFloat.random(in: 20...330),
//                                y: CGFloat.random(in: 20...130)
//                        )
//                    }
                    BranchShape()
                        .fill(Color.purple.opacity(0.8))
                        .frame(width: 330, height: 30)
                        .padding(.horizontal, -20)
                        .offset(x: 20, y: 45)
                }
                
                // Small clouds
                HStack {
                    CloudView(width: 60, height: 30, color: Color(#colorLiteral(red: 0.5906556249, green: 0.8661773801, blue: 0.599182725, alpha: 1)))
                        .offset(x: 10, y: -20)
                    
                    Spacer()
                    
                    CloudView(width: 50, height: 25, color: Color(#colorLiteral(red: 0.5906556249, green: 0.8661773801, blue: 0.599182725, alpha: 1)))
                        .offset(x: 120, y: -30)
                    
                    Spacer()
                    CloudView(width:40, height: 20, color: Color(#colorLiteral(red: 0.5906556249, green: 0.8661773801, blue: 0.599182725, alpha: 1)))
                        .offset(x: -10)
                }
            }
            .frame(height: 150)
            
            // Activity name and duration
            HStack {
                Text(activity.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
            }
            
            HStack {
                Text("\(activity.duration) MIN")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(isArrowPressed ? Color(#colorLiteral(red: 0.5081194639, green: 0.4898516536, blue: 0.7515105605, alpha: 1)) : .gray)
                    .scaleEffect(isArrowPressed ? 0.8 : 1.0)
                    .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isArrowPressed)
                    .padding(10) // Add padding to make tap target larger
                    .background(
                        Circle()
                            .fill(Color.gray.opacity(isArrowPressed ? 0.2 : 0.0))
                            .animation(.easeOut(duration: 0.2), value: isArrowPressed)
                    )
                    .gesture(
                        TapGesture()
                            .onEnded { _ in
                                // Start the press animation
                                isArrowPressed = true
                                
                                // Toggle dropdown after a short delay
                                withAnimation {
                                    activeSheet = .log
                                }
                                
                                // Reset the press animation after a short delay
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    isArrowPressed = false
                                }
                            }
                    )
                
                Image(systemName: isTrashPressed ? "trash.fill" : "trash")
                    .foregroundColor(isTrashPressed ? .red : .white)
                    .scaleEffect(isTrashPressed ? 0.8 : 1.0)
                    .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isTrashPressed)
                    .padding(10) // Add padding to make tap target larger
                    .background(
                        Circle()
                            .fill(Color.gray.opacity(isTrashPressed ? 0.2 : 0.0))
                            .animation(.easeOut(duration: 0.2), value: isTrashPressed)
                    )
                    .gesture(
                        TapGesture()
                            .onEnded { _ in
                                // Start the press animation
                                isTrashPressed = true
                                
                                // Toggle dropdown after a short delay
                                withAnimation {
                                    activeSheet = .delete
                                }
                                
                                // Reset the press animation after a short delay
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    isTrashPressed = false
                                }
                            }
                    )

            }
            .offset(y: -10)
        }
        .sheet(item: $activeSheet) { item in
            switch item {
            case .log:
                LogActivityView(activity: activity,
                                isPresented: Binding(
                                    get: {activeSheet == .log},
                                    set: {if !$0 {activeSheet = nil}}
                                ),
                                duration: $logDuration,
                                description: $logDescription)
            case .delete:
                DeleteActivityView(activity: activity,
                                   isPresented: Binding(
                                    get: {activeSheet == .delete},
                                    set: {if !$0 {activeSheet = nil}}
                                   ))
            }
        }
    }
}

#Preview {
    var activity = Activity(name: "Study Session", duration: 45, icon: "book", color: Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)), category: 2)
    ActivityCardView(activity: activity)
}
