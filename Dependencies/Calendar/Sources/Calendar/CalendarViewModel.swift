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

@MainActor
final class CalendarViewModel: ObservableObject {
    @Inject private var todoManager: ToDoManagerInterface
    @Inject private var userManager: UserManagerInterface
    @Published var currentDay: Date = .init()
    @Published var tasks: [ToDo] = []
    @Published var addNewTask: Bool = false
    @Published var showTasksList: Bool = false
    @Published private(set) var displayName: String = ""
    @Published private var cancellable: AnyCancellable?
    
    init() {
        getDisplayName()
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
    
    func fetchTasks() {
        cancellable = Timer.publish(every: 2.0, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                Task {
                    do {
                        self.tasks = try await self.todoManager.readAllToDos()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
    }
    
    private func getDisplayName() {
        Task {
            do {
                let user = try await userManager.fetchUser()
                if let displayName = user.displayName {
                    let displayNameComponents = displayName.split(separator: " ")
                    let name = displayNameComponents.first ?? "Unknown"
                    self.displayName = String(name)
                } else {
                    self.displayName = "unknown".localized
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func stopTimer() {
        cancellable?.cancel()
    }
}
