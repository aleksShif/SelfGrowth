//
//  Activity.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/11/25.


import SwiftUI
import SwiftData

@Model
class Activity {
    var id: UUID
    var name: String
    var duration: Int
    var icon: String
    var colorIndex: Int
    var category: Int
    var dateCreated: Date
    
    static let colors: [Color] = [
        Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)),
        Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.7647058964, alpha: 1)),
        Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)),
        Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)),
        Color(#colorLiteral(red: 0.4500938654, green: 0.8412100673, blue: 0.6149917841, alpha: 1))
    ]
    
    var color: Color {
        let ind = min(max(0, colorIndex), Activity.colors.count-1)
        return Activity.colors[ind]
    }
    
    init(id: UUID = UUID(), name: String, duration: Int, icon: String, color: Color, category: Int) {
        self.id = id
        self.name = name
        self.duration = duration
        self.icon = icon
        
        if let index = Activity.colors.firstIndex(where: { $0 == color }) {
            self.colorIndex = index
        } else {
            self.colorIndex = 0
        }
        
        self.category = category
        self.dateCreated = Date()
    }
}
