//
//  WeatherInterface.swift
//
//
//  Created by Kamil Wójcicki on 23/11/2023.
//

import CoreLocation
import Foundation
import WeatherKit

public protocol WeatherManagerInterface {
    var weather: Weather? { get }
    var symbol: String { get }
    var temperature: String { get }
    var authorizationStatus: CLAuthorizationStatus? { get }
    
    func getWeather() async throws
}
