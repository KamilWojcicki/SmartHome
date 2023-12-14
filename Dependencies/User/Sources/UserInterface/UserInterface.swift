//
//  UserInterface.swift
//
//
//  Created by Kamil Wójcicki on 03/10/2023.
//

import AuthenticationInterface
import CloudDatabaseInterface
import DeviceInterface
import FirebaseAuth
import Foundation

public struct User: Storable, Hashable {
    public let id: String
    public let providerId: String?
    public let email: String?
    public let displayName: String?
    public let photoURL: String?
    public let topic: String
    public let mqttPassword: String
    public let isFirstLogin: Bool
    public let profileImagePath: String?
    
    public init(
        id: String = UUID().uuidString,
        providerId: String?,
        email: String?,
        displayName: String?,
        photoURL: String?,
        topic: String,
        mqttPassword: String,
        isFirstLogin: Bool = true,
        profileImagePath: String? = nil
    ) {
        self.id = id
        self.providerId = providerId
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
        self.topic = topic
        self.mqttPassword = mqttPassword
        self.isFirstLogin = isFirstLogin
        self.profileImagePath = profileImagePath
    }
    
    public init(
        from authDataResult: AuthenticationDataResult,
        isFirstLogin: Bool = true
    ) {
        self.id = authDataResult.uid
        self.providerId = authDataResult.providerId
        self.email = authDataResult.email
        self.displayName = authDataResult.displayName
        self.photoURL = authDataResult.photoURL
        self.topic = ""
        self.mqttPassword = ""
        self.isFirstLogin = isFirstLogin
        self.profileImagePath = nil
    }
    
    public init(from dao: UserDAO) {
        self.id = dao.id
        self.providerId = dao.providerId
        self.email = dao.email
        self.displayName = dao.displayName
        self.photoURL = dao.photoURL
        self.topic = dao.topic
        self.mqttPassword = dao.mqttPassword
        self.isFirstLogin = dao.isFirstLogin
        self.profileImagePath = dao.profileImagePath
    }
    
    public enum CodingKeys: String, CodingKey {
        case id
        case providerId
        case email
        case displayName
        case photoURL
        case topic
        case mqttPassword
        case isFirstLogin
        case profileImagePath
    }
}

public struct UserDAO: DAOInterface {
    public static var collection: String = "Users"
    
    public var docRef: String?
    
    public let id: String
    public let providerId: String?
    public let email: String?
    public let displayName: String?
    public let photoURL: String?
    public let topic: String
    public let mqttPassword: String
    public let isFirstLogin: Bool
    public let profileImagePath: String?
    
    public init(from user: User) {
        self.id = user.id
        self.providerId = user.providerId
        self.email = user.email
        self.displayName = user.displayName
        self.photoURL = user.photoURL
        self.topic = user.topic
        self.mqttPassword = user.mqttPassword
        self.isFirstLogin = user.isFirstLogin
        self.profileImagePath = user.profileImagePath
    }
}

public protocol UserManagerInterface {
    var signInResult: AsyncStream<Bool> { get }
    var userUpdates: AsyncThrowingStream<User?, Error> { get }
    
    func isUserAuthenticated() throws -> Bool
    func deleteAccount() async throws
    func signOut() throws
    func checkIsFirstLogin() async throws -> Bool
    func updateUserData(data: [String: Any]) async throws
    func fetchUser() async throws -> User
    
    //Manage User Devices
    func addDevicesToUser(devices: [Device])
    func readAllUserDevices() async throws -> [Device]
    func updateUserDevice(device: Device, data: [String : Any]) async throws
    func deleteAllUserData(user: User) async throws
    
    //Manage User
    func signUp(withEmail email: String, password: String, displayName: String) async throws
    func signIn(withEmail email: String, password: String) async throws
    func updatePassword(newPassword: String) async throws
    func resetPassword(withEmail email: String) async throws
    
    //SSO
    func signInWithApple() async throws
    func signInWithGoogle() async throws
    func signInWithFacebook() async throws
}
