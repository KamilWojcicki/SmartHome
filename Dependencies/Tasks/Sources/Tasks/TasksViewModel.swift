//
//  TasksViewModel.swift
//
//
//  Created by Kamil Wójcicki on 10/11/2023.
//

import Combine
import DependencyInjection
import Foundation
import SwiftUI
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
    @Published private var cancellable: AnyCancellable?
    
    init() {
        Task {
            do {
                try await fetchTasks()
                try await getTopic()
                checkIfTaskIsExpired()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchTasks() async throws {
        self.tasks = try await todoManager.readAllToDos()
    }
    
    private func getTopic() async throws {
        let user = try await userManager.fetchUser()
        self.topic = user.topic
    }
    
    private func checkIfTaskIsExpired() {
        cancellable = Timer.publish(every: 2.0, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.deleteTaskForDatabase()
                Task {
                    do {
                        try await self.fetchTasks()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
    }
    
    func stopTimer() {
        cancellable?.cancel()
    }
    
    private func deleteTaskForDatabase() {
        Task {
            do {
                for task in tasks {
                    if task.dateExecuted <= Date() {
                        try await todoManager.deleteToDo(todo: task)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteTask(todo: ToDo) {
        Task {
            do {
                try await todoManager.deleteToDo(todo: todo)
                try await fetchTasks()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
