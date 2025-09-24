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
        GeometryReader { geometry in
            ZStack {
                ZStack(alignment: .top) {
                    TopCloudView(color: topColor)
                    
                    ZStack(alignment: .top){
                        SunView()
                            .frame(width: min(100, geometry.size.width * 0.17), height:  min(100, geometry.size.width * 0.17))
                            .offset(x: -geometry.size.width * 0.3, y: geometry.size.height * 0.06)
                            .padding(.top)
                        // Cloud positioning - using relative positions based on screen dimensions
                        CloudView(
                            width: geometry.size.width * 0.2,
                            height: geometry.size.width * 0.15,
                            color: cloudColor
                        )
                        .position(
                            x: geometry.size.width * 0.8,
                            y: geometry.size.height * 0.15
                        )
                        
                        CloudView(
                            width: geometry.size.width * 0.2,
                            height: geometry.size.width * 0.12,
                            color: cloudColor
                        )
                        .position(
                            x: geometry.size.width * 0.2,
                            y: geometry.size.height * 0.25
                        )
                        
                        CloudView(
                            width: geometry.size.width * 0.18,
                            height: geometry.size.width * 0.1,
                            color: cloudColor
                        )
                        .position(
                            x: geometry.size.width * 0.7,
                            y: geometry.size.height * 0.28
                        )
                        
                        // Stars positioning - using relative positions
                        StarView(size: geometry.size.width * 0.025)
                            .position(
                                x: geometry.size.width * 0.15,
                                y: geometry.size.height * 0.2
                            )
                        
                        StarView(size: geometry.size.width * 0.02)
                            .position(
                                x: geometry.size.width * 0.85,
                                y: geometry.size.height * 0.28
                            )
                        
                        TwinklingStarView(size: geometry.size.width * 0.015, color: cloudColor)
                            .position(
                                x: geometry.size.width * 0.12,
                                y: geometry.size.height * 0.28
                            )
                        
                        StarView(size: geometry.size.width * 0.018)
                            .position(
                                x: geometry.size.width * 0.78,
                                y: geometry.size.height * 0.25
                            )
                        
                        TwinklingStarView(size: geometry.size.width * 0.012, color: cloudColor)
                            .position(
                                x: geometry.size.width * 0.16,
                                y: geometry.size.height * 0.25
                            )
                    }
                    .padding(.top)
                    .offset(y: -geometry.size.height * 0.10)
                }
                Spacer()
                
                .frame(width: geometry.size.width, height: geometry.size.height)
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
