//
//  PlantView.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 4/9/25.
//

import SwiftUI

struct PlantView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ZStack {
                    // Main stem
                    Path { path in
                        path.move(to: CGPoint(x: 60, y: 200))
                        path.addCurve(
                            to: CGPoint(x: 60, y: 50),
                            control1: CGPoint(x: 60, y: 150),
                            control2: CGPoint(x: 90, y: 100)
                        )
                    }
                    .stroke(Color.green, lineWidth: 3)
                    
                    // Left leaf
                    Path { path in
                        path.move(to: CGPoint(x: 60, y: 120))
                        path.addCurve(
                            to: CGPoint(x: 30, y: 100),
                            control1: CGPoint(x: 50, y: 110),
                            control2: CGPoint(x: 35, y: 95)
                        )
                        path.addCurve(
                            to: CGPoint(x: 60, y: 120),
                            control1: CGPoint(x: 25, y: 110),
                            control2: CGPoint(x: 45, y: 125)
                        )
                    }
                    .fill(Color.green)
                    
                    // Right leaf
                    Path { path in
                        path.move(to: CGPoint(x: 60, y: 150))
                        path.addCurve(
                            to: CGPoint(x: 90, y: 140),
                            control1: CGPoint(x: 70, y: 145),
                            control2: CGPoint(x: 80, y: 135)
                        )
                        path.addCurve(
                            to: CGPoint(x: 60, y: 150),
                            control1: CGPoint(x: 95, y: 150),
                            control2: CGPoint(x: 75, y: 155)
                        )
                    }
                    .fill(Color.green)
                    
                    // Top leaf/bud
                    Path { path in
                        path.move(to: CGPoint(x: 60, y: 50))
                        path.addCurve(
                            to: CGPoint(x: 70, y: 30),
                            control1: CGPoint(x: 65, y: 45),
                            control2: CGPoint(x: 70, y: 40)
                        )
                        path.addCurve(
                            to: CGPoint(x: 60, y: 50),
                            control1: CGPoint(x: 75, y: 25),
                            control2: CGPoint(x: 65, y: 45)
                        )
                    }
                    .fill(Color.green)
                }
                Spacer()
                PotView()
                    .offset(y:75)
            }
        }
    }
}

struct PotView: View {
    var body: some View {
        ZStack {
            // Pot body
            Rectangle()
                .fill(Color.yellow)
                .frame(width: 80, height: 70)
            
            // Pot stripes
            VStack(spacing: 10) {
                ForEach(0..<3) { _ in
                    Rectangle()
                        .fill(Color.orange)
                        .frame(width: 80, height: 5)
                }
            }
            
            // Pot top edge
            Rectangle()
                .fill(Color.orange)
                .frame(width: 100, height: 10)
                .offset(y: -35)
        }
    }
}

#Preview {
    PlantView()
        .frame(width: 120, height: 200)
}
