//
//  OpenWeatherWebService.swift
//  WeatherCast
//
//  Created by Ravi Kiran HR on 05/02/22.
//

import Foundation

private enum API {
    static let key = "294ab09744715fe0c160f7bc8bf1c824"
}

class OpenWeatherWebService: WebserviceManager {
    required init(fallbackService: WebserviceManager?) {
        self.fallbackService = fallbackService
    }
    
    let fallbackService: WebserviceManager?
    
    func fetchWeatherData(for city: String, completionHandler: @escaping(String?, WebserviceManagerError?) -> Void) {
        // api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}
        let endpoint = "https://api.openweathermap.org/data/2.5/find?q=\(city)&units=imperial&appid=\(API.key)"
        guard let safeurl = endpoint.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
              let endPointURL = URL(string: safeurl) else {
            completionHandler(nil, WebserviceManagerError.invalidURL(endpoint))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: endPointURL) { (data, response, error) in
            guard error == nil else {
                if let fallbackService = self.fallbackService {
                    fallbackService.fetchWeatherData(for: city, completionHandler: completionHandler)
                } else {
                    completionHandler(nil, WebserviceManagerError.forwarded(error!))
                }
                return
            }
            guard let data = data else {
                if let fallbackService = self.fallbackService {
                    fallbackService.fetchWeatherData(for: city, completionHandler: completionHandler)
                } else {
                    completionHandler(nil, WebserviceManagerError.invalidPayload(endPointURL))
                }
                return
            }
            
            guard !data.isEmpty else {
                if let fallbackService = self.fallbackService {
                    fallbackService.fetchWeatherData(for: city, completionHandler: completionHandler)
                } else {
                    completionHandler(nil, WebserviceManagerError.invalidPayload(endPointURL))
                }
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                let weatherDataList = try jsonDecoder.decode(OpenWeatherMapContainer.self, from: data)
                guard let weatherInfo = weatherDataList.list?.first,
                      let weather = weatherInfo.weather.first?.main,
                      let temp = weatherInfo.main.temp else {
                    completionHandler(nil, WebserviceManagerError.invalidPayload(endPointURL))
                    return
                }
                let tempText: String = String(format: "%.0f", self.convertToCelsius(temp))
                let weatherDescription = "\(weather) \(tempText) °C"
                completionHandler(weatherDescription, nil)
            }
            catch DecodingError.keyNotFound(let key, let context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch DecodingError.valueNotFound(let value, let context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch DecodingError.typeMismatch(let type, let context) {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }
        dataTask.resume()
    }
    
    func convertToCelsius(_ fahrenheit: Float) -> Float {
        return Float(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
    }
}
