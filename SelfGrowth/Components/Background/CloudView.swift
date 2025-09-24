//
//  CloudView.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 4/9/25.
//

import SwiftUI

struct CloudView: View {
    var width: CGFloat
    var height: CGFloat
    var color: Color = Color(#colorLiteral(red: 0.8, green: 0.8, blue: 0.95, alpha: 1))
    
    var body: some View {
        GeometryReader { geometry in
            let actualWidth = min(width, geometry.size.width)
            let actualHeight = min(height, geometry.size.height)
            
            ZStack {
                Circle()
                    .fill(color)
                    .frame(
                        width: actualWidth * 0.5,
                        height: actualHeight * 1.1
                    )
                    .position(
                        x: geometry.size.width * 0.5 + (actualWidth * 0.05),
                        y: geometry.size.height * 0.5
                    )
                
                Circle()
                    .fill(color)
                    .frame(
                        width: actualWidth * 0.45,
                        height: actualHeight * 0.9
                    )
                    .position(
                        x: geometry.size.width * 0.5 - (actualWidth * 0.2),
                        y: geometry.size.height * 0.5 + (actualHeight * 0.05)
                    )
                
                Circle()
                    .fill(color)
                    .frame(
                        width: actualWidth * 0.3,
                        height: actualHeight * 0.7
                    )
                    .position(
                        x: geometry.size.width * 0.5 - (actualWidth * 0.35),
                        y: geometry.size.height * 0.5 + (actualHeight * 0.1)
                    )
                
                Circle()
                    .fill(color)
                    .frame(
                        width: actualWidth * 0.4,
                        height: actualHeight * 0.8
                    )
                    .position(
                        x: geometry.size.width * 0.5 + (actualWidth * 0.25),
                        y: geometry.size.height * 0.5 + (actualHeight * 0.05)
                    )
                
                Circle()
                    .fill(color)
                    .frame(
                        width: actualWidth * 0.3,
                        height: actualHeight * 0.6
                    )
                    .position(
                        x: geometry.size.width * 0.5 + (actualWidth * 0.4),
                        y: geometry.size.height * 0.5 + (actualHeight * 0.1)
                    )
                
                Circle()
                    .fill(color)
                    .frame(
                        width: actualWidth * 0.35,
                        height: actualHeight * 0.7
                    )
                    .position(
                        x: geometry.size.width * 0.5 - (actualWidth * 0.1),
                        y: geometry.size.height * 0.5 - (actualHeight * 0.2)
                    )
                
                Circle()
                    .fill(color)
                    .frame(
                        width: actualWidth * 0.3,
                        height: actualHeight * 0.6
                    )
                    .position(
                        x: geometry.size.width * 0.5 + (actualWidth * 0.15),
                        y: geometry.size.height * 0.5 - (actualHeight * 0.25)
                    )
                
                Circle()
                    .fill(color)
                    .frame(
                        width: actualWidth * 0.4,
                        height: actualHeight * 0.8
                    )
                    .position(
                        x: geometry.size.width * 0.5 - (actualWidth * 0.05),
                        y: geometry.size.height * 0.5 + (actualHeight * 0.2)
                    )
                
                Circle()
                    .fill(color)
                    .frame(
                        width: actualWidth * 0.35,
                        height: actualHeight * 0.7
                    )
                    .position(
                        x: geometry.size.width * 0.5 + (actualWidth * 0.2),
                        y: geometry.size.height * 0.5 + (actualHeight * 0.15)
                    )
            }
        }
        .frame(width: width, height: height)
    }
}

#Preview {
    CloudView(width: 120, height: 60, color: Color(#colorLiteral(red: 0.4756627083, green: 0.5513323545, blue: 0.8908587098, alpha: 1)))
}
