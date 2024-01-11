//
//  DeviceViewModel.swift
//
//
//  Created by Kamil Wójcicki on 02/10/2023.
//

import DependencyInjection
import DeviceInterface
import Foundation
import MqttInterface
import UserInterface
import Utilities

@MainActor
final class DeviceViewModel: ObservableObject {
    @Inject private var userManager: UserManagerInterface
    @Inject private var mqttManager: MqttManagerInterface
    @Published var devices: [Device] = []
    @Published var pinValues: [Bool] = []
    @Published var topic: String = ""
    @Published var message: String = ""
    
    init() {
        Task {
            try? await getTopic()
            try? await fetchDevices()
        }
    }
    
    private func fetchDevices() async throws {
        self.devices = try await userManager.readAllUserDevices()
    }
    
    private func getTopic() async throws {
        let user = try await userManager.fetchUser()
        self.topic = user.topic
    }
    private func updateDeviceState(device: Device, state: Bool) async throws {
        let data: [String : Any] = [
            Device.CodingKeys.state.rawValue : state
        ]
        try await userManager.updateUserDevice(device: device, data: data)
        try await fetchDevices()
    }
    
    func updateDeviceStatus(device: Device, state: Bool, messageOn: String, messageOff: String) {
        Task {
            do {
                let data: [String : Any] = [
                    Device.CodingKeys.state.rawValue : state
                ]
                try await userManager.updateUserDevice(device: device, data: data)
                
                try await fetchDevices()
                
                if state {
                    mqttManager.sendMessage(topic: topic, message: messageOn)
                } else {
                    mqttManager.sendMessage(topic: topic, message: messageOff)
                }
            } catch {
                throw DeviceError.updateDeviceStatusError
            }
        }
    }
    
    func checkIfDeviceStateIsChange() async throws {
        for try await _ in Every(.seconds(2)) {
            let recivedMessage = mqttManager.receivedMessages
            print(recivedMessage)
            let pinsArray = recivedMessage.toBoolArray()
            self.pinValues = pinsArray
            print(pinValues)
            try await convertPins()
            try await fetchDevices()
        }
    }
    
    private func convertPins() async throws {
        for (i, device) in devices.enumerated() {
            if i < pinValues.count {
                let devicePin = device.pin - 1
                let pinValue = pinValues[devicePin]
                try await updateDeviceState(device: device, state: pinValue)
            }
        }
    }
}
