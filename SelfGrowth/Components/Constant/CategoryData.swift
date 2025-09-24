//
//  CategoryData.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/13/25.
//

import SwiftUI

// Category model
struct Category {
    let name: String
    let icon: String
    let color: Color
}

struct CategoryData {
    // IMMUTABLE list of categories
    static let categories = [
        Category(name: "All", icon: "plus", color: Color(#colorLiteral(red: 0.3820864856, green: 0.6893107295, blue: 0.9856509566, alpha: 1))),
        Category(name: "School", icon: "heart", color: Color(#colorLiteral(red: 0.3820864856, green: 0.6893107295, blue: 0.9856509566, alpha: 1))),
        Category(name: "Fitness", icon: "figure.walk", color: Color(#colorLiteral(red: 0.3820864856, green: 0.6893107295, blue: 0.9856509566, alpha: 1))),
        Category(name: "Mindfulness", icon: "moon.zzz", color: Color(#colorLiteral(red: 0.3820864856, green: 0.6893107295, blue: 0.9856509566, alpha: 1))),
        Category(name: "Hobbies", icon: "gamecontroller", color: Color(#colorLiteral(red: 0.3820864856, green: 0.6893107295, blue: 0.9856509566, alpha: 1)))
    ]
}
