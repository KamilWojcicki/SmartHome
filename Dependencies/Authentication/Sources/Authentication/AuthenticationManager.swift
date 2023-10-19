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
    private var loginEventHandler: ((Bool) -> Void)?
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
    
    private var user: AuthenticationInterface.User? {
        didSet {
            loginEventHandler?(user != nil)
        }
    }
    
    lazy var signInResult: AsyncStream<Bool> = {
        AsyncStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
            loginEventHandler = { continuation.yield($0) }
        }
    }()
    
    func isUserAuthenticated() throws -> Bool {
        guard let auth = auth.currentUser else {
            throw AuthErrorHandler.getAuthenticatedUserError
        }
        return true
    }
    
    // MARK: Sign In with email
    func createUser(email: String, password: String) async throws {
        do {
            try await auth.createUser(withEmail: email, password: password)
        } catch {
            throw AuthErrorHandler.signUpError
        }
    }
    
    func signInUser(email: String, password: String) async throws {
        do {
            let user = try await auth.signIn(withEmail: email, password: password).user
            self.user = User(from: user)
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
            print("sraka")
            try await auth.sendPasswordReset(withEmail: email)
            print("reset password!")
        } catch {
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
    
    // MARK: PROVIDERS

    func getProviders() throws -> [AuthenticationInterface.AuthProviderOption] {
        guard let user = auth.currentUser else {
            throw AuthErrorHandler.getAuthenticatedUserError
        }
        
        return user
            .providerData
            .compactMap { AuthenticationInterface.AuthProviderOption(rawValue: $0.providerID) }
    }
    
    func signOut() throws {
        do {
            try auth.signOut()
            self.user = nil
        } catch {
            throw AuthErrorHandler.signOutError
        }
    }
    
    // MARK: Sign In with SSO
    func signIn(credential: AuthCredential) async throws -> AuthenticationInterface.User {
        do {
            let authDataResult = try await auth.signIn(with: credential)
            self.user = User(from: authDataResult.user)
            return User(from: authDataResult.user)
        } catch {
            throw AuthErrorHandler.signInWithCredentialError
        }
    }
    
    func signInWithGoogle() async throws -> AuthenticationInterface.User {
        do {
            let credential = try await googleCredential()
            return try await signIn(credential: credential)
        } catch {
            throw AuthErrorHandler.signInWithGoogleError
        }
    }
    
    func signInWithFacebook() async throws -> AuthenticationInterface.User {
        do {
            let credential = try await facebookCredential()
            return try await signIn(credential: credential)
        } catch {
            throw AuthErrorHandler.signInWithFacebookError
        }
    }
    
    
    // MARK: Sign in Anonymously
    func signInAnonymously() async throws {
        do {
            let authenticationDataResult = try await auth.signInAnonymously().user
            self.user = User(from: authenticationDataResult)
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
