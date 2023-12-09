//
//  UserManager.swift
//
//
//  Created by Kamil Wójcicki on 03/10/2023.
//

import AuthenticationInterface
import CloudDatabaseInterface
import DependencyInjection
import DeviceInterface
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
        self.user = user
        return user.isFirstLogin
    }
    
    func updateUserData(data: [String : Any]) async throws {
        let user = try currentUser()
        try await cloudDatabaseManager.updateInMainCollection(object: user, data: data)
        self.user = try await fetchUser()
    }
    
    private func currentUser() throws -> User {
        guard let user = user else {
            throw URLError(.badServerResponse)
        }
        return user
    }
    
    private func handleSignUp(authDataResult: AuthenticationDataResult) async throws {
        try cloudDatabaseManager.createInMainCollection(object: User(from: authDataResult))
        self.user = try await fetchUser()
    }
}
// MARK: MANAGE USER
extension UserManager {
    func signUp(withEmail email: String, password: String, displayName: String) async throws {
        let authDataResult = try await authenticationManager.signUp(withEmail: email, password: password, displayName: displayName)
        try await handleSignUp(authDataResult: authDataResult)
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
    func signInWithApple() async throws {
        let authDataResult = try await authenticationManager.signInWithApple()
        do {
            self.user = try await fetchUser()
        } catch {
            try await handleSignUp(authDataResult: authDataResult)
        }
    }
    
    func signInWithGoogle() async throws {
        let authDataResult = try await authenticationManager.signInWithGoogle()
        do {
            self.user = try await fetchUser()
        } catch {
            try await handleSignUp(authDataResult: authDataResult)
        }
    }
    
    func signInWithFacebook() async throws {
        let authDataResult = try await authenticationManager.signInWithFacebook()
        do {
            self.user = try await fetchUser()
        } catch {
            try await handleSignUp(authDataResult: authDataResult)
        }
    }
}

extension UserManager {
    private func addDevicesToUser() {
        Task {
            do {
                let user = try await fetchUser()
                let devices = try await readAllDevices()
                
                for device in devices {
                    try cloudDatabaseManager.createInSubCollection(parentObject: user, object: device)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func readAllDevices() async throws -> [Device] {
        try await cloudDatabaseManager.readAll(objectsOfType: Device.self)
    }
    
    func readAllUserDevices() async throws -> [Device] {
        let user = try await fetchUser()
        return try await cloudDatabaseManager.readAll(parentObject: user, objectsOfType: Device.self)
    }
    
    func updateUserDevice(device: Device, data: [String : Any]) async throws {
        let user = try await fetchUser()
        try await cloudDatabaseManager.updateInSubCollection(parentObject: user, object: device, data: data)
    }
}

extension UserManager {
    func addDevicesToUser(devices: [Device]) {
        Task {
            do {
                let user = try await fetchUser()
                
                for device in devices {
                    print(device)
                    try cloudDatabaseManager.createInSubCollection(parentObject: user, object: device)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
