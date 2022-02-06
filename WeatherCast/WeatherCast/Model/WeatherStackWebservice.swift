//
//  WeatherStackWebservice.swift
//  WeatherCast
//
//  Created by Ravi Kiran HR on 05/02/22.
//

import Foundation

class WeatherStackWebservice: WebserviceManager {
    required init(fallbackService: WebserviceManager?) {
        self.fallbackService = fallbackService
    }
    
    let fallbackService: WebserviceManager?
    
    // This is a fallback webservice
    func fetchWeatherData(for city: String, completionHandler: @escaping (String?, WebserviceManagerError?) -> Void) {
        let weatherDescription = "It's a fallback weather info, 99° F"
        completionHandler(weatherDescription, nil)
    }
}
