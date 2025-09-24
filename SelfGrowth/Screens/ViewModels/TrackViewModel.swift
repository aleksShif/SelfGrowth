//
//  TrackViewModel.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/19/25.
//
import SwiftUI
import SwiftData

class TrackViewModel: ObservableObject {
    // Dependencies
    private var context: ModelContext?
    @Published var selectedCategory: Int = 0
    @Published var isAddingActivity: Bool = false
    
    // Activity and ActivityLog from SwiftData
    @Published var activities: [Activity] = []
    @Published var activitiesLog: [ActivityLog] = []
    
    let categories = CategoryData.categories
    
    // This is the class responsible for the GrowthCelebrationView overlay over TrackView - see Classes folder under components
    @Published var overlayState = OverlayState()
    
    func setContextIfNeeded(_ context: ModelContext) {
        guard self.context == nil else { return }
        self.context = context
        fetchData()
    }
    
    func fetchData() {
       guard let context else { return }

       do {
           activities = try context.fetch(FetchDescriptor<Activity>())
           activitiesLog = try context.fetch(FetchDescriptor<ActivityLog>())
       } catch {
           print("Failed to fetch data: \(error)")
       }
    }
    
    func deleteActivity(_ activity: Activity, context: ModelContext) {
        context.delete(activity)
        try? context.save()
        fetchData()
    }
    
    // Filtering logic
    var filteredActivities: [Activity] {
        
       if selectedCategory == 0 {
           return activities
       } else {
           return activities.filter { $0.category == selectedCategory }
       }
    }
}
