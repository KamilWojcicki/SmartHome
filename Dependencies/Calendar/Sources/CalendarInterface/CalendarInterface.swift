//
//  CalendarInterface.swift
//  
//
//  Created by Kamil Wójcicki on 13/10/2023.
//

import Foundation

public struct TaskModel: Identifiable {
    public var id: UUID = .init()
    public var dateAdded: Date
    public var taskName: String
    public var taskDescription: String
    
    public init(dateAdded: Date, taskName: String, taskDescription: String) {
        self.dateAdded = dateAdded
        self.taskName = taskName
        self.taskDescription = taskDescription
    }
}

public var sampleTask: [TaskModel] = [
    .init(dateAdded: Date(timeIntervalSince1970: 1697396685), taskName: "Test Task", taskDescription: "This is test description for a test task")
]
