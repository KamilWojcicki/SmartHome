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
import WeatherInterface

@MainActor
final class HomeViewModel: ObservableObject {
    @Inject private var userManager: UserManagerInterface
    @Inject private var mqttManager: MqttManagerInterface
    @Inject private var weatherManager: WeatherManagerInterface
    @Published private(set) var displayName: String = ""
    @Published var symbol: String = ""
    @Published var temperature: String = ""
    
    init() {
        getDisplayName()
        Task {
            try? await getMqttCredentialFromUser()
        }
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
                    self.displayName = "unknown".localized
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func getMqttCredentialFromUser() async throws {
        let user = try await userManager.fetchUser()
        mqttManager.topic = user.topic
        print("topic: \(mqttManager.topic)")
        mqttManager.password = user.mqttPassword
        print("password: \(mqttManager.password)")
    }
    
    func getWeather() async {
        do {
            try await weatherManager.getWeather()
            symbol = weatherManager.symbol
            temperature = weatherManager.temperature
        } catch {
            print(error.localizedDescription)
        }
    }
}
