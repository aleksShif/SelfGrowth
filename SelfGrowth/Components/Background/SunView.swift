//
//  SunView.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 4/9/25.
//

import SwiftUI

struct SunView: View {
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.yellow.opacity(0.9),  // Brighter center
                        Color.orange                // Darker edges
                    ]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 30  // Half the width of your sun
                )
            )
            .frame(width: 60, height: 60)
    }
}

#Preview {
    SunView()
}
