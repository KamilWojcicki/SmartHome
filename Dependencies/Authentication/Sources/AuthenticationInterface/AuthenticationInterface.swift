//
//  AuthenticationInterface.swift
//
//
//  Created by Kamil Wójcicki on 03/10/2023.
//

import Foundation
import FirebaseAuth
import DependencyInjection


public struct User {
    public let id: String
    public let isAnonymous: Bool
    public let fullname: String?
    public let email: String?
    public let photoURL: String?
    
    public init(from authDataResult: FirebaseAuth.User) {
        self.id = authDataResult.uid
        self.isAnonymous = authDataResult.isAnonymous
        self.fullname = authDataResult.displayName
        self.email = authDataResult.email
        self.photoURL = authDataResult.photoURL?.absoluteString
    }
    
//    var initials: String {
//        let formatter = PersonNameComponentsFormatter()
//        if let components = formatter.personNameComponents(from: fullname) {
//            formatter.style = .abbreviated
//            return formatter.string(from: components)
//        }
//        return ""
//    }
}

//Anonymously
public protocol AuthenticationManagerInterface {
    var signInResult: AsyncStream<Bool> { get }
   // var userUpdates: AsyncStream<User?> { get }
    var userID: String { get }
    var isAuthenticatedUser: Bool { get }
    
    func signInAnonymously() async throws
    func getProviders() throws -> [AuthProviderOption]
    func getAuthenticatedUser() throws -> Bool
    func createUser(email: String, password: String) async throws
    func signInUser(email: String, password: String) async throws
    func updatePassword(email: String, password: String, newPassword: String) async throws
    func resetPassword(email: String) async throws
    func deleteAccount() async throws
    func signIn(credential: AuthCredential) async throws -> User
    func signInWithGoogle() async throws -> User
    func signInWithFacebook() async throws -> User
    func signOut() throws
}

public enum AuthProviderOption: String {
    case email = "password"
    case google = "google.com"
    case facebook = "facebook.com"
}

public enum ErrorState {
    case initial
    case success(String)
    case failure(String)
}

public enum AuthErrorHandler: LocalizedError {
    case getAuthenticatedUserError
    case signUpError
    case signInError
    case resetPasswordError
    case updatePasswordError
    case isUserRegisteredError
    case isEmailInUse
    case deleteUserError
    case getProvidersError
    case signOutError
    case signInWithCredentialError
    case signInWithGoogleError
    case signInWithFacebookError
    case signInAnonymouslyError
    case unknownError(Error)
    
    public var errorDescription: String? {
        switch self {
        case .getAuthenticatedUserError:
            return "There was a problem with user authenticate"
        case .signUpError:
            return "There was a problem with signing up"
        case .signInError:
            return "There was a problem with signing in"
        case .resetPasswordError:
            return "There was a problem with reset user password"
        case .updatePasswordError:
            return "There was a problem with updating user password"
        case .isUserRegisteredError:
            return "There was a problem with veryfication is user registered"
        case .isEmailInUse:
            return "Email is already in use! Try different email"
        case .deleteUserError:
            return "There was a problem with deleting user"
        case .getProvidersError:
            return "There was a problem with getting AUTHENTICATION PROVIDERS"
        case .signOutError:
            return "There was a problem with signing out"
        case .signInWithCredentialError:
            return "There was a problem with credentials"
        case .signInWithGoogleError:
            return "Cannot sign in with google"
        case .signInWithFacebookError:
            return "Cannot sign in with facebook"
        case .signInAnonymouslyError:
            return "Cannot sign in anonymously"
        case .unknownError(let error):
            return "Unknow error: \(error.localizedDescription)"
        }
    }
}


