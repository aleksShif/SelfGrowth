//
//  WeatherResponse.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/19/25.
//

import Foundation

struct WeatherResponse: Codable {
    let weather: [Weather]
    let main: Main

    struct Weather: Codable {
        let description: String
    }

    struct Main: Codable {
        let temp: Double
    }
}
