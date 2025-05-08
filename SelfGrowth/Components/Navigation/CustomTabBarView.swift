//
//  CustomTabBarView.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 4/9/25.
//

import SwiftUI

struct CustomTabBarView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(Color(#colorLiteral(red: 0.5906556249, green: 0.8661773801, blue: 0.599182725, alpha: 1)))
                .edgesIgnoringSafeArea(.bottom)
                .frame(height:80)
            HStack {
                Spacer()
                
                // Home Tab
                VStack(spacing: 4) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(selectedTab == 0 ? Color(#colorLiteral(red: 0.4756627083, green: 0.5513323545, blue: 0.8908587098, alpha: 1)) : Color.clear)
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "house.fill")
                            .font(.system(size: 24))
                            .foregroundColor(selectedTab == 0 ? .white : .gray)
                    }
                    
                    Text("Home")
                        .font(.caption)
                        .foregroundColor(selectedTab == 0 ? Color(#colorLiteral(red: 0.4756627083, green: 0.5513323545, blue: 0.8908587098, alpha: 1)) : .gray)
                }
                .onTapGesture {
                    selectedTab = 0
                }
                
                Spacer()
                
                // Track Tab
                VStack(spacing: 4) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(selectedTab == 1 ? Color(#colorLiteral(red: 0.4756627083, green: 0.5513323545, blue: 0.8908587098, alpha: 1)) : Color.clear)
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 24))
                            .foregroundColor(selectedTab == 1 ? .white : .gray)
                    }
                    
                    Text("Track")
                        .font(.caption)
                        .foregroundColor(selectedTab == 1 ? Color(#colorLiteral(red: 0.4756627083, green: 0.5513323545, blue: 0.8908587098, alpha: 1)) : .gray)
                }
                .onTapGesture {
                    selectedTab = 1
                }
                
                Spacer()
                
                // Journal Tab
                VStack(spacing: 4) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(selectedTab == 2 ? Color(#colorLiteral(red: 0.4756627083, green: 0.5513323545, blue: 0.8908587098, alpha: 1)) : Color.clear)
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "book.fill")
                            .font(.system(size: 24))
                            .foregroundColor(selectedTab == 2 ? .white : .gray)
                    }
                    
                    Text("Journal")
                        .font(.caption)
                        .foregroundColor(selectedTab == 2 ? Color(#colorLiteral(red: 0.4756627083, green: 0.5513323545, blue: 0.8908587098, alpha: 1)) : .gray)
                }
                .onTapGesture {
                    selectedTab = 2
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .cornerRadius(20)
            .offset(y: 15)
        }
    }
}

