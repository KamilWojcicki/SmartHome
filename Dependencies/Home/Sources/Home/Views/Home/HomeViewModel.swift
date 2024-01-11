//
//  HomeViewModel.swift
//
//
//  Created by Kamil Wójcicki on 02/10/2023.
//

import CoreLocation
import DependencyInjection
import Foundation
import Localizations
import MqttInterface
import UserInterface
import Utilities
import WeatherInterface

@MainActor
final class HomeViewModel: ObservableObject {
    enum State {
        case loading
        case loaded
        case error
    }
    
    @Inject private var userManager: UserManagerInterface
    @Inject private var mqttManager: MqttManagerInterface
    @Inject private var weatherManager: WeatherManagerInterface
    @Published var state: State = .loading
    @Published private(set) var displayName: String = ""
    @Published var symbol: String = ""
    @Published var temperature: String = ""
    @Published var currentTime: (String, String) = ("","")

     func getDisplayName() async throws {
        let user = try await userManager.fetchUser()
        if let displayName = user.displayName {
            let displayNameComponents = displayName.split(separator: " ")
            let name = displayNameComponents.first ?? "Unknown"
            self.displayName = String(name)
        } else {
            self.displayName = "unknown".localized
        }
    }
    
    func connectMqtt() async throws {
        try await mqttManager.connect()
        print(mqttManager.topic)
        print(mqttManager.password)
    }
    
     func getWeather() async throws {
        do {
            try await weatherManager.getWeather()
            symbol = weatherManager.symbol
            temperature = weatherManager.temperature
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateTime() async throws{
        for try await _ in Every(.seconds(1)) {
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "HH:mm:ss"
            let timeString = dateFormatter.string(from: Date())

            dateFormatter.dateFormat = "dd.MM.yyyy"
            let dateString = dateFormatter.string(from: Date())

            currentTime = (String(timeString), dateString)
        }
    }
}
