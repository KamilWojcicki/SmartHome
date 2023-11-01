//
//  UserInterface.swift
//
//
//  Created by Kamil Wójcicki on 03/10/2023.
//

import AuthenticationInterface
import CloudDatabaseInterface
import FirebaseAuth
import Foundation

public struct User: Storable, Hashable {
    public var docRef: String?
    public static var collection: String = "Users"
    
    public let id: String
    public let providerId: String?
    public let email: String?
    public let displayName: String?
    public let photoURL: String?
    public let topic: String?
    public let isFirstLogin: Bool
    
    public init(
        id: String = UUID().uuidString,
        providerId: String?,
        email: String?,
        displayName: String?,
        photoURL: String?,
        topic: String?,
        isFirstLogin: Bool = true
    ) {
        self.id = id
        self.providerId = providerId
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
        self.topic = topic
        self.isFirstLogin = isFirstLogin
    }
    
    public init(from dao: UserDAO) {
        self.id = dao.id
        self.providerId = dao.providerId
        self.email = dao.email
        self.displayName = dao.displayName
        self.photoURL = dao.photoURL
        self.topic = dao.topic
        self.isFirstLogin = dao.isFirstLogin
    }
    
    public init(from authDataResult: AuthenticationDataResult) {
        self.id = authDataResult.uid
        self.providerId = authDataResult.providerId
        self.email = authDataResult.email
        self.displayName = authDataResult.displayName
        self.photoURL = authDataResult.photoURL
        self.topic = nil
        self.isFirstLogin = authDataResult.isFirstLogin
    }
    
    public init(from user: FirebaseAuth.User, isFirstLogin: Bool = true) {
        self.id = user.uid
        self.providerId = user.providerID
        self.email = user.email
        self.displayName = user.displayName
        self.photoURL = user.photoURL?.absoluteString
        self.topic = nil
        self.isFirstLogin = isFirstLogin
    }
}

public struct UserDAO: DAOInterface {
    public static var collection: String = ""
    
    public var docRef: String?
    
    public let id: String
    public let providerId: String?
    public let email: String?
    public let displayName: String?
    public let photoURL: String?
    public let topic: String?
    public let isFirstLogin: Bool
    
    public init(from user: User) {
        self.id = user.id
        self.providerId = user.providerId
        self.email = user.email
        self.displayName = user.displayName
        self.photoURL = user.photoURL
        self.topic = user.topic
        self.isFirstLogin = user.isFirstLogin
    }
}

public protocol UserManagerInterface {
    var signInResult: AsyncStream<Bool> { get }
    var userUpdates: AsyncThrowingStream<User?, Error> { get }
    
    func getCurrentUser() throws -> User
    func isUserAuthenticated() throws -> Bool
    func signOut() throws
    func signUp(email: String, password: String) async throws
    func signIn(email: String, password: String) async throws
    func updatePassword(email: String, password: String, newPassword: String) async throws
    func resetPassword(email: String) async throws
    func deleteAccount() async throws
    func signInWithGoogle() async throws
    func signInWithFacebook() async throws
    
    func create<ParentObject: Storable, Object: Storable>(parentObject: ParentObject?, object: Object) throws
    func read<ParentObject: Storable, Object: Storable>(parentObject: ParentObject?, object: Object) async throws -> Object
    func readAll<ParentObject: Storable, Object: Storable>(parentObject: ParentObject?, objectsOfType type: Object.Type) async throws -> [Object]
    func update<ParentObject: Storable, Object: Storable>(parentObject: ParentObject?, object: Object, data: [String: Any]) throws 
    func delete<ParentObject: Storable, Object: Storable>(parentObject: ParentObject?, object: Object) async throws
    func handleFirstLogin() async throws -> Bool 
    func checkIsFirstLogin() async throws -> Bool
}
