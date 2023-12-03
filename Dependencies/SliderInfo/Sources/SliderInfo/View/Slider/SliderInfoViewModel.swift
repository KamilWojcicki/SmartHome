//
//  SliderInfoViewModel.swift
//
//
//  Created by Kamil Wójcicki on 31/10/2023.
//

import DeviceInterface
import DependencyInjection
import Foundation
import MqttInterface
import SliderInfoInterface
import SwiftUI
import UserInterface

@MainActor
final class SliderInfoViewModel: ObservableObject {
    @Inject private var deviceManager: DeviceManagerInterface
    @Inject private var userManager: UserManagerInterface
    @Inject private var mqttManager: MqttManagerInterface
    @Published var devices: [Device] = []
    @Published var userDevices: Set<Device> = []
    @Published var pageIndex = 0
    @Published var topic: String = ""
    @Published var password: String = ""
    
    let pages: [Page] = Page.pages
    
    init() {
        Task {
            do {
               try await fetchDevices()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchDevices() async throws {
        devices = try await deviceManager.readAllDevices()
    }
    
    func incrementPage() {
        pageIndex += 1
    }
    
    func buttonIsPressed(device: Device) {
        objectWillChange.send()
        if userDevices.contains(device) {
            userDevices.remove(device)
        } else {
            userDevices.insert(device)
        }
    }
    
    func updateUser() async throws {
        let data: [String : Any] = [
            User.CodingKeys.isFirstLogin.rawValue : false,
            User.CodingKeys.topic.rawValue : topic,
            User.CodingKeys.mqttPassword.rawValue : password
        ]
        try await userManager.updateUserData(data: data)
        let userDevicesArray = Array(userDevices)
        userManager.addDevicesToUser(devices: userDevicesArray)
    }
}
