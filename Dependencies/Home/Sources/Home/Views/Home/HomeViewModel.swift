//
//  HomeViewModel.swift
//
//
//  Created by Kamil Wójcicki on 02/10/2023.
//

import Combine
import DependencyInjection
import Foundation
import MqttInterface
import UserInterface

@MainActor
final class HomeViewModel: ObservableObject {
    @Inject private var userManager: UserManagerInterface
    @Inject private var mqttManager: MqttManagerInterface
    @Published private(set) var displayName: String = ""
    @Published private var cancellable: AnyCancellable?
    init() {
        getDisplayName()
        connectMqtt()
    }
    
    func getDisplayName() {
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
    
    func startTimer() {
            cancellable = Timer.publish(every: 10.0, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    print("Diupka")
                }
        }
    
}
