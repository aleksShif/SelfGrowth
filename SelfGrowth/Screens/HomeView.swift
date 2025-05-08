//
//  ContentView.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 4/2/25.
//
import SwiftUI

struct HomeView: View {
    @State private var selectedTab = 0
    let username = "User" // This would come from your user data
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)), Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.top)
            .edgesIgnoringSafeArea(.bottom)
            
            // Main content
            ZStack(alignment: .bottom) {
                SkyBackgroundView(topColor: Color(#colorLiteral(red: 0.3312124014, green: 0.6746367216, blue: 0.8522820473, alpha: 1)), cloudColor: Color(#colorLiteral(red: 0.4756627083, green: 0.5513323545, blue: 0.8908587098, alpha: 1)))
                
                VStack(spacing: 30) {
                    ZStack(alignment: .top) {
                        // Header
                        VStack(alignment: .center, spacing: 4) {
                            Text("Home")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Welcome back, (username)")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.top, 40)
                    }
                    
                    Spacer()
                    
                    // Main content with plant and pot
                    ZStack {
                        // Plant and pot
                        VStack(spacing: 0) {
                            // Plant
                            PlantView()
                                .frame(width: 120, height: 200)
                            
                            // Pot
                            PotView()
                                .frame(width: 100, height: 80)
                        }
                    }
                    .padding(.bottom, 75)
                }
                
                CustomTabBarView(selectedTab: $selectedTab)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
