//
//  AuthenticationManager.swift
//
//
//  Created by Kamil Wójcicki on 03/10/2023.
//

import AuthenticationInterface
import FirebaseAuth


final class AuthenticationManager: AuthenticationManagerInterface {
    var userID: String = ""
    
    private let auth = Auth.auth()
    private let signInGoogleHelper = SignInGoogleHelper()
    private let signInFacebookHelper  = SignInFacebookHelper()
    
    init() {
        userStateListener()
    }
    
    private func userStateListener() {
        auth.addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            
            if let user {
                self.userID = user.uid
            }
        }
    }
}
// MARK: Sign In with email
extension AuthenticationManager {
    func isUserAuthenticated() throws -> Bool {
        guard auth.currentUser != nil else {
            throw AuthErrorHandler.getAuthenticatedUserError
        }
        return true
    }
    func createUser(email: String, password: String) async throws {
        do {
            try await auth.createUser(withEmail: email, password: password)
        } catch {
            throw AuthErrorHandler.signUpError
        }
    }
    
    func signInUser(email: String, password: String) async throws -> AuthenticationDataResult {
        do {
            let user = try await auth.signIn(withEmail: email, password: password).user
            return AuthenticationDataResult(user: user)
        } catch {
            throw AuthErrorHandler.signInError
        }
    }
    
    func updatePassword(email: String, password: String, newPassword: String) async throws {
        guard let user = auth.currentUser else {
            throw AuthErrorHandler.getAuthenticatedUserError
        }
        do {
            try await user.updatePassword(to: password)
        } catch {
            throw AuthErrorHandler.updatePasswordError
        }
    }
    
    func resetPassword(email: String) async throws {
        do {
            try await auth.sendPasswordReset(withEmail: email)
        } catch {
            print("Throw an error")
            throw AuthErrorHandler.resetPasswordError
        }
    }
    
    func deleteAccount() async throws {
        guard let user = auth.currentUser else {
            throw AuthErrorHandler.getAuthenticatedUserError
        }
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
// MARK: Sign In with SSO
extension AuthenticationManager {
    // MARK: PROVIDERS
    func getProviders() throws -> [AuthenticationInterface.AuthProviderOption] {
        guard let user = auth.currentUser else {
            throw AuthErrorHandler.getAuthenticatedUserError
        }
        
        return user
            .providerData
            .compactMap { AuthenticationInterface.AuthProviderOption(rawValue: $0.providerID) }
    }
    
    private func signIn(credential: AuthCredential) async throws -> AuthenticationDataResult {
        do {
            let user = try await auth.signIn(with: credential).user
            return AuthenticationDataResult(user: user)
        } catch {
            throw AuthErrorHandler.signInWithCredentialError
        }
    }
    
    func signInWithGoogle() async throws -> AuthenticationDataResult {
        do {
            let credential = try await googleCredential()
            return try await signIn(credential: credential)
        } catch {
            throw AuthErrorHandler.signInWithGoogleError
        }
    }
    
    func signInWithFacebook() async throws -> AuthenticationDataResult {
        do {
            let credential = try await facebookCredential()
            return try await signIn(credential: credential)
        } catch {
            throw AuthErrorHandler.signInWithFacebookError
        }
    }
}
// MARK: Sign in Anonymously
extension AuthenticationManager {
    func signInAnonymously() async throws -> AuthenticationDataResult {
        do {
            let user = try await auth.signInAnonymously().user
            return AuthenticationDataResult(user: user)
        } catch {
            throw AuthErrorHandler.signInAnonymouslyError
        }
        
    }
}
// MARK: CREDENTIALS
extension AuthenticationManager {
    private func googleCredential() async throws -> AuthCredential {
        let result = try await signInGoogleHelper.signIn()
        return GoogleAuthProvider.credential(withSignInResult: result)
    }
    
    private func facebookCredential() async throws -> AuthCredential {
        let result = try await signInFacebookHelper.signIn()
        return FacebookAuthProvider.credential(withSignInResult: result)
    }
}
