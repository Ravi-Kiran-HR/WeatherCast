//
//  WebServiceManager.swift
//  WeatherCast
//
//  Created by Ravi Kiran HR on 05/02/22.
//

import Foundation

public enum WebserviceManagerError: Error {
    case invalidPayload(URL)
    case invalidURL(String)
    case forwarded(Error)
}

public protocol WebserviceManager {
    init(fallbackService: WebserviceManager?)
    
    var fallbackService: WebserviceManager? { get }
    
    func fetchWeatherData(for city:String, completionHandler: @escaping(String?, WebserviceManagerError?)-> Void)
}
