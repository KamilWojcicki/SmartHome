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
    @Published var showTasksList: Bool = false
    
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
    
    func fetchTasks() {
        Task {
            do {
                self.tasks = try await todoManager.readAllToDos()
                
                _ = $tasks.sink { _ in
                    // Powiadomienie o zmianach w TasksViewModel
                    self.objectWillChange.send()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
