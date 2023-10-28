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
    
    func getUser() async throws -> User? {
            
    }
    
    func updateUser(user: User) async throws {
        
    }
    
    func signOut() throws {
        
    }
    
    func signUp(email: String, password: String) async throws {
        
    }
    
    func signIn(email: String, password: String) async throws {
        
    }
    
    func updatePassword(email: String, password: String, newPassword: String) async throws {
        
    }
    
    func resetPassword(email: String) async throws {
        
    }
    
    func deleteAccount() async throws {
        
    }
    
    func signInWithGoogle() async throws {
        
    }
    
    func signInWithFacebook() async throws {
        
    }
    
    
    
    
    
    public init(user: User? = nil, signInResult: AsyncStream<Bool>) {
        self.user = user
        self.signInResult = signInResult
    }
    
    func signInAnonymously() async throws {
        
    }
    
    
}
