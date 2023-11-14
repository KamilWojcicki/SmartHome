//
//  CalendarViewModel.swift
//  
//
//  Created by Kamil Wójcicki on 15/10/2023.
//

import CalendarInterface
import DependencyInjection
import Foundation
import ToDoInterface
import UserInterface

@MainActor
final class CalendarViewModel: ObservableObject {
    @Inject private var todoManager: ToDoManagerInterface
    @Inject private var userManager: UserManagerInterface
    @Published var currentDay: Date = .init()
    @Published var tasks: [ToDo] = []
    @Published var addNewTask: Bool = false
    
    init() {
        Task {
            do {
                try await fetchTasks()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
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
    
    private func fetchTasks() async throws {
        self.tasks = try await todoManager.readAllToDos()
    }
}
