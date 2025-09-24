//
//  Bundle+Secrets.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/19/25.
//

import Foundation

extension Bundle {
    var openWeatherAPIKey: String {
        guard let path = self.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["OpenWeatherAPIKey"] as? String else {
            fatalError("Missing OpenWeatherAPIKey in Secrets.plist")
        }
        return key
    }
}
