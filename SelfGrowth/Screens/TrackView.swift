//
//  TrackView.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 4/10/25.
//


import SwiftUI

struct TrackView: View {
    @State private var selectedTab = 1 // Track tab selected
    @State private var selectedCategory = 0 // "All" category selected by default
    
    // Sample activity data
    let activities = [
        Activity(name: "Study Session", duration: 45, icon: "book", color: Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)), category: 1),
        Activity(name: "Workout", duration: 45, icon: "dumbbell", color: Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.7647058964, alpha: 1)), category: 2),
        Activity(name: "Meditation", duration: 15, icon: "moon.zzz", color: Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), category: 3)
    ]
    
    // Category data
    let categories = [
        Category(name: "All", icon: "plus", color: Color(#colorLiteral(red: 0.3820864856, green: 0.6893107295, blue: 0.9856509566, alpha: 1))),
        Category(name: "School", icon: "heart", color: Color(#colorLiteral(red: 0.3820864856, green: 0.6893107295, blue: 0.9856509566, alpha: 1))),
        Category(name: "Fitness", icon: "figure.walk", color: Color(#colorLiteral(red: 0.3820864856, green: 0.6893107295, blue: 0.9856509566, alpha: 1))),
        Category(name: "Mindfulness", icon: "moon.zzz", color: Color(#colorLiteral(red: 0.3820864856, green: 0.6893107295, blue: 0.9856509566, alpha: 1))),
        Category(name: "Hobbies", icon: "gamecontroller", color: Color(#colorLiteral(red: 0.3820864856, green: 0.6893107295, blue: 0.9856509566, alpha: 1)))
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)), Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            // Main content
            ZStack(alignment: .bottom) {
                // Top section with clouds and title
                SkyBackgroundView(topColor: Color(#colorLiteral(red: 0.4756627083, green: 0.5513323545, blue: 0.8908587098, alpha: 1)), cloudColor: Color(#colorLiteral(red: 0.5906556249, green: 0.8661773801, blue: 0.599182725, alpha: 1)))
                
                VStack(spacing: 30) {
                    ZStack(alignment: .top) {
                        // Header
                        VStack(alignment: .center, spacing: 4) {
                            Text("Your Activity")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("What are you doing today?")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.top, 40)
                    }
                    // Category filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(0..<categories.count, id: \.self) { index in
                                CategoryButtonView(
                                    category: categories[index],
                                    isSelected: selectedCategory == index
                                )
                                .onTapGesture {
                                    selectedCategory = index
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    }
                    .background(Color(#colorLiteral(red: 0.4720982313, green: 0.8328886628, blue: 0.9776143432, alpha: 0)))
                    
                    // Activity list
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(filteredActivities) { activity in
                                ActivityCardView(activity: activity)
                            }
                        }
                        .padding()
                    }
                }
                // Custom tab bar
//                CustomTabBarView(selectedTab: $selectedTab)
            }
        }
    }
    
    // Filter activities based on selected category
    var filteredActivities: [Activity] {
        if selectedCategory == 0 {
            return activities
        } else {
            return activities.filter { $0.category == selectedCategory }
        }
    }
}

struct CategoryButtonView: View {
    let category: Category
    let isSelected: Bool
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(isSelected ? category.color : Color(#colorLiteral(red: 0.5081194639, green: 0.4898516536, blue: 0.7515105605, alpha: 1)))
                    .frame(width: 60, height: 60)
                
                Image(systemName: category.icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }
            
            Text(category.name)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct ActivityCardView: View {
    let activity: Activity
    
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
                        .fill(activity.color)
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
                    .foregroundColor(.gray)
            }
        }
    }
}

// Custom shape for branch
struct BranchShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Starting point - left side
        path.move(to: CGPoint(x: 0, y: rect.height * 0.5))
        
        // Main branch path points for later reference
        var pathPoints: [CGPoint] = []
        let segments = 100
        
        // First wave
        path.addCurve(
            to: CGPoint(x: rect.width * 0.25, y: rect.height * 0.6),
            control1: CGPoint(x: rect.width * 0.05, y: rect.height * 0.3),
            control2: CGPoint(x: rect.width * 0.15, y: rect.height * 0.7)
        )
        
        // Generate points along this curve for offshoot placement
        appendPointsAlongCurve(
            from: CGPoint(x: 0, y: rect.height * 0.5),
            to: CGPoint(x: rect.width * 0.25, y: rect.height * 0.6),
            control1: CGPoint(x: rect.width * 0.05, y: rect.height * 0.3),
            control2: CGPoint(x: rect.width * 0.15, y: rect.height * 0.7),
            points: &pathPoints,
            segments: segments/4
        )
        
        // Second wave
        path.addCurve(
            to: CGPoint(x: rect.width * 0.5, y: rect.height * 0.4),
            control1: CGPoint(x: rect.width * 0.35, y: rect.height * 0.5),
            control2: CGPoint(x: rect.width * 0.4, y: rect.height * 0.3)
        )
        
        appendPointsAlongCurve(
            from: CGPoint(x: rect.width * 0.25, y: rect.height * 0.6),
            to: CGPoint(x: rect.width * 0.5, y: rect.height * 0.4),
            control1: CGPoint(x: rect.width * 0.35, y: rect.height * 0.5),
            control2: CGPoint(x: rect.width * 0.4, y: rect.height * 0.3),
            points: &pathPoints,
            segments: segments/4
        )
        
        // Third wave
        path.addCurve(
            to: CGPoint(x: rect.width * 0.75, y: rect.height * 0.55),
            control1: CGPoint(x: rect.width * 0.6, y: rect.height * 0.5),
            control2: CGPoint(x: rect.width * 0.65, y: rect.height * 0.65)
        )
        
        appendPointsAlongCurve(
            from: CGPoint(x: rect.width * 0.5, y: rect.height * 0.4),
            to: CGPoint(x: rect.width * 0.75, y: rect.height * 0.55),
            control1: CGPoint(x: rect.width * 0.6, y: rect.height * 0.5),
            control2: CGPoint(x: rect.width * 0.65, y: rect.height * 0.65),
            points: &pathPoints,
            segments: segments/4
        )
        
        // Last wave to the right edge
        path.addCurve(
            to: CGPoint(x: rect.width, y: rect.height * 0.45),
            control1: CGPoint(x: rect.width * 0.85, y: rect.height * 0.45),
            control2: CGPoint(x: rect.width * 0.95, y: rect.height * 0.35)
        )
        
        appendPointsAlongCurve(
            from: CGPoint(x: rect.width * 0.75, y: rect.height * 0.55),
            to: CGPoint(x: rect.width, y: rect.height * 0.45),
            control1: CGPoint(x: rect.width * 0.85, y: rect.height * 0.45),
            control2: CGPoint(x: rect.width * 0.95, y: rect.height * 0.35),
            points: &pathPoints,
            segments: segments/4
        )
        
        // Complete the shape by adding lines to the bottom corners
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        // Add wavy offshoots along the branch
        addWavyOffshoots(to: &path, alongPoints: pathPoints, in: rect)
        
        return path
    }
    
    // Helper function to calculate points along a cubic Bezier curve
    func appendPointsAlongCurve(from p0: CGPoint, to p3: CGPoint, control1 p1: CGPoint, control2 p2: CGPoint, points: inout [CGPoint], segments: Int) {
        for i in 0..<segments {
            let t = CGFloat(i) / CGFloat(segments)
            let point = calculateBezierPoint(t: t, p0: p0, p1: p1, p2: p2, p3: p3)
            points.append(point)
        }
    }
    
    func calculateBezierPoint(t: CGFloat, p0: CGPoint, p1: CGPoint, p2: CGPoint, p3: CGPoint) -> CGPoint {
        let oneMinusT = 1 - t
        let oneMinusT2 = oneMinusT * oneMinusT
        let oneMinusT3 = oneMinusT2 * oneMinusT
        let t2 = t * t
        let t3 = t2 * t
        
        let x = oneMinusT3 * p0.x + 3 * oneMinusT2 * t * p1.x + 3 * oneMinusT * t2 * p2.x + t3 * p3.x
        let y = oneMinusT3 * p0.y + 3 * oneMinusT2 * t * p1.y + 3 * oneMinusT * t2 * p2.y + t3 * p3.y
        
        return CGPoint(x: x, y: y)
    }
    
    // Add wavy offshoots that come out from the branch
    func addWavyOffshoots(to path: inout Path, alongPoints points: [CGPoint], in rect: CGRect) {
        // Only add offshoots at certain intervals
        let offshootCount = 12
        let step = points.count / offshootCount
        
        for i in stride(from: step, to: points.count - 1, by: step) {
            let startPoint = points[i]
            
            // Determine if offshoot goes up or to the side
            let goesUp = i % 3 != 0
            
            // Create wavy offshoots
            path.move(to: startPoint)
            
            // Randomize length and direction
            let length: CGFloat = CGFloat.random(in: 10...25)
            let width: CGFloat = CGFloat.random(in: 5...15) * (i % 4 == 0 ? -1 : 1)
            
            var endPoint: CGPoint
            var control1: CGPoint
            var control2: CGPoint
            
            if goesUp {
                // Offshoot goes up with a wavy pattern
                endPoint = CGPoint(x: startPoint.x + width, y: startPoint.y - length)
                control1 = CGPoint(x: startPoint.x - width/2, y: startPoint.y - length/3)
                control2 = CGPoint(x: startPoint.x + width, y: startPoint.y - length*0.6)
            } else {
                // Offshoot curls to the side
                endPoint = CGPoint(x: startPoint.x + width, y: startPoint.y - length/2)
                control1 = CGPoint(x: startPoint.x + width/3, y: startPoint.y - length)
                control2 = CGPoint(x: startPoint.x + width*0.7, y: startPoint.y - length*0.7)
            }
            
            path.addCurve(to: endPoint, control1: control1, control2: control2)
            
            // Add a small additional curve to some offshoots for variety
            if i % 4 == 0 {
                let extraEndPoint = CGPoint(x: endPoint.x + width*0.5, y: endPoint.y - length*0.3)
                let extraControl1 = CGPoint(x: endPoint.x, y: endPoint.y - length*0.2)
                let extraControl2 = CGPoint(x: endPoint.x + width*0.3, y: endPoint.y - length*0.3)
                
                path.addCurve(to: extraEndPoint, control1: extraControl1, control2: extraControl2)
            }
        }
    }
}

// Activity model
struct Activity: Identifiable {
    let id = UUID()
    let name: String
    let duration: Int
    let icon: String
    let color: Color
    let category: Int
}

// Category model
struct Category {
    let name: String
    let icon: String
    let color: Color
}

struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView()
    }
}
