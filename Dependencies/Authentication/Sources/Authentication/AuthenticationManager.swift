//
//  AuthenticationManager.swift
//
//
//  Created by Kamil Wójcicki on 03/10/2023.
//

import AuthenticationInterface
import FirebaseAuth


final class AuthenticationManager: AuthenticationManagerInterface {
    
    init() {
        userStateListener()
    }
    
    private func userStateListener() {
        auth.addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            
            if let user {
                self.userID = user.uid
                self.isAuthenticatedUser = true
            }
        }
    }
    
    
    var userID: String = ""
    var isAuthenticatedUser: Bool = false
    private var loginEventHandler: ((Bool) -> Void)?
    private let auth = Auth.auth()
    
    
    #warning("Not finished yet")
//    private var userHandler: ((AuthenticationInterface.User?) -> Void)?
//        lazy var userUpdates: AsyncStream<AuthenticationInterface.User?> = {
//            AsyncStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
//                userHandler = { continuation.yield($0) }
//            }
//        }()
    
    private var user: AuthenticationInterface.User? {
        didSet {
            //userHandler?(user)
            loginEventHandler?(user != nil)
        }
    }
    
    lazy var signInResult: AsyncStream<Bool> = {
        AsyncStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
            loginEventHandler = { continuation.yield($0) }
        }
    }()
    
    func getAuthenticatedUser() throws -> Bool {
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
            let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password).user
            self.user = User(from: authDataResult)
        } catch {
            throw AuthErrorHandler.signInError
        }
    }
    
    func resetPassword(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            throw AuthErrorHandler.resetPasswordError
        }
    }
    
    func updatePassword(email: String, password: String, newPassword: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthErrorHandler.updatePasswordError
        }
        try await user.updatePassword(to: password)
    }
    
    func isUserRegistered(email: String) async throws -> Bool {
        do {
            let user = try await Auth.auth().fetchSignInMethods(forEmail: email)
            
            return !user.isEmpty
        } catch {
            throw AuthErrorHandler.isUserRegisteredError
        }
    }
    
    func deleteAccount() async throws {
        guard let user = auth.currentUser else {
            throw AuthErrorHandler.deleteUserError
        }
        try await user.delete()
    }
    
    // MARK: PROVIDERS
    func getProviders() throws -> [AuthenticationInterface.AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw AuthErrorHandler.getProvidersError
        }
        
        var providers: [AuthProviderOption] = []
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
                print(option)
            } else {
                assertionFailure("Provicer option not found: \(provider.providerID)")
            }
        }
        return providers
    }
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            throw AuthErrorHandler.signOutError
        }
    }
    
    // MARK: Sign In with SSO
    func signIn(credential: AuthCredential) async throws -> AuthenticationInterface.User {
        do {
            let authDataResult = try await Auth.auth().signIn(with: credential)
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
        let result = try await SignInGoogleHelper().signIn()
        return GoogleAuthProvider.credential(withSignInResult: result)
    }
    
    private func facebookCredential() async throws -> AuthCredential {
        let result = try await SignInFacebookHelper().signIn()
        return FacebookAuthProvider.credential(withSignInResult: result)
    }
}
