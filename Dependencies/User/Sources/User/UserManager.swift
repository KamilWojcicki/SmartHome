//
//  UserManager.swift
//
//
//  Created by Kamil Wójcicki on 03/10/2023.
//

import AuthenticationInterface
import CloudDatabaseInterface
import DependencyInjection
import SwiftUI
import UserInterface

final class UserManager: UserManagerInterface {
    
    @Inject private var authenticationManager: AuthenticationManagerInterface
    @Inject private var cloudDatabaseManager: CloudDatabaseManagerInterface
    private var user: User? {
        didSet {
            userHandler?(user)
            loginEventHandler?(user != nil)
        }
    }
    
    private var userHandler: ((User?) -> Void)?
    private var errorHandler: ((Error) -> Void)?
    private var loginEventHandler: ((Bool) -> Void)?
    
    lazy var signInResult: AsyncStream<Bool> = {
        AsyncStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
            loginEventHandler = { continuation.yield($0) }
        }
    }()
    
    lazy var userUpdates: AsyncThrowingStream<UserInterface.User?, Error> = {
        AsyncThrowingStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
            userHandler = { continuation.yield($0) }
            errorHandler = { continuation.finish(throwing: $0) }
        }
    }()
    
    func getCurrentUser() throws -> User {
        let firebaseUser = try authenticationManager.getCurrentUser()
        return User(from: firebaseUser)
    }
    
    func getFirestoreUser() async throws -> User {
        let firebaseUser = try getCurrentUser()
        return try await cloudDatabaseManager.read(parentObject: User?.none, object: firebaseUser)
    }
    
    func isUserAuthenticated() throws -> Bool{
        try authenticationManager.isUserAuthenticated()
    }
    
    func signOut() throws {
        try authenticationManager.signOut()
        self.user = nil
    }
    
    func signUp(email: String, password: String) async throws {
        
        let authDataResult = try await authenticationManager.createUser(email: email, password: password)
        try await handleSignUp(authDataResult: authDataResult)
        try await signIn(email: email, password: password)
    }
    
    func signIn(email: String, password: String) async throws {
       let authDataResult = try await authenticationManager.signInUser(email: email, password: password)
        let user = User(from: authDataResult)
        self.user = user
    }
    
    private func handleSignUp(authDataResult: AuthenticationDataResult) async throws {
        let user = User(from: authDataResult)
        try cloudDatabaseManager.create(parentObject: User?.none, object: user)
    }
    
    func updatePassword(email: String, password: String, newPassword: String) async throws {
        try await authenticationManager.updatePassword(email: email, password: password, newPassword: newPassword)
    }
    
    func resetPassword(email: String) async throws {
        try await authenticationManager.resetPassword(email: email)
    }
    
    func deleteAccount() async throws {
        try await authenticationManager.deleteAccount()
    }
    
    func handleFirstLogin() async throws -> Bool {
        let user = try getCurrentUser()
        return try await cloudDatabaseManager.handleObjectExist(parentObject: User?.none, object: user)
    }
    
    func checkIsFirstLogin() async throws -> Bool {
        let user = try await getFirestoreUser()
        print(user.isFirstLogin)
        return user.isFirstLogin
    }
}

//MARK: SOCIAL MEDIA SIGN IN
extension UserManager {
    func signInWithGoogle() async throws {
        let authDataResult = try await authenticationManager.signInWithGoogle()
        
        self.user = User(from: authDataResult)
    }
    
    func signInWithFacebook() async throws {
        let authDataResult = try await authenticationManager.signInWithFacebook()
        self.user = User(from: authDataResult)
    }
}

//MARK: MANAGE DATA
extension UserManager {
    func create<ParentObject: Storable, Object: Storable>(parentObject: ParentObject?, object: Object) throws {
        try cloudDatabaseManager.create(parentObject: parentObject, object: object)
    }
    
    func read<ParentObject: Storable, Object: Storable>(parentObject: ParentObject?, object: Object) async throws -> Object {
        try await cloudDatabaseManager.read(parentObject: parentObject, object: object)
    }
    
    func readAll<ParentObject: Storable, Object: Storable>(parentObject: ParentObject?, objectsOfType type: Object.Type) async throws -> [Object] {
        try await cloudDatabaseManager.readAll(parentObject: parentObject, objectsOfType: type)
    }
    
    func update<ParentObject: Storable, Object: Storable>(parentObject: ParentObject?, object: Object, data: [String: Any]) throws {
        try cloudDatabaseManager.update(parentObject: parentObject, object: object, data: data)
    }
    
    func delete<ParentObject: Storable, Object: Storable>(parentObject: ParentObject?, object: Object) async throws {
        try await cloudDatabaseManager.delete(parentObject: parentObject, object: object)
    }
}
