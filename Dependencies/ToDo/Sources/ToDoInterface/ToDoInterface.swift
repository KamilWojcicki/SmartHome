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
    public let dateAdded: Date
    public var taskName: String
    public var taskDescription: String
    
    public init(
        id: String,
        dateAdded: Date,
        taskName: String,
        taskDescription: String
    ) {
        self.id = id
        self.dateAdded = dateAdded
        self.taskName = taskName
        self.taskDescription = taskDescription
    }
    
    public init(from dao: ToDoDAO) {
        self.id = dao.id
        self.dateAdded = dao.dateAdded
        self.taskName = dao.taskName
        self.taskDescription = dao.taskDescription
    }
    
    public enum CodingKeys: String, CodingKey {
        case id
        case dateAdded
        case taskName
        case taskDescription
    }
}

public struct ToDoDAO: DAOInterface {
    public static var collection: String = "Tasks"
    
    public var docRef: String?
    
    public let id: String
    public let dateAdded: Date
    public var taskName: String
    public var taskDescription: String
    
    public init(from todo: ToDo) {
        self.id = todo.id
        self.dateAdded = todo.dateAdded
        self.taskName = todo.taskName
        self.taskDescription = todo.taskDescription
    }
}

public protocol ToDoManagerInterface {
    
}
