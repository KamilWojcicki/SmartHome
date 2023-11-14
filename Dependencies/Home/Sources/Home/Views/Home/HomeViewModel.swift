//
//  HomeViewModel.swift
//
//
//  Created by Kamil Wójcicki on 02/10/2023.
//

import DependencyInjection
import Foundation
import MqttInterface
import UserInterface

@MainActor
final class HomeViewModel: ObservableObject {
    @Inject private var userManager: UserManagerInterface
    @Inject private var mqttManager: MqttManagerInterface
    @Published private(set) var displayName: String = ""
    
    init() {
        getDisplayName()
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
    
    func connectMqtt() {
        mqttManager.connect()
    }
}
