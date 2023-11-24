//
//  WeatherManager.swift
//
//
//  Created by Kamil Wójcicki on 23/11/2023.
//

import CoreLocation
import Foundation
import WeatherInterface
import WeatherKit

final class WeatherManager: NSObject, WeatherManagerInterface, CLLocationManagerDelegate {
    var weather: Weather?
    var locationManager = CLLocationManager()
    var authorizationStatus: CLAuthorizationStatus?
    
    var latitude: Double {
        locationManager.location?.coordinate.latitude ?? 37.322998
    }
    var longitude: Double {
        locationManager.location?.coordinate.longitude ?? -122.032181
    }
    var symbol: String {
        weather?.currentWeather.symbolName ?? "xmark"
    }
    
    var temperature: String {
        let temp = weather?.currentWeather.temperature
        let convertedTemp = temp?.converted(to: .celsius).description
        return convertedTemp ?? "-"
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            authorizationStatus = .authorizedWhenInUse
            locationManager.requestLocation()
        case .restricted:
            authorizationStatus = .restricted
        case .denied:
            authorizationStatus = .denied
        case .notDetermined:
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func getWeather() async throws {
        weather = try await Task.detached(priority: .userInitiated) {
            return try await WeatherService.shared.weather(for:.init(latitude: self.latitude, longitude: self.longitude))
        }.value
    }
}
