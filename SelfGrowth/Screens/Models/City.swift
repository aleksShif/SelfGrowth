//
//  City.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/19/25.
//

import Foundation

struct City: Identifiable, Decodable {
    let id = UUID()
    let name: String
    let state: String?
    let country: String
    
    // For displaying in UI
    var displayName: String {
        if let state = state, !state.isEmpty {
            return "\(name), \(state), \(country)"
        } else {
            return "\(name), \(country)"
        }
    }
}
