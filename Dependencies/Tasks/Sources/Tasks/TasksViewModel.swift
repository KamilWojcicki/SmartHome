//
//  TasksViewModel.swift
//
//
//  Created by Kamil Wójcicki on 10/11/2023.
//

import DependencyInjection
import Foundation
import ToDoInterface
import UserInterface
import MqttInterface

@MainActor
final class TasksViewModel: ObservableObject {
    @Inject private var todoManager: ToDoManagerInterface
    @Inject private var userManager: UserManagerInterface
    @Inject private var mqttManager: MqttManagerInterface
    @Published var tasks: [ToDo] = []
    @Published var topic: String = ""
    init() {
        Task {
            do {
                try await fetchTasks()
                try await getTopic()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchTasks() async throws {
        self.tasks = try await todoManager.readAllToDos()
        
        deleteTaskForDatabase()
    }
    
    private func getTopic() async throws {
        let user = try await userManager.fetchUser()
        self.topic = user.topic
    }
    
    func updateToDoStatus(todo: ToDo, isOn: Bool) {
        Task {
            do {
                let data: [String : Any] = [
                    ToDo.CodingKeys.isOn.rawValue : isOn
                ]
                try await todoManager.updateToDo(todo: todo, data: data)
                
                if isOn {
                    mqttManager.sendMessage(topic: topic, message: Message.turnDeviceOn.description)
                    print("Device is on")
                } else {
                    mqttManager.sendMessage(topic: topic, message: Message.turnDeviceOff.description)
                    print("Device is off")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func deleteTaskForDatabase() {
        Task {
            do {
                for task in tasks {
                    if task.dateExecuted <= Date() {
                        try await todoManager.deleteToDo(todo: task)
                    }
                }
                try await fetchTasks()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
