//
//  AuthenticationManager.swift
//
//
//  Created by Kamil Wójcicki on 03/10/2023.
//

import AuthenticationInterface
import FirebaseAuth


final class AuthenticationManager: AuthenticationManagerInterface {
    private let auth = Auth.auth()
    private let signInGoogleHelper = SignInGoogleHelper()
    private let signInFacebookHelper  = SignInFacebookHelper()
    private let signInAppleHelper = SignInAppleHelper()
    
    func isUserAuthenticated() throws -> Bool {
        guard auth.currentUser != nil else {
            throw AuthErrorHandler.getAuthenticatedUserError
        }
        return true
    }
    
    func deleteAccount() async throws {
        let user = try getCurrentUser()
        
        do {
            try await user.delete()
        } catch {
            throw AuthErrorHandler.deleteUserError
        }
    }
    
    func signOut() throws {
        do {
            try auth.signOut()
        } catch {
            throw AuthErrorHandler.signOutError
        }
    }
}

// MARK: Sign In with email
extension AuthenticationManager {
    func signUp(withEmail email: String, password: String, displayName: String) async throws -> AuthenticationDataResult {
        do {
            let user = try await auth.createUser(withEmail: email, password: password).user
            
            let changeRequest = auth.currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = displayName
            try await changeRequest?.commitChanges()
            
            return AuthenticationDataResult(user: user, providerID: user.providerData[0])
        } catch {
            throw AuthErrorHandler.signUpError
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws -> AuthenticationDataResult {
        do {
            let user = try await auth.signIn(withEmail: email, password: password).user
            return AuthenticationDataResult(user: user, userInfo: user.providerData[0])
        } catch {
            throw AuthErrorHandler.signInError
        }
    }
    
    func updatePassword(email: String, password: String, newPassword: String) async throws {
        let user = try getCurrentUser()
        
        do {
            try await user.updatePassword(to: password)
        } catch {
            throw AuthErrorHandler.updatePasswordError
        }
    }
    
    func resetPassword(withEmail email: String) async throws {
        do {
            try await auth.sendPasswordReset(withEmail: email)
        } catch {
            print("Throw an error")
            throw AuthErrorHandler.resetPasswordError
        }
    }
    
    func getCurrentUser() throws -> User {
        try auth.currentUser ?? { throw AuthErrorHandler.getAuthenticatedUserError }()
    }
}

// MARK: Sign In with SSO
extension AuthenticationManager {
    func signInWithApple() async throws -> AuthenticationDataResult {
        do {
            let result = try await signInAppleHelper.signIn()
            
            return try await signIn(
                credential: OAuthProvider.appleCredential(
                    withIDToken: result.idToken,
                    rawNonce: result.nonce,
                    fullName: result.fullName
                )
            )
        } catch {
            throw AuthErrorHandler.signInWithAppleError
        }
    }
    
    func signInWithGoogle() async throws -> AuthenticationDataResult {
        do {
            let result = try await signInGoogleHelper.signIn()
            
            return try await signIn(
                credential:
                    GoogleAuthProvider
                    .credential(
                        withIDToken: result.idToken,
                        accessToken: result.accessToken
                    )
            )
        } catch {
            throw AuthErrorHandler.signInWithGoogleError
        }
    }
    
    func signInWithFacebook() async throws -> AuthenticationDataResult {
        do {
            let result = try await signInFacebookHelper.signIn()
            print(result)
            
            print("test")
            let finalResult = try await signIn(
                credential:
                    FacebookAuthProvider
                    .credential(withAccessToken: result.accessToken)
            )
            print("finala result: \(finalResult)")
            return finalResult
        } catch {
            print(error.localizedDescription)
            throw AuthErrorHandler.signInWithFacebookError
        }
    }
    
    private func signIn(credential: AuthCredential) async throws -> AuthenticationDataResult {
        do {
            let user = try await auth.signIn(with: credential).user
            print("user:",user)
            return AuthenticationDataResult(user: user, userInfo: user.providerData[0])
        } catch {
            throw AuthErrorHandler.signInWithCredentialError
        }
    }
}
