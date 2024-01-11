//
//  ToDoManager.swift
//
//
//  Created by Kamil Wójcicki on 06/11/2023.
//

import Combine
import CloudDatabaseInterface
import DependencyInjection
import DeviceInterface
import Foundation
import ToDoInterface
import UserInterface

final class ToDoManager: ToDoManagerInterface {
    @Inject private var cloudDatabaseManager: CloudDatabaseManagerInterface
    @Inject private var userManager: UserManagerInterface
    
    //CREATE
    func createToDo(todo: ToDo) async throws {
        let user = try await userManager.fetchUser()
        try cloudDatabaseManager.createInSubCollection(parentObject: user, object: todo)
    }
    
    //READ
    func readToDo(todoID: String) async throws -> ToDo {
        let user = try await userManager.fetchUser()
        return try await cloudDatabaseManager.readInSubCollection(parentObject: user, documentID: todoID)
    }
    
    //READ ALL
    func readAllToDos() async throws -> [ToDo] {
        let user = try await userManager.fetchUser()
        return try await cloudDatabaseManager.readAll(parentObject: user, objectsOfType: ToDo.self)
    }
    
    //UPDATE
    func updateToDo(todo: ToDo, data: [String : Any]) async throws {
        let user = try await userManager.fetchUser()
        try await cloudDatabaseManager.updateInSubCollection(parentObject: user, object: todo, data: data)
    }
    
    //DELETE
    func deleteToDo(todo: ToDo) async throws {
        let user = try await userManager.fetchUser()
        try await cloudDatabaseManager.delete(parentObject: user, object: todo)
    }
    
    func addListenerForAllUserTasks() async throws -> AnyPublisher<[ToDo], Error> {
        let user = try await userManager.fetchUser()
        return try cloudDatabaseManager.addSnapshotListener(parentObject: user, object: ToDo.self)
    }
}
