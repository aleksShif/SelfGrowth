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
        ZStack {
            // Base large circle
            Circle()
                .fill(color)
                .frame(width: width * 0.5, height: height * 1.1)
                .offset(x: width * 0.05)
            
            // Left side circles
            Circle()
                .fill(color)
                .frame(width: width * 0.45, height: height * 0.9)
                .offset(x: -width * 0.2, y: height * 0.05)
            
            Circle()
                .fill(color)
                .frame(width: width * 0.3, height: height * 0.7)
                .offset(x: -width * 0.35, y: height * 0.1)
            
            // Right side circles
            Circle()
                .fill(color)
                .frame(width: width * 0.4, height: height * 0.8)
                .offset(x: width * 0.25, y: height * 0.05)
            
            Circle()
                .fill(color)
                .frame(width: width * 0.3, height: height * 0.6)
                .offset(x: width * 0.4, y: height * 0.1)
            
            // Top circles for fluffiness
            Circle()
                .fill(color)
                .frame(width: width * 0.35, height: height * 0.7)
                .offset(x: -width * 0.1, y: -height * 0.2)
            
            Circle()
                .fill(color)
                .frame(width: width * 0.3, height: height * 0.6)
                .offset(x: width * 0.15, y: -height * 0.25)
            
            // Bottom fill circles
            Circle()
                .fill(color)
                .frame(width: width * 0.4, height: height * 0.8)
                .offset(x: -width * 0.05, y: height * 0.2)
            
            Circle()
                .fill(color)
                .frame(width: width * 0.35, height: height * 0.7)
                .offset(x: width * 0.2, y: height * 0.15)
        }
        .frame(width: width, height: height)
    }
}

#Preview {
    CloudView(width: 120, height: 60, color: Color(#colorLiteral(red: 0.4756627083, green: 0.5513323545, blue: 0.8908587098, alpha: 1)))
}
