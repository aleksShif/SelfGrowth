//
//  TopCloudView.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 4/9/25.
//

import SwiftUI

// Custom view for the top cloud background
struct TopCloudView: View {
    var color: Color
    var body: some View {
        ZStack(alignment: .top) {
            // Main cloud background
            Rectangle()
                .fill(color)
                .frame(height: 200)
                .edgesIgnoringSafeArea(.top)
            
            GeometryReader { geometry in
                HStack(spacing: -20) {
                    ForEach(0..<3) { i in
                        Circle()
                            .fill(color)
                            .frame(width: 60, height: 60)
                            .offset(y: 165 - CGFloat(i))
                    }
                }
                .frame(width: geometry.size.width + 40)
                .offset(x: -199) // Adjust to ensure it covers the full width
            }
            
            GeometryReader { geometry in
                HStack(spacing: -20) {
                    ForEach(0..<4) { i in
                        Circle()
                            .fill(color)
                            .frame(width: 60, height: 60)
                            .offset(y: 140 - CGFloat(i))
                    }
                }
                .frame(width: geometry.size.width + 40)
                .offset(x: -130) // Adjust to ensure it covers the full width
            }
            
            // Cloud bottom edge
            GeometryReader { geometry in
                HStack(spacing: -20) {
                    ForEach(0..<10) { i in
                        Circle()
                            .fill(color)
                            .frame(width: 60, height: 60)
                            .offset(y: i.isMultiple(of: 2) ? 120 : 110)
                    }
                }
                .frame(width: geometry.size.width + 40)
                .offset(x: -20) // Adjust to ensure it covers the full width
            }
        }
    }
}

#Preview {
    TopCloudView(color: Color(#colorLiteral(red: 0.3312124014, green: 0.6746367216, blue: 0.8522820473, alpha: 1)))
}
