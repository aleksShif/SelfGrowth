//
//  SkyBackgroundView.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 4/9/25.
//

import SwiftUI

struct SkyBackgroundView: View {
    var topColor: Color
    var cloudColor: Color
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content
            VStack(spacing: 65) {
                ZStack(alignment: .top) {
                    TopCloudView(color:topColor)
                    
                    SunView()
                        .offset(x: -130, y: -20)
                    
                    CloudView(width: 120, height: 60, color: cloudColor)
                        .offset(x: 120, y: -20)
                    
                    CloudView(width: 90, height: 45, color: cloudColor)
                        .offset(x: -120, y: 70)
                    
                    CloudView(width: 70, height: 35, color: cloudColor)
                        .offset(x: 70, y: 100)
                    
                    StarView(size: 10)
                        .offset(x: -170, y: 40)
                    
                    StarView(size: 8)
                        .offset(x: 160, y: 90)
                    
                    TwinklingStarView(size: 6, color: cloudColor)
                        .offset(x: -180, y: 90)
                    
                    StarView(size: 7)
                        .offset(x: 130, y: 70)
                    
                    TwinklingStarView(size: 5, color: cloudColor)
                        .offset(x: -160, y: 70)
                    
                }
            }
        }
    }
}

struct StarView: View {
    var size: CGFloat
    var color: Color = Color(#colorLiteral(red: 0.8, green: 0.8, blue: 0.95, alpha: 1))
    
    var body: some View {
        CustomStarShape()
            .fill(color)
            .frame(width: size, height: size)
    }
}

struct CustomStarShape: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.4
        
        var path = Path()
        let points = 5
        
        for i in 0..<points * 2 {
            let radius = i.isMultiple(of: 2) ? outerRadius : innerRadius
            let angle = Double(i) * .pi / Double(points)
            let x = center.x + CGFloat(cos(angle)) * radius
            let y = center.y + CGFloat(sin(angle)) * radius
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        path.closeSubpath()
        return path
    }
}

struct TwinklingStarView: View {
    var size: CGFloat
    var color: Color = Color(#colorLiteral(red: 0.8, green: 0.8, blue: 0.95, alpha: 1))
    @State private var opacity: Double = 0.7
    
    var body: some View {
        Image(systemName: "star.fill")
            .font(.system(size: size))
            .foregroundColor(color)
            .opacity(opacity)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    opacity = 1.0
                }
            }
    }
}

#Preview {
    SkyBackgroundView(topColor: Color(#colorLiteral(red: 0.3312124014, green: 0.6746367216, blue: 0.8522820473, alpha: 1)), cloudColor: Color(#colorLiteral(red: 0.4756627083, green: 0.5513323545, blue: 0.8908587098, alpha: 1)))
}
