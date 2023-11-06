//
//  CalendarViewModel.swift
//  
//
//  Created by Kamil Wójcicki on 15/10/2023.
//

import Foundation
import CalendarInterface

final class CalendarViewModel: ObservableObject {
    @Published var currentDay: Date = .init()
    @Published var tasks: [TaskModel] = sampleTask
    @Published var addNewTask: Bool = false
    
    
    func filterTasks(for date: Date) -> [TaskModel] {
        let calendar = Calendar.current
        let filteredTasks = tasks.filter {
            if let hour = calendar.dateComponents([.hour], from: date).hour, let taskHour = calendar.dateComponents([.hour], from: $0.dateAdded).hour, hour == taskHour && calendar.isDate($0.dateAdded, inSameDayAs: currentDay) {
                return true
            }
            return false
        }
        return filteredTasks
    }
}
