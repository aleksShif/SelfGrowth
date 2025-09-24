//
//  ActivityLog.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/13/25.
//

import SwiftUI
import SwiftData

@Model
class ActivityLog {
    var id: UUID
    var activityId: UUID
    var name: String
    var duration: Int
    var activityDescription: String
    var category: Int
    var dateCompleted: Date
    var icon: String
    var colorIndex: Int
    
    var colorOption: ActivityColorOption {
        return ActivityColorOption(rawValue: colorIndex) ?? .yellow
    }
    
    // Reference to the same color array as Activity
    var color: Color {
        return colorOption.color
    }
    
    init(activityId: UUID, name: String, duration: Int, activityDescription: String, category: Int, icon: String, colorOption: ActivityColorOption) {
        self.id = UUID()
        self.activityId = activityId
        self.name = name
        self.duration = duration
        self.activityDescription = activityDescription
        self.category = category
        self.dateCompleted = Date()
        self.icon = icon
        self.colorIndex = colorOption.rawValue
    }
    
    convenience init(activityId: UUID, name: String, duration: Int, description: String, category: Int, icon: String, color: Color) {
           let colorOption = ActivityColorOption.fromColor(color)
           self.init(activityId: activityId, name: name, duration: duration, activityDescription: description, category: category, icon: icon, colorOption: colorOption)
    }
       
    // Convenience initializer to create from an Activity
    convenience init(from activity: Activity, duration: Int = 0, description: String = "") {
       self.init(
           activityId: activity.id,
           name: activity.name,
           duration: duration > 0 ? duration : activity.duration,
           activityDescription: description,
           category: activity.category,
           icon: activity.icon,
           colorOption: activity.colorOption
       )
   }
}
