//
//  TrackView.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 4/10/25.
//

import SwiftUI
import SwiftData

struct TrackView: View {
    @Binding var selectedTab: Int
    
    @StateObject private var trackViewModel = TrackViewModel()
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let isSmallDevice = screenHeight < 700
            
            ZStack() {
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
                    
                    VStack(spacing: isSmallDevice ? 15 : 30) {
                        // Header Section
                        headerSection(screenWidth: screenWidth, isSmallDevice: isSmallDevice)
                        
                        // Category filter
                        categorySection(screenWidth: screenWidth, isSmallDevice: isSmallDevice)
                        
                        // Activity list
                        activitySection(screenWidth: screenWidth, screenHeight: screenHeight, isSmallDevice: isSmallDevice)
                    }
                    
                    // Custom tab bar
                    CustomTabBarView(selectedTab: $selectedTab)
                    
                }
                if trackViewModel.overlayState.showOverlay {
                    GrowthMilestoneCelebrationView(total: trackViewModel.activitiesLog.count)
                    .zIndex(10)
                    .onAppear{ print("growthmilestone shown!")}
                }
            }
            .sheet(isPresented: $trackViewModel.isAddingActivity, onDismiss: {
                trackViewModel.fetchData()
            }) {
                AddActivityView(categories: trackViewModel.categories)
            }
            .onAppear{
                trackViewModel.setContextIfNeeded(context)
            }
        }
    }
    
    // View Components
    
    private func headerSection(screenWidth: CGFloat, isSmallDevice: Bool) -> some View {
        ZStack(alignment: .top) {
            // Header
            VStack(alignment: .center, spacing: isSmallDevice ? 2 : 4) {
                Text("Your Activity")
                    .font(isSmallDevice ? .title2 : .title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("What are you doing today?")
                    .font(isSmallDevice ? .caption : .subheadline)
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(.top, isSmallDevice ? 20 : 40)
            .frame(width: screenWidth)
        }
    }
    
    private func categorySection(screenWidth: CGFloat, isSmallDevice: Bool) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: isSmallDevice ? 10 : 15) {
                ForEach(0..<trackViewModel.categories.count, id: \.self) { index in
                    CategoryButtonView(
                        category: trackViewModel.categories[index],
                        isSelected: trackViewModel.selectedCategory == index,
                        isSmallDevice: isSmallDevice
                    )
                    .onTapGesture {
                        trackViewModel.selectedCategory = index
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, isSmallDevice ? 5 : 10)
        }
        .background(Color(#colorLiteral(red: 0.4720982313, green: 0.8328886628, blue: 0.9776143432, alpha: 0)))
        .frame(width: screenWidth)
    }
    
    private func activitySection(screenWidth: CGFloat, screenHeight: CGFloat, isSmallDevice: Bool) -> some View {
        ScrollView {
            LazyVStack(spacing: isSmallDevice ? 15 : 20) {
                ForEach(trackViewModel.filteredActivities) { activity in
                    ActivityCardView(activity: activity, overlayState: trackViewModel.overlayState, viewModel: trackViewModel)
                        .frame(width: screenWidth * 0.9) // Make cards consistently sized
                }
                
                Button(action: {trackViewModel.isAddingActivity=true})
                {
                    HStack{
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: isSmallDevice ? 16 : 20))
                        Text("Add New Activity")
                            .fontWeight(.semibold)
                            .font(isSmallDevice ? .callout : .body)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(isSmallDevice ? 10 : 16)
                    .background(Color(#colorLiteral(red: 0.5081194639, green: 0.4898516536, blue: 0.7515105605, alpha: 1)))
                    .cornerRadius(15)
                }
                .padding(.bottom, screenHeight * 0.1)
                .frame(width: screenWidth * 0.9) // Make button consistently sized
            }
            .padding()
        }
    }
}

struct CategoryButtonView: View {
    let category: Category
    let isSelected: Bool
    let isSmallDevice: Bool
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(isSelected ? category.color : Color(#colorLiteral(red: 0.5081194639, green: 0.4898516536, blue: 0.7515105605, alpha: 1)))
                    .frame(width: isSmallDevice ? 50 : 60, height: isSmallDevice ? 50 : 60)
                
                Image(systemName: category.icon)
                    .font(.system(size: isSmallDevice ? 20 : 24))
                    .foregroundColor(.white)
            }
            
            Text(category.name)
                .font(isSmallDevice ? .caption2 : .caption)
                .foregroundColor(isSelected ? Color(#colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1)) : .gray)
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

struct TrackView_Previews: PreviewProvider {
    @State static var selectedTab = 1
    
    static var previews: some View {
        TrackView(selectedTab: $selectedTab)
    }
}
