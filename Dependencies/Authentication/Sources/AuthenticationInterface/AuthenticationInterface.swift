//
//  AuthenticationInterface.swift
//
//
//  Created by Kamil Wójcicki on 03/10/2023.
//

import Foundation
import FirebaseAuth



//    var initials: String {
//        let formatter = PersonNameComponentsFormatter()
//        if let components = formatter.personNameComponents(from: fullname) {
//            formatter.style = .abbreviated
//            return formatter.string(from: components)
//        }
//        return ""
//    }


public struct AuthenticationDataResult {
    public let uid: String
    public let providerId: String?
    public let email: String?
    public let displayName: String?
    public let photoURL: String?
    public let isFirstLogin: Bool
    
    public init(user: User, isFirstLogin: Bool = true) {
        self.uid = user.uid
        self.providerId = user.providerID
        self.email = user.email
        self.displayName = user.displayName
        self.photoURL = user.photoURL?.absoluteString
        self.isFirstLogin = isFirstLogin
    }
    
    public init(
        user: User,
        providerId: AuthProviderOption?,
        isFirstLogin: Bool = true
    ) {
        self.uid = user.uid
        self.providerId = providerId?.rawValue
        self.email = user.email
        self.displayName = user.displayName
        self.photoURL = user.photoURL?.absoluteString
        self.isFirstLogin = isFirstLogin
    }
    
    public init(
        user: User,
        userInfo: UserInfo,
        isFirstLogin: Bool = true
    ) {
        self.uid = user.providerData[0].providerID
        self.providerId = userInfo.providerID
        self.email = userInfo.email
        self.displayName = userInfo.displayName
        self.photoURL = userInfo.photoURL?.absoluteString
        self.isFirstLogin = isFirstLogin
    }
}

public protocol AuthenticationManagerInterface {
    var userID: String { get }
    
    func signInAnonymously() async throws -> AuthenticationDataResult
    
    func getCurrentUser() throws -> User 
    func getProviders() throws -> [AuthProviderOption]
    func isUserAuthenticated() throws -> Bool
    
    func createUser(email: String, password: String) async throws -> AuthenticationDataResult
    func signInUser(email: String, password: String) async throws -> AuthenticationDataResult
    func updatePassword(email: String, password: String, newPassword: String) async throws
    func resetPassword(email: String) async throws
    func deleteAccount() async throws
    func signInWithGoogle() async throws -> AuthenticationDataResult
    func signInWithFacebook() async throws -> AuthenticationDataResult
    func signOut() throws
}

public enum AuthProviderOption: String {
    case email = "password"
    case google = "google.com"
    case facebook = "facebook.com"
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


