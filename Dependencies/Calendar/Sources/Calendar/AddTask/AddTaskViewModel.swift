//
//  AddTaskViewModel.swift
//
//
//  Created by Kamil Wójcicki on 15/10/2023.
//

import CalendarInterface
import DependencyInjection
import DeviceInterface
import Foundation
import MqttInterface
import ToDoInterface
import UserInterface
import Utilities

@MainActor
final class AddTaskViewModel: ObservableObject {
    @Inject private var todoManager: ToDoManagerInterface
    @Inject private var userManager: UserManagerInterface
    @Inject private var mqttManager: MqttManagerInterface
    @Published var taskName: String = ""
    @Published var taskDescription: String = ""
    @Published var taskDate: Date = .init()
    @Published var selectedDevice: Device.Devices = .fan
    @Published var selectedAction: Device.State = .on
    @Published var availableDevices: [Device.Devices] = []
    
    init() {
        Task {
            do {
                try await getUserDevices()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func addTask(onAdd: (ToDo) -> ()) async throws {
        let user = try await userManager.fetchUser()
        let task = ToDo(dateExecuted: taskDate, taskName: taskName, taskDescription: taskDescription, symbol: selectedDevice.symbol, state: selectedAction.state)
        try await todoManager.createToDo(todo: task)
        onAdd(task)
        if selectedAction == .on {
            mqttManager.sendMessage(topic: user.topic, message: selectedDevice.addTurnOnToScheduleMessage(task.dateExecuted.toString("dd.MM.yyyy HH:mm")))
        } else {
            mqttManager.sendMessage(topic: user.topic, message: selectedDevice.addTurnOffToScheduleMessage(task.dateExecuted.toString("dd.MM.yyyy HH:mm")))
        }
    }
    
    private func getUserDevices() async throws {
        let userDevices = try await userManager.readAllUserDevices()
        availableDevices = userDevices.map { Device.Devices(rawValue: $0.id) }.compactMap { $0 }
    }
}
