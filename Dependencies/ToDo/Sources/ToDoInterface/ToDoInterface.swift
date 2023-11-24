//
//  ToDoInterface.swift
//  
//
//  Created by Kamil Wójcicki on 06/11/2023.
//

import Foundation
import CloudDatabaseInterface

public struct ToDo: Storable, Hashable {
    public let id: String
    public let dateExecuted: Date
    public var taskName: String
    public var taskDescription: String
    public var symbol: String
    public let state: String
    
    public init(
        id: String = UUID().uuidString,
        dateExecuted: Date,
        taskName: String,
        taskDescription: String,
        symbol: String,
        state: String
    ) {
        self.id = id
        self.dateExecuted = dateExecuted
        self.taskName = taskName
        self.taskDescription = taskDescription
        self.symbol = symbol
        self.state = state
    }
    
    public init(from dao: ToDoDAO) {
        self.id = dao.id
        self.dateExecuted = dao.dateExecuted
        self.taskName = dao.taskName
        self.taskDescription = dao.taskDescription
        self.symbol = dao.symbol
        self.state = dao.state
    }
    
    public enum CodingKeys: String, CodingKey {
        case id
        case dateExecuted
        case taskName
        case taskDescription
        case symbol
        case state
    }
    
    public static var sampleTask: [ToDo] = [
        .init(dateExecuted: Date(timeIntervalSince1970: 1697396685), taskName: "Test Task", taskDescription: "This is a test task", symbol: "", state: "0")
    ]
}

public struct ToDoDAO: DAOInterface {
    public static var collection: String = "Tasks"
    
    public var docRef: String?
    
    public let id: String
    public let dateExecuted: Date
    public var taskName: String
    public var taskDescription: String
    public var symbol: String
    public let state: String
    
    public init(from todo: ToDo) {
        self.id = todo.id
        self.dateExecuted = todo.dateExecuted
        self.taskName = todo.taskName
        self.taskDescription = todo.taskDescription
        self.symbol = todo.symbol
        self.state = todo.state
    }
}

public protocol ToDoManagerInterface {
    func createToDo(todo: ToDo) async throws
    func readToDo(todoID: String) async throws -> ToDo
    func readAllToDos() async throws -> [ToDo]
    func updateToDo(todo: ToDo, data: [String : Any]) async throws
    func deleteToDo(todo: ToDo) async throws
}
