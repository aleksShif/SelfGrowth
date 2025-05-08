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
        }
        .modelContainer(sharedModelContainer)
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
