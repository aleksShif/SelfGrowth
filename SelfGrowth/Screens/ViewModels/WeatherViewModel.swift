//
//  WeatherViewModel.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/19/25.
//

import SwiftUI
import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var temperature: String = "--"
    @Published var description: String = "Fetching weather..."
    
    @Published var cityQuery: String = ""
    @Published var citySuggestions: [City] = []
    
    @AppStorage("preferredCity") var preferredCity: String = "New York"
    
    // key in a plist file. NOTE: make sure to add files to do with this in your .gitignore
    private let apiKey = Bundle.main.openWeatherAPIKey
    private var cancellables = Set<AnyCancellable>()
    private var debounceCancellable: AnyCancellable?
    
    init() {
        cityQuery = ""
        
        // Debounce input to limit API calls - probably not necessary but..
        $cityQuery
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                if !query.isEmpty {
                    self.fetchCitySuggestions(for: query)
                } else {
                    self.citySuggestions = []
                }
            }
            .store(in: &cancellables)
    }

    func fetchWeather(for city: String) {
        let targetCity = city ?? preferredCity
        preferredCity = targetCity
        cityQuery = ""
        
        let urlString =
          "https://api.openweathermap.org/data/2.5/weather?q=\(targetCity)&appid=\(apiKey)&units=imperial"
        
        guard let url = URL(string: urlString) else {
            self.description = "Invalid URL"
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.description = "Error: \(error.localizedDescription)"
                }
            }, receiveValue: { response in
                self.temperature = "\(Int(response.main.temp))°F"
                self.description = response.weather.first?.description.capitalized ?? "No Description"
            })
            .store(in: &cancellables)
    }
    
    func fetchCitySuggestions(for query: String) {
        guard let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            self.citySuggestions = []
            return
        }
        
        let urlString =
          "https://api.openweathermap.org/geo/1.0/direct?q=\(escapedQuery)&limit=5&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            self.citySuggestions = []
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [City].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$citySuggestions)
    }
}
