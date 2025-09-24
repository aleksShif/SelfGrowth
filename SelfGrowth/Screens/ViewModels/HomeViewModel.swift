//
//  HomeViewModel.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/19/25.
//

import Foundation
import SwiftUI
import SwiftData
import Combine

class HomeViewModel: ObservableObject {
    // Dependencies
    private var context: ModelContext?
    // ActivityLog from SwiftData
    @Published var activitiesLog: [ActivityLog] = []
    private var cancellables = Set<AnyCancellable>()

    func setContextIfNeeded(_ newContext: ModelContext) {
        guard context == nil else { return }
        context = newContext
        fetchActivities()
    }

    var totalActivitiesLogged: Int {
        activitiesLog.count
    }

    func fetchActivities() {
        guard let context else { return }
        do {
            let descriptor = FetchDescriptor<ActivityLog>(
                sortBy: [SortDescriptor(\.dateCompleted, order: .reverse)] 
            )
            self.activitiesLog = try context.fetch(descriptor)
        } catch {
            print("Failed to fetch activities: \(error)")
            self.activitiesLog = []
        }
    }
}
