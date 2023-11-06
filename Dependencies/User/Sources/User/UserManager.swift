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
    
    private var user: User? {
        didSet {
            userHandler?(user)
            loginEventHandler?(user != nil)
        }
    }
    
    private var userHandler: ((User?) -> Void)?
    private var errorHandler: ((Error) -> Void)?
    private var loginEventHandler: ((Bool) -> Void)?
    
    func isUserAuthenticated() throws -> Bool{
        try authenticationManager.isUserAuthenticated()
    }
    
    func fetchUser() async throws -> User {
        let user = try authenticationManager.getCurrentUser()
        return try await cloudDatabaseManager.readInMainCollection(user.uid)
    }
    
    func deleteAccount() async throws {
        try await authenticationManager.deleteAccount()
    }
    
    func signOut() throws {
        try authenticationManager.signOut()
        self.user = nil
    }
    
    func checkIsFirstLogin() async throws -> Bool {
        let user = try await fetchUser()
        return user.isFirstLogin
    }
    
    func updateUserData(data: [String : Any]) async throws {
        let user = try await fetchUser()
        try await cloudDatabaseManager.updateInMainCollection(object: user, data: data)
    }
}
// MARK: MANAGE USER
extension UserManager {
    func signUp(withEmail email: String, password: String, displayName: String) async throws {
        let authDataResult = try await authenticationManager.signUp(withEmail: email, password: password, displayName: displayName)
        try cloudDatabaseManager.createInMainCollection(object: User(from: authDataResult))
        try await signIn(withEmail: email, password: password)
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        let authDataResult = try await authenticationManager.signIn(withEmail: email, password: password)
        self.user = User(from: authDataResult)
    }
    
    func updatePassword(email: String, password: String, newPassword: String) async throws {
        try await authenticationManager.updatePassword(email: email, password: password, newPassword: newPassword)
    }
    
    func resetPassword(withEmail email: String) async throws {
        try await authenticationManager.resetPassword(withEmail: email)
    }
}

//MARK: SOCIAL MEDIA SIGN IN
extension UserManager {
    func signInWithGoogle() async throws {
        let authDataResult = try await authenticationManager.signInWithGoogle()
        do {
            let _ = try await fetchUser()
        } catch {
            try cloudDatabaseManager.createInMainCollection(object: User(from: authDataResult))
        }
        self.user = User(from: authDataResult)
    }
    
    func signInWithFacebook() async throws {
        let authDataResult = try await authenticationManager.signInWithFacebook()
        do {
            let _ = try await fetchUser()
        } catch {
            try cloudDatabaseManager.createInMainCollection(object: User(from: authDataResult))
        }
        self.user = User(from: authDataResult)
    }
}
