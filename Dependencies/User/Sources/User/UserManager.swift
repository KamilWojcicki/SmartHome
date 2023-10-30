//
//  UserManager.swift
//
//
//  Created by Kamil Wójcicki on 03/10/2023.
//

import AuthenticationInterface
import UserInterface
import SwiftUI
import DependencyInjection

final class UserManager: UserManagerInterface {
    
    @Inject private var authenticationManager: AuthenticationManagerInterface
    
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
    
    func isUserAuthenticated() throws -> Bool{
       return try authenticationManager.isUserAuthenticated()
    }
    
    func signOut() throws {
        try authenticationManager.signOut()
        self.user = nil
    }
    
    func signUp(email: String, password: String) async throws {
        try await authenticationManager.createUser(email: email, password: password)
        try await signIn(email: email, password: password)
    }
    
    func signIn(email: String, password: String) async throws {
        let authDataResult = try await authenticationManager.signInUser(email: email, password: password)
        self.user = User(from: authDataResult)
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
    
    func signInWithGoogle() async throws {
        let authDataResult = try await authenticationManager.signInWithGoogle()
        self.user = User(from: authDataResult)
    }
    
    func signInWithFacebook() async throws {
        let authDataResult = try await authenticationManager.signInWithFacebook()
        self.user = User(from: authDataResult)
    }
}
