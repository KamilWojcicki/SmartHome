//
//  TasksViewModel.swift
//
//
//  Created by Kamil Wójcicki on 10/11/2023.
//

import Combine
import DependencyInjection
import Foundation
import MqttInterface
import SwiftUI
import ToDoInterface
import UserInterface
import Utilities

@MainActor
final class TasksViewModel: ObservableObject {
    @Inject private var todoManager: ToDoManagerInterface
    @Inject private var userManager: UserManagerInterface
    @Inject private var mqttManager: MqttManagerInterface
    @Published var tasks: [ToDo] = []
    @Published private var cancellable: AnyCancellable?
    
    func fetchTasks() async throws {
        self.tasks = try await todoManager.readAllToDos()
    }
    
    func checkIfTaskExpired() async throws {
        for try await _ in Every(.seconds(2)) {
            try await deleteTaskIfExpired()
            try await fetchTasks()
        }
    }
    
    private func deleteTaskIfExpired() async throws{
        for task in tasks {
            if task.dateExecuted <= Date() {
                try await todoManager.deleteToDo(todo: task)
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
