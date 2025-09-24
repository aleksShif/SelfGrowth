//
//  CardStyle.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/19/25.
//

import SwiftUI

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(#colorLiteral(red: 0.5906556249, green: 0.8661773801, blue: 0.599182725, alpha: 1)))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardStyle())
    }
}
