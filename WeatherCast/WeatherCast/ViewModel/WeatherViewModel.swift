//
//  WeatherViewModel.swift
//  WeatherCast
//
//  Created by Ravi Kiran HR on 05/02/22.
//

import Foundation

class WeatherViewModel: ObservableObject {
    
    @Published var weatherInfo = ""
    private let weatherService = OpenWeatherWebService(fallbackService: WeatherStackWebservice(fallbackService: nil))
    
    func fetch(city: String) {
        weatherService.fetchWeatherData(for: city, completionHandler:  { (info, error) in
            guard error == nil ,let info = info, !info.isEmpty else {
                DispatchQueue.main.async {
                    self.weatherInfo = "No Weather info for \(city)"
                }
                return
            }
            DispatchQueue.main.async {
                self.weatherInfo = info
            }
        })
    }
}
