//
//  SelfGrowthApp.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 4/2/25.
//

import SwiftUI
import SwiftData

@main
struct SelfGrowthApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            Activity.self,
            ActivityLog.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .onAppear {
                // Add default activities if needed when the app appears
                    Task {
                        await addDefaultActivitiesIfNeeded()
                    }
//                    Task {
//                        await clearSpecificItems()
//                    }
                }
        }
        .modelContainer(sharedModelContainer)
    }
    
    private func addDefaultActivitiesIfNeeded() async {
        print("addDefaultActivities called")
        let context = sharedModelContainer.mainContext
        
        // Create a fetch descriptor to count existing activities
        let descriptor = FetchDescriptor<Activity>()
        
        do {
            // Check if any activities exist
            let existingCount = try context.fetchCount(descriptor)
            
            if existingCount == 0 {
                // Add default activities if none exist
                // this is to give users a few activities to choose from at the start
                let defaultActivities = [
                    Activity(name: "Study Session", duration: 45, icon: "book", color: Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)), category: 1),
                    Activity(name: "Workout", duration: 45, icon: "dumbbell", color: Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.7647058964, alpha: 1)), category: 2),
                    Activity(name: "Meditation", duration: 15, icon: "moon.zzz", color: Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), category: 3)
                ]
                
                for activity in defaultActivities {
                    context.insert(activity)
                }
                
                // Save the changes
                try context.save()
                print("added successfully! defaultActivities count: " + String(try context.fetchCount(descriptor)))
            }
        } catch {
            print("Error setting up default activities: \(error)")
        }
    }
    
    // for the purposes of testing my plant's growth and other things, i have a way to manually clear some activitylogs
    
//    private func clearSpecificItems() {
//        let context = sharedModelContainer.mainContext
//        do {
//            let descriptor = FetchDescriptor<ActivityLog>(
//                sortBy: [SortDescriptor(\.dateCompleted, order: .forward)]
//            )
//            
//            var logs = try context.fetch(descriptor)
//            let lastTen = logs.suffix(10)
//            
//            for item in lastTen {
//                context.delete(item)
//            }
//            
//            try context.save()
//        } catch {
//            print("Failed to clear specific items: \(error)")
//        }
//    }
}

// main navigation is happening here. also used @AppStorage to remember which tab the user last clicked
struct MainTabView: View {
    @AppStorage("selectedTab") private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                if selectedTab == 0 {
                    HomeView(selectedTab: $selectedTab)
                        .transition(.opacity)
                }
                else if selectedTab == 1 {
                    TrackView(selectedTab: $selectedTab)
                        .transition(.opacity)
                }
                else {
                    JournalView(selectedTab: $selectedTab)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut, value: selectedTab)
            
            CustomTabBarView(selectedTab: $selectedTab)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
