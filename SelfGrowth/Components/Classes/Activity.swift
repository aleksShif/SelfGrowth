//
//  Activity.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/11/25.


import SwiftUI
import SwiftData

// defining color options outside the model to reliably counter SwiftData color handling
enum ActivityColorOption: Int, CaseIterable {
    case yellow = 0
    case teal = 1
    case purple = 2
    case pink = 3
    case green = 4
    
    var color: Color {
        switch self {
        case .yellow: return Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))
        case .teal: return Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.7647058964, alpha: 1))
        case .purple: return Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
        case .pink: return Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))
        case .green: return Color(#colorLiteral(red: 0.4500938654, green: 0.8412100673, blue: 0.6149917841, alpha: 1))
        }
    }
    
    // Helper to find fitting color option
    static func fromColor(_ color: Color) -> ActivityColorOption {
        // Since we can't reliably compare colors, i'll return a default
        return .yellow
    }
}

@Model
class Activity {
    var id: UUID
    var name: String
    var duration: Int
    var icon: String
    var colorIndex: Int
    var category: Int
    var activityDescription: String = ""
    
    var colorOption: ActivityColorOption {
        return ActivityColorOption(rawValue: colorIndex) ?? .yellow
    }
    
    var color: Color {
        return colorOption.color
    }
    
    init(id: UUID = UUID(), name: String, duration: Int, icon: String, colorOption: ActivityColorOption, category: Int, activityDescription: String = "") {
        self.id = id
        self.name = name
        self.duration = duration
        self.icon = icon
        self.colorIndex = colorOption.rawValue
        self.category = category
        self.activityDescription = activityDescription
        print(self.colorIndex)
    }
    
    convenience init(id: UUID = UUID(), name: String, duration: Int, icon: String, color: Color, category: Int) {
            let colorOption = ActivityColorOption.fromColor(color)
            self.init(id: id, name: name, duration: duration, icon: icon, colorOption: colorOption, category: category)
        }
}
