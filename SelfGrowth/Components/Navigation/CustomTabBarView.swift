//
//  CustomTabBarView.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 4/12/25.
//

import SwiftUI

struct CustomTabBarView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(Color(#colorLiteral(red: 0.5906556249, green: 0.8661773801, blue: 0.599182725, alpha: 1)))
                    .edgesIgnoringSafeArea(.bottom)
                
                HStack {
                    Spacer()
                    
                    // Home Tab
                    tabButton(
                        iconName: "house.fill",
                        title: "Home",
                        isSelected: selectedTab == 0,
                        screenWidth: geometry.size.width,
                        action: { selectedTab = 0 }
                    )
                    
                    Spacer()
                    
                    // Track Tab
                    tabButton(
                        iconName: "chart.bar.fill",
                        title: "Track",
                        isSelected: selectedTab == 1,
                        screenWidth: geometry.size.width,
                        action: { selectedTab = 1 }
                    )
                    
                    Spacer()
                    
                    // Journal Tab
                    tabButton(
                        iconName: "book.fill",
                        title: "Journal",
                        isSelected: selectedTab == 2,
                        screenWidth: geometry.size.width,
                        action: { selectedTab = 2 }
                    )
                    
                    Spacer()
                }
                .padding(.horizontal)
                .cornerRadius(20)
                .offset(y: 15)
            }
        }
        .frame(height: 80)
    }
    
    @ViewBuilder
    private func tabButton(iconName: String, title: String, isSelected: Bool, screenWidth: CGFloat, action: @escaping () -> Void) -> some View {
        VStack(spacing: 4) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color(#colorLiteral(red: 0.4756627083, green: 0.5513323545, blue: 0.8908587098, alpha: 1)) : Color.clear)
                    .frame(width: min(screenWidth * 0.15, 60), height: min(screenWidth * 0.15, 60))
                
                Image(systemName: iconName)
                    .font(.system(size: min(screenWidth * 0.06, 24)))
                    .foregroundColor(isSelected ? .white : .gray)
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(isSelected ? Color(#colorLiteral(red: 0.4756627083, green: 0.5513323545, blue: 0.8908587098, alpha: 1)) : .gray)
        }
        .onTapGesture(perform: action)
    }
}
