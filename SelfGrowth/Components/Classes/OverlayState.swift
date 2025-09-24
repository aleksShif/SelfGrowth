//
//  OverlayState.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/19/25.
//

import SwiftUI

class OverlayState: ObservableObject {
    @Published var showOverlay = false
    
    func displayOverlay() {
        self.showOverlay = true
    }
    
    func hideOverlay() {
        self.showOverlay = false
    }
}
