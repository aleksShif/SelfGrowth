//
//  TopCloudView.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 4/9/25.
//

import SwiftUI

struct TopCloudView: View {
    var color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(color)
                    .frame(height: min(200, geometry.size.height * 0.3))
                    .edgesIgnoringSafeArea(.top)
                
                // Relative circle sizes based on screen's width and height
                let circleSize = min(60, geometry.size.width * 0.15)
                let cloudBottomPosition = min(200, geometry.size.height * 0.18)
                
                // First row of circles
                HStack(spacing: -circleSize * 0.3) {
                    ForEach(0..<Int(ceil(geometry.size.width / (circleSize * 0.7)))) { i in
                        Circle()
                            .fill(color)
                            .frame(width: circleSize, height: circleSize)
                            .offset(y: cloudBottomPosition - circleSize * 0.5 - CGFloat(i % 2) * 5)
                    }
                }
                .frame(width: geometry.size.width + circleSize)
                .offset(x: -circleSize / 2)
                
                // NOTE: will implement this after finals because it's not looking good with different screen sizes right now
                
//                // extra row of circles on the left of screen
//                HStack(spacing: -circleSize * 0.3) {
//                    ForEach(0..<Int(ceil(geometry.size.width / (circleSize)))) { i in
//                        Circle()
//                            .fill(color)
//                            .frame(width: circleSize, height: circleSize)
//                            .offset(y: cloudBottomPosition - circleSize / 25 + circleSize * 0.30 - 8*CGFloat(i))
//                    }
//                }
//                .frame(width: geometry.size.width + circleSize)
//                .offset(x: -circleSize * 3, y: circleSize / 1.3)
//                
                
                // Second row of circles
                HStack(spacing: -circleSize * 0.3) {
                    ForEach(0..<Int(ceil(geometry.size.width / (circleSize * 0.7)))) { i in
                        Circle()
                            .fill(color)
                            .frame(width: circleSize, height: circleSize)
                            .offset(y: cloudBottomPosition - circleSize * 0.8 - CGFloat(i % 3) * 7)
                    }
                }
                .frame(width: geometry.size.width + circleSize)
                .offset(x: -circleSize / 2)
                
                // Cloud bottom edge with alternating heights for natural look
                HStack(spacing: -circleSize * 0.3) {
                    ForEach(0..<Int(ceil(geometry.size.width / (circleSize * 0.7))) + 1) { i in
                        Circle()
                            .fill(color)
                            .frame(width: circleSize, height: circleSize)
                            .offset(y: cloudBottomPosition - (i.isMultiple(of: 2) ? 0 : circleSize * 0.15))
                    }
                }
                .frame(width: geometry.size.width + circleSize)
                .offset(x: -circleSize / 2)
            }
        }
    }
}

#Preview {
    TopCloudView(color: Color(#colorLiteral(red: 0.3312124014, green: 0.6746367216, blue: 0.8522820473, alpha: 1)))
}
