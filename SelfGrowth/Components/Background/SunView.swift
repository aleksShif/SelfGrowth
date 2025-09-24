//
//  SunView.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 4/9/25.
//

import SwiftUI

struct SunView: View {
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.yellow.opacity(0.9),  // Brighter center
                            Color.orange                // Darker edges
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.5  // Scale radius with size
                    )
                )
                .frame(width: size, height: size)
                .position(x: geometry.size.width/2, y: geometry.size.height/2)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    SunView()
        .frame(width: 100, height: 100)
}
