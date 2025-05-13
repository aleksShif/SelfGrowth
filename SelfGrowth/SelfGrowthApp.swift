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
            Activity.self
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
                }
        }
        .modelContainer(sharedModelContainer)
    }
    
    private func addDefaultActivitiesIfNeeded() async {
        print("addDefaultActivities called")
        // Get the main context from the container
        let context = sharedModelContainer.mainContext
        
        // Create a fetch descriptor to count existing activities
        let descriptor = FetchDescriptor<Activity>()
        
        do {
            // Check if any activities exist
            let existingCount = try context.fetchCount(descriptor)
            
            if existingCount == 0 {
                // Add default activities
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
}

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                if selectedTab == 0 {
                    HomeView()
                        .transition(.opacity)
                }
                else if selectedTab == 1 {
                    TrackView()
                        .transition(.opacity)
                }
                else {
                    JournalView()
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
