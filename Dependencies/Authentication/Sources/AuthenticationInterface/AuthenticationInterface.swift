//
//  AuthenticationInterface.swift
//
//
//  Created by Kamil Wójcicki on 03/10/2023.
//

import Foundation
import FirebaseAuth

public struct AuthenticationDataResult {
    public let uid: String
    public let providerId: String?
    public let email: String?
    public let displayName: String?
    public let photoURL: String?
    
    public init(
        user: User
    ) {
        self.uid = user.uid
        self.providerId = user.providerID
        self.email = user.email
        self.displayName = user.displayName
        self.photoURL = user.photoURL?.absoluteString
    }
    
    public init(
        user: User,
        userInfo: UserInfo
    ) {
        self.uid = user.uid
        self.providerId = userInfo.providerID
        self.email = userInfo.email
        self.displayName = userInfo.displayName
        self.photoURL = userInfo.photoURL?.absoluteString
    }
    
    public init(
        user: User,
        providerID: UserInfo
    ) {
        self.uid = user.uid
        self.providerId = providerID.providerID
        self.email = user.email
        self.displayName = user.displayName
        self.photoURL = user.photoURL?.absoluteString
    }
}

public protocol AuthenticationManagerInterface {
    
    //Share
    func isUserAuthenticated() throws -> Bool
    func deleteAccount() async throws
    func signOut() throws
    
    //Manage User
    func signUp(withEmail email: String, password: String, displayName: String) async throws -> AuthenticationDataResult
    func signIn(withEmail email: String, password: String) async throws -> AuthenticationDataResult
    func updatePassword(email: String, password: String, newPassword: String) async throws
    func resetPassword(withEmail email: String) async throws
    func getCurrentUser() throws -> User
    
    //SSO
    func signInWithGoogle() async throws -> AuthenticationDataResult
    func signInWithFacebook() async throws -> AuthenticationDataResult
    
}

public enum AuthErrorHandler: LocalizedError {
    //Share
    case getAuthenticatedUserError
    case deleteUserError
    case signOutError
    
    //Manage User
    case signUpError
    case signInError
    case updatePasswordError
    case resetPasswordError
    
    //SSO
    case signInWithGoogleError
    case signInWithFacebookError
    case signInWithCredentialError
    
    case unknownError(Error)
    
    public var errorDescription: String? {
        switch self {
        //Shared
        case .getAuthenticatedUserError:
            return "There was a problem with user authenticate"
        case .deleteUserError:
            return "There was a problem with deleting user"
        case .signOutError:
            return "There was a problem with signing out"
  
        // Manage
        case .signUpError:
            return "There was a problem with signing up"
        case .signInError:
            return "There was a problem with signing in"
        case .updatePasswordError:
            return "There was a problem with updating user password"
        case .resetPasswordError:
            return "There was a problem with reset user password"
            
        // SSO
        case .signInWithGoogleError:
            return "Cannot sign in with google"
        case .signInWithFacebookError:
            return "Cannot sign in with facebook"
        case .signInWithCredentialError:
            return "There was a problem with credentials"
        case .unknownError(let error):
            return "Unknow error: \(error.localizedDescription)"
        }
    }
}


