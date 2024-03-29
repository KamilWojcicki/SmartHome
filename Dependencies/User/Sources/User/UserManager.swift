//
//  UserManager.swift
//
//
//  Created by Kamil Wójcicki on 03/10/2023.
//

import AuthenticationInterface
import Combine
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
    
    lazy var changePhotoResult: AsyncStream<String> = {
            AsyncStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
                photoChangeHandler = { continuation.yield($0) }
            }
        }()
    
    private var user: User? {
        didSet {
            userHandler?(user)
            loginEventHandler?(user != nil)
            if let newPath = user?.profileImagePath {
                photoChangeHandler?(newPath)
            }
        }
    }
    
    private var userHandler: ((User?) -> Void)?
    private var errorHandler: ((Error) -> Void)?
    private var loginEventHandler: ((Bool) -> Void)?
    private var photoChangeHandler: ((String) -> Void)?
    
    func isUserAuthenticated() throws -> Bool{
        try authenticationManager.isUserAuthenticated()
    }
    
    func fetchUser() async throws -> User {
        let user = try authenticationManager.getCurrentUser()
        return try await cloudDatabaseManager.readInMainCollection(user.uid)
    }
    
    func deleteAccount(email: String, password: String) async throws {
        try await authenticationManager.deleteAccount(email: email, password: password)
        self.user = nil
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
    
    func updatePassword(newPassword: String) async throws {
        try await authenticationManager.updatePassword(newPassword: newPassword)
    }
    
    func resetPassword(withEmail email: String) async throws {
        try await authenticationManager.resetPassword(withEmail: email)
    }
    
    func deleteAccountSSO() async throws {
        try await authenticationManager.deleteAccountWithSSO()
        self.user = nil
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

//MARK: UPDATE USER PHOTO
extension UserManager {
    func updateProfileImagePath(_ newPath: String) async throws {
        let data: [String : Any] = [
            User.CodingKeys.profileImagePath.rawValue : newPath
        ]
        
        try await updateUserData(data: data)
        photoChangeHandler?(newPath)
    }
}
