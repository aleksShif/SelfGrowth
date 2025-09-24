//
//  ContentView.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 4/2/25.
//

import SwiftUI
import SwiftData
import Combine

struct HomeView: View {
    @Binding var selectedTab: Int
    
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var weatherViewModel = WeatherViewModel()
    
    @FocusState private var isCityFieldFocused: Bool
    @State private var textFieldFrame: CGRect = .zero
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)), Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                SkyBackgroundView(topColor: Color(#colorLiteral(red: 0.3312124014, green: 0.6746367216, blue: 0.8522820473, alpha: 1)), cloudColor: Color(#colorLiteral(red: 0.4756627083, green: 0.5513323545, blue: 0.8908587098, alpha: 1)))
                
                // Dismiss keyboard and city suggestion list when tapping background
                // (this is for the integrated weather component)
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isCityFieldFocused = false
                        weatherViewModel.citySuggestions = []
                    }
                
                VStack(spacing: 0) {
                    // Header that calls weatherSection
                    headerSection(geometry: geometry)
                        .padding(.top, 20)
                    
                    GrowthProgressPanelView(activityCount: homeViewModel.totalActivitiesLogged)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    
                    Spacer(minLength: 0)
                                        
                }
                .frame(minHeight: geometry.size.height)
                
                // City suggestions dropdown
                if !weatherViewModel.citySuggestions.isEmpty {
                    citySuggestionsDropdown(geometry: geometry)
                }
                
                // Tab bar fixed at bottom. plantgrowthview placed right above it
                VStack(spacing: 0) { // plant touching tabbar
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.59, green: 0.87, blue: 0.60).opacity(0.3))
                            .frame(width: min(geometry.size.width * 0.85, 320))
                        
                        PlantGrowthView(activityCount: homeViewModel.totalActivitiesLogged)
                            .frame(
                                width: min(geometry.size.width * 0.8, 300),
                                height: min(geometry.size.height * 0.5, 380)
                            )
                    }
                    CustomTabBarView(selectedTab: $selectedTab)
                }
                .edgesIgnoringSafeArea(.bottom)
                .zIndex(10)
            }
            .onPreferenceChange(TextFieldFramePreferenceKey.self) { value in
                self.textFieldFrame = value
            }
        }
        .ignoresSafeArea(.keyboard)
        .onAppear {
            homeViewModel.setContextIfNeeded(context)
            weatherViewModel.fetchWeather(for: weatherViewModel.preferredCity)
        }
        .onChange(of: isCityFieldFocused) { isFocused in
            if !isFocused {
                DispatchQueue.main.async {
                    weatherViewModel.cityQuery = ""
                    weatherViewModel.citySuggestions = []
                }
            }
        }
    }
    
    // Component Views
    
    @ViewBuilder
    private func headerSection(geometry: GeometryProxy) -> some View {
        VStack(alignment: .center, spacing: 8) {
            Text("Home")
                .font(.system(size: min(geometry.size.width * 0.08, 34)))
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Welcome back!")
                .font(.system(size: min(geometry.size.width * 0.04, 16)))
                .foregroundColor(.white.opacity(0.9))
            
            weatherSection(geometry: geometry)
        }
        .padding(.top)
    }
    
    @ViewBuilder
    private func weatherSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 8) {
            HStack {
                Text("Weather Today In ")
                    .font(.system(size: min(geometry.size.width * 0.04, 16)))
                    .fontWeight(.bold)
                    .foregroundColor(.white.opacity(0.9))
                
                ZStack(alignment: .topLeading) {
                    TextField(weatherViewModel.preferredCity, text: $weatherViewModel.cityQuery)
                        .frame(minWidth: geometry.size.width * 0.25, maxWidth: geometry.size.width * 0.3)
                        .padding(8)
                        .background(Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 0.5)))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
                        .multilineTextAlignment(.center)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                        .onSubmit {
                            weatherViewModel.preferredCity = weatherViewModel.cityQuery
                            weatherViewModel.fetchWeather(for: weatherViewModel.cityQuery)
                            weatherViewModel.citySuggestions = []
                            isCityFieldFocused = false
                        }
                        .background(GeometryReader { geo in
                            Color.clear
                                .preference(key: TextFieldFramePreferenceKey.self, value: geo.frame(in: .global))
                        })
                        .focused($isCityFieldFocused)
                }
            }
            
            HStack {
                Text(weatherViewModel.temperature)
                    .font(.system(size: min(geometry.size.width * 0.04, 16)))
                    .bold()
                    .foregroundColor(.white)
                
                Text(weatherViewModel.description)
                    .font(.system(size: min(geometry.size.width * 0.04, 16)))
                    .foregroundColor(.white.opacity(0.9))
            }
        }
    }
    
    @ViewBuilder
    private func citySuggestionsDropdown(geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(weatherViewModel.citySuggestions.prefix(5)) { suggestion in
                Button(action: {
                    weatherViewModel.preferredCity = suggestion.name
                    weatherViewModel.cityQuery = suggestion.name
                    weatherViewModel.fetchWeather(for: suggestion.name)
                    weatherViewModel.citySuggestions = []
                    isCityFieldFocused = false
                }) {
                    Text("\(suggestion.name), \(suggestion.state ?? ""), \(suggestion.country)")
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .frame(maxWidth: min(geometry.size.width * 0.8, 280))
                        .background(Color.blue.opacity(0.3))
                        .cornerRadius(6)
                }
            }
        }
        .background(Color(#colorLiteral(red: 0.5906556249, green: 0.8661773801, blue: 0.599182725, alpha: 0.849415356)))
        .cornerRadius(8)
        .frame(width: min(geometry.size.width * 0.8, 280))
        .position(
            x: geometry.size.width / 2,
            y: geometry.size.height * 0.25
        )
        .zIndex(2)
    }
}

struct TextFieldFramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

struct HomeView_Previews: PreviewProvider {
    @State static var selectedTab = 0
    
    static var previews: some View {
        HomeView(selectedTab: $selectedTab)
    }
}
