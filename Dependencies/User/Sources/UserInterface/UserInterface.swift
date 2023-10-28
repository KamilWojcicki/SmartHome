//
//  UserInterface.swift
//
//
//  Created by Kamil Wójcicki on 03/10/2023.
//

import AuthenticationInterface
import CloudDatabaseInterface
import Foundation

public struct User: Storable, Hashable {
    public var docRef: String?
    public static var collection: String = "Users"
    
    public let id: String
    public let providerId: String
    public let email: String?
    public let displayName: String?
    
    public init(
        id: String = UUID().uuidString,
        providerId: String,
        email: String?,
        displayName: String?
    ) {
        self.id = id
        self.providerId = providerId
        self.email = email
        self.displayName = displayName
    }
    
    public init(from dao: UserDAO) {
        self.id = dao.id
        self.providerId = dao.providerId
        self.email = dao.email
        self.displayName = dao.displayName
    }
    
}

public struct UserDAO: DAOInterface {
    public static var collection: String = ""
    
    public var docRef: String?
    
    public let id: String
    public let providerId: String
    public let email: String?
    public let displayName: String?
    
    public init(from user: User) {
        self.id = user.id
        self.providerId = user.providerId
        self.email = user.email
        self.displayName = user.displayName
    }
}

public protocol UserManagerInterface {
    var signInResult: AsyncStream<Bool> { get }
    var userUpdates: AsyncThrowingStream<User?, Error> { get }
    
    func getUser() async throws-> User?
    func updateUser(user: User) async throws
    func signOut() throws
    
    func signUp(email: String, password: String) async throws
    func signIn(email: String, password: String) async throws
    func updatePassword(email: String, password: String, newPassword: String) async throws
    func resetPassword(email: String) async throws
    func deleteAccount() async throws
    func signInWithGoogle() async throws
    func signInWithFacebook() async throws
    
    //func signInAnonymously() async throws
}
