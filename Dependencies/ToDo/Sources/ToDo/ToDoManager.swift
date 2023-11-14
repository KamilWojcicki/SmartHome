//
//  ToDoManager.swift
//
//
//  Created by Kamil Wójcicki on 06/11/2023.
//

import CloudDatabaseInterface
import DependencyInjection
import Foundation
import ToDoInterface
import UserInterface

final class ToDoManager: ToDoManagerInterface {
    @Inject private var cloudDatabaseManager: CloudDatabaseManagerInterface
    @Inject private var userManager: UserManagerInterface
    
    var user: User?
    
    init() {
        Task {
            do {
                try await getUser()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func getUser() async throws {
        self.user = try await userManager.fetchUser()
        guard let user = user else {
            return
        }
        print(user)
    }
    
    private func currentUser() throws -> User{
        guard let user = user else {
            throw URLError(.badServerResponse)
        }
        return user
    }
    
    //CREATE
    func createToDo(todo: ToDo) async throws {
        let user = try currentUser()
        try cloudDatabaseManager.createInSubCollection(parentObject: user, object: todo)
    }
    
    //READ
    func readToDo(todoID: String) async throws -> ToDo {
        let user = try currentUser()
        return try await cloudDatabaseManager.readInSubCollection(parentObject: user, documentID: todoID)
    }
    
    //READ ALL
    func readAllToDos() async throws -> [ToDo] {
        let user = try currentUser()
        return try await cloudDatabaseManager.readAll(parentObject: user, objectsOfType: ToDo.self)
    }
    
    //UPDATE
    func updateToDo(todo: ToDo, data: [String : Any]) async throws {
        let user = try currentUser()
        try await cloudDatabaseManager.updateInSubCollection(parentObject: user, object: todo, data: data)
    }
    
    //DELETE
    func deleteToDo(todo: ToDo) async throws {
        let user = try currentUser()
        try await cloudDatabaseManager.delete(parentObject: user, object: todo)
    }
}
