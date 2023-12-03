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
    }
    
    private func fetchDevices() {
        Task {
            do {
                self.devices = try await userManager.readAllUserDevices()
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
    private func updateStatusInRealTime(device: Device, state: Bool) {
        Task {
            do {
                let data: [String : Any] = [
                    Device.CodingKeys.state.rawValue : state
                ]
                try await userManager.updateUserDevice(device: device, data: data)
                
                fetchDevices()
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
                try await userManager.updateUserDevice(device: device, data: data)
                
                fetchDevices()
                
                if state {
                    mqttManager.sendMessage(topic: topic, message: messageOn)
                } else {
                    mqttManager.sendMessage(topic: topic, message: messageOff)
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
        cancellable = Timer.publish(every: 5.0, on: .main, in: .common)
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
    
    func stopTimer() {
        cancellable?.cancel()
    }
    
    private func updateRealTimeState() {
        for (index, device) in devices.enumerated() {
            if index < pinValues.count {
                let pinValue = pinValues[index]
                updateStatusInRealTime(device: device, state: pinValue)
            }
        }
    }
}
