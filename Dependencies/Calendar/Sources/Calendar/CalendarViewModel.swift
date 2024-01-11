//
//  CalendarViewModel.swift
//  
//
//  Created by Kamil Wójcicki on 15/10/2023.
//

import CalendarInterface
import Combine
import DependencyInjection
import Foundation
import ToDoInterface
import UserInterface
import Utilities

@MainActor
final class CalendarViewModel: ObservableObject {
    @Inject private var todoManager: ToDoManagerInterface
    @Inject private var userManager: UserManagerInterface
    @Published var currentDay: Date = .init()
    @Published var tasks: [ToDo] = []
    @Published var addNewTask: Bool = false
    @Published var showTasksList: Bool = false
    @Published private(set) var displayName: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    func filterTasks(for date: Date) -> [ToDo] {
        let calendar = Calendar.current
        let filteredTasks = tasks.filter {
            if let hour = calendar.dateComponents([.hour], from: date).hour, let taskHour = calendar.dateComponents([.hour], from: $0.dateExecuted).hour, hour == taskHour && calendar.isDate($0.dateExecuted, inSameDayAs: currentDay) {
                return true
            }
            return false
        }
        return filteredTasks
    }
    
    func deleteTaskIfExpired() async throws {
        for try await _ in Every(.seconds(2)) {
            for task in tasks {
                if task.dateExecuted <= Date() {
                    try await todoManager.deleteToDo(todo: task)
                }
            }
        }
    }
    
    func addListenerForTasks() async throws {
        try await todoManager.addListenerForAllUserTasks().sink { completion in
            
        } receiveValue: { [weak self] tasks in
            self?.tasks = tasks
        }
        .store(in: &cancellables)
    }
    
    func getDisplayName() async throws {
        let user = try await userManager.fetchUser()
        if let displayName = user.displayName {
            let displayNameComponents = displayName.split(separator: " ")
            let name = displayNameComponents.first ?? "Unknown"
            self.displayName = String(name)
        } else {
            self.displayName = "unknown".localized
        }
    }
}
