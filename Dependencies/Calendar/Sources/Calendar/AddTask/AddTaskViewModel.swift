//
//  AddTaskViewModel.swift
//
//
//  Created by Kamil Wójcicki on 15/10/2023.
//

import CalendarInterface
import DependencyInjection
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
    @Published var symbol: String = ""
    @Published var selectedAction: Action = .light
    @Published var topic: String = ""
    
    init() { 
        Task {
            do {
                try await getTopic()
                print(topic)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func addTask(onAdd: (ToDo) -> ()) async throws {
        let user = try await userManager.fetchUser()
        let task = ToDo(dateExecuted: taskDate, taskName: taskName, taskDescription: taskDescription, symbol: selectedAction.description)
        onAdd(task)
        mqttManager.sendMessage(topic: user.topic, message: Message.addToSchedule(task.dateExecuted.toString("dd.MM.yyyy HH:mm")).description)
        try await todoManager.createToDo(todo: task)
    }
    
    private func getTopic() async throws {
        let user = try await userManager.fetchUser()
        self.topic = user.topic
    }
}
