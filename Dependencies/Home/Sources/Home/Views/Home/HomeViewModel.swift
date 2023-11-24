//
//  HomeViewModel.swift
//
//
//  Created by Kamil Wójcicki on 02/10/2023.
//

import CoreLocation
import DependencyInjection
import Foundation
import MqttInterface
import UserInterface
import WeatherInterface

@MainActor
final class HomeViewModel: ObservableObject {
    @Inject private var userManager: UserManagerInterface
    @Inject private var mqttManager: MqttManagerInterface
    @Inject private var weatherManager: WeatherManagerInterface
    @Published private(set) var displayName: String = ""
    @Published var symbol: String = ""
    @Published var temperature: String = ""
    @Published var showWeather: Bool = false
    
    init() {
        getDisplayName()
        connectMqtt()
    }
    
    private func getDisplayName() {
        Task {
            do {
                let user = try await userManager.fetchUser()
                if let displayName = user.displayName {
                    let displayNameComponents = displayName.split(separator: " ")
                    let name = displayNameComponents.first ?? "Unknown"
                    self.displayName = String(name)
                } else {
                    self.displayName = "Unkown"
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func connectMqtt() {
        mqttManager.connect()
    }
    
    func getWeather() async {
        do {
            try await weatherManager.getWeather()
            showWeather = true
            symbol = weatherManager.symbol
            temperature = weatherManager.temperature
        } catch {
            showWeather = false
            print(error.localizedDescription)
        }
    }
}
