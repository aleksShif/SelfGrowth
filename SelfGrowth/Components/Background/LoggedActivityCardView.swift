//
//  LoggedActivityCardView.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/13/25.
//

import SwiftUI

struct LoggedActivityCardView: View {
    let activity: ActivityLog
    @State private var showingDropdown = false
    @State private var isArrowPressed = false
    
    @State private var logDuration: Int
    @State private var logDate: Date
    @State private var logDescription: String
    
    init(activity: ActivityLog) {
        self.activity = activity
        _logDuration = State(initialValue: activity.duration)
        _logDate = State(initialValue: activity.dateCompleted)
        _logDescription = State(initialValue: activity.activityDescription)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(#colorLiteral(red: 0.4816817045, green: 0.5471228361, blue: 0.8951389194, alpha: 1)))
                
                ZStack {
                    Ellipse()
                        .fill(activity.colorOption.color)
                        .frame(width: 250, height: 120)
                        .rotationEffect(.degrees(10))
                    
                    Image(systemName: activity.icon)
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                }
                
                if activity.category == 2 {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 40, height: 40)
                        .position(x: 50, y: 30)
                    // Stars/sparkles
                    ForEach(0..<10) { i in
                        Image(systemName: "sparkle")
                            .font(.system(size: 10))
                            .foregroundColor(Color.purple.opacity(0.5))
                            .position(
                                x: CGFloat.random(in: 20...330),
                                y: CGFloat.random(in: 20...130)
                        )
                    }

                }
                
                // Small clouds
                HStack {
                    CloudView(width: 60, height: 30, color: Color(#colorLiteral(red: 0.5906556249, green: 0.8661773801, blue: 0.599182725, alpha: 1)))
                        .offset(x: 10, y: -40)
                    
                    CloudView(width: 50, height: 20, color: Color(#colorLiteral(red: 0.5906556249, green: 0.8661773801, blue: 0.599182725, alpha: 1)))
                        .offset(x: -60, y: 10)
                    
                    CloudView(width: 50, height: 15, color: Color(#colorLiteral(red: 0.5906556249, green: 0.8661773801, blue: 0.599182725, alpha: 1)))
                        .offset(x: -80, y: 40)
                    
                    CloudView(width: 50, height: 25, color: Color(#colorLiteral(red: 0.5906556249, green: 0.8661773801, blue: 0.599182725, alpha: 1)))
                        .offset(x: 120, y: -50)
                    
                    Spacer()
                    
                    CloudView(width:40, height: 20, color: Color(#colorLiteral(red: 0.5906556249, green: 0.8661773801, blue: 0.599182725, alpha: 1)))
                        .offset(x: 30)
                    
                    CloudView(width: 40, height: 20, color: Color(#colorLiteral(red: 0.5906556249, green: 0.8661773801, blue: 0.599182725, alpha: 1)))
                        .offset(x: -40, y: 40)
                    
                    
                }
            }
            .frame(height: 150)
            
            HStack {
                Text(activity.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                Image(systemName: showingDropdown ? "chevron.up" :"chevron.down")
                    .foregroundColor(isArrowPressed ? Color(#colorLiteral(red: 0.5081194639, green: 0.4898516536, blue: 0.7515105605, alpha: 1)) : .gray)
                    .scaleEffect(isArrowPressed ? 0.8 : 1.0)
                    .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isArrowPressed)
                    .padding(10)
                    .background(
                        Circle()
                            .fill(Color.gray.opacity(isArrowPressed ? 0.2 : 0.0))
                            .animation(.easeOut(duration: 0.2), value: isArrowPressed)
                    )
                    .gesture(
                        TapGesture()
                            .onEnded { _ in
                                isArrowPressed = true
                                
                                withAnimation {
                                    showingDropdown.toggle()
                                }
                                
                                // delay before animation ends
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    isArrowPressed = false
                                }
                            }
                    )
            }
        
            if showingDropdown {
                VStack(alignment: .leading, spacing: 15) {
                    Divider()
                        .background(Color.gray.opacity(0.5))
                        .padding(.vertical, 5)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Date Logged")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text(logDate.formatted(date: .abbreviated, time: .shortened))
                            .padding(10)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Duration")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text("\(logDuration) minutes")
                            .padding(10)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Notes")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text(logDescription)
                            .padding(10)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding(.top, 5)
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.spring(), value: showingDropdown)
            }
        }
        .cardStyle()
    }
   
}


#Preview {
    var activity = Activity(name: "Study Session", duration: 45, icon: "book", color: Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)), category: 2)
    var activityLog = ActivityLog(activityId: activity.id, name: activity.name, duration: activity.duration, description: "hi", category: activity.category, icon: activity.icon, color: activity.color)
    LoggedActivityCardView(activity: activityLog)
}
