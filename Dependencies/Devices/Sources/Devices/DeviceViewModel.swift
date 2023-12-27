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
    @Published var topic: String = ""
    @Published var message: String = ""
    @Published private var cancellable: AnyCancellable?
    
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
        cancellable = Timer.publish(every: 3.0, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.message = self.mqttManager.receivedMessages
                let pinsArray = self.message.toBoolArray()
                self.pinValues = pinsArray
                self.updateRealTimeState()
                self.fetchDevices()
            }
    }
    
    func stopTimer() {
        cancellable?.cancel()
    }
    
    private func updateRealTimeState() {
        for (i, device) in devices.enumerated() {
            if i < pinValues.count {
                let devicePin = device.pin - 1
                let pinValue = pinValues[devicePin]
                updateStatusInRealTime(device: device, state: pinValue)
            }
        }
    }
}
