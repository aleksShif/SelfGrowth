//
//  Item.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 4/2/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
