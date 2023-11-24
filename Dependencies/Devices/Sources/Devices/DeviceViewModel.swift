//
//  DeviceViewModel.swift
//
//
//  Created by Kamil Wójcicki on 02/10/2023.
//

import Combine
import DependencyInjection
import DeviceInterface
import Foundation
import UserInterface
import MqttInterface

@MainActor
final class DeviceViewModel: ObservableObject {
    @Inject private var deviceManager: DeviceManagerInterface
    @Inject private var userManager: UserManagerInterface
    @Inject private var mqttManager: MqttManagerInterface
    @Published var devices: [Device] = []
    @Published var pinValues: [Bool] = []
    @Published var deviceState: Bool = false
    @Published var topic: String = ""
    @Published private var cancellable: AnyCancellable?
    @Published var message: String = ""
    
    init() {
        fetchDevices()
        getTopic()
        startTimer()
    }
    
    private func fetchDevices() {
        Task {
            do {
                self.devices = try await deviceManager.readAllUserDevices()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func getTopic() {
        Task {
            do {
                let user = try await userManager.fetchUser()
                self.topic = user.topic
                print(topic)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateDeviceStatus(device: Device, state: Bool, messageOn: String, messageOff: String) {
        Task {
            do {
                let data: [String : Any] = [
                    Device.CodingKeys.state.rawValue : state
                ]
                try await deviceManager.updateUserDevice(device: device, data: data)
                
                fetchDevices()
                
                if state {
                    mqttManager.sendMessage(topic: topic, message: messageOn)
                    print(messageOn)
                } else {
                    mqttManager.sendMessage(topic: topic, message: messageOff)
                    print(messageOff)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func startTimer() {
        cancellable = Timer.publish(every: 10.0, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.message = self.mqttManager.receivedMessages
                let pinsArray = self.message.toBoolArray()
                self.pinValues = pinsArray
                print(self.pinValues)
                self.updateRealTimeState()
                self.fetchDevices()
            }
    }
    
    private func updateRealTimeState() {
        for (index, device) in devices.enumerated() {
            if index < pinValues.count {
                let pinValue = pinValues[index]
                print(pinValue)
                updateDeviceStatus(device: device, state: pinValue, messageOn: "", messageOff: "")
            }
        }
    }
}
