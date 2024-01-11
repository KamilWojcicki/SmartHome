//
//  AuthenticationInterface.swift
//
//
//  Created by Kamil Wójcicki on 03/10/2023.
//

import Foundation
import FirebaseAuth
import Localizations

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

public enum AuthenticationProviderOption: String {
    case email      = "password"
    case google     = "google.com"
    case apple      = "apple.com"
    case facebook   = "facebook.com"
}

public protocol AuthenticationManagerInterface {
    
    //Share
    func isUserAuthenticated() throws -> Bool
    func deleteAccount(email: String, password: String) async throws
    func signOut() throws
    
    //Manage User
    func signUp(withEmail email: String, password: String, displayName: String) async throws -> AuthenticationDataResult
    func signIn(withEmail email: String, password: String) async throws -> AuthenticationDataResult
    func updatePassword(newPassword: String) async throws
    func resetPassword(withEmail email: String) async throws
    func getCurrentUser() throws -> User
    
    //SSO
    func signInWithApple() async throws -> AuthenticationDataResult
    func signInWithGoogle() async throws -> AuthenticationDataResult
    func signInWithFacebook() async throws -> AuthenticationDataResult
    func deleteAccountWithSSO() async throws
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
    case reauthenticateError
    
    //SSO
    case signInWithAppleError
    case signInWithGoogleError
    case signInWithFacebookError
    case signInWithCredentialError
    
    case unknownError(Error)
    
    public var errorDescription: String? {
        switch self {
        //Shared
        case .getAuthenticatedUserError:
            return "get_authenticated_user_error".localized
        case .deleteUserError:
            return "delete_user_error".localized
        case .signOutError:
            return "sign_out_error".localized
  
        // Manage
        case .signUpError:
            return "sign_up_error".localized
        case .signInError:
            return "sign_in_error".localized
        case .updatePasswordError:
            return "update_password_error".localized
        case .resetPasswordError:
            return "reset_password_error".localized
            
        // SSO
        case .signInWithAppleError:
            return "sign_in_apple_error".localized
        case .signInWithGoogleError:
            return "sign_in_google_error".localized
        case .signInWithFacebookError:
            return "sign_in_facebook_error".localized
        case .signInWithCredentialError:
            return "sign_in_with_credential_error".localized
        case .unknownError(let error):
            return String(format: "unknown_error".localized, error.localizedDescription)
        case .reauthenticateError:
            return "reauthenticate_error".localized
        }
    }
}


