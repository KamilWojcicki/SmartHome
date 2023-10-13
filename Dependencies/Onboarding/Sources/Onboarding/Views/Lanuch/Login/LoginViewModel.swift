//
//  LoginViewModel.swift
//
//
//  Created by Kamil Wójcicki on 08/10/2023.
//

import Foundation
import AuthenticationInterface
import DependencyInjection
import OnboardingInterface


public final class LoginViewModel: ObservableObject {
    public enum authType {
        case google
        case facebook
        case apple
    }
    
    @Inject private var authenticationManager: AuthenticationManagerInterface
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showSheet: Bool = false
    
    public func signIn() async throws {
        try validateField()
        try await authenticationManager.signInUser(email: email, password: password)
    }
    
    private func validateField() throws {
        try Validation.validateField(email, fieldName: "email")
        try Validation.validateField(password, fieldName: "password")
    }
    
    public func resetPassword(email: String) async throws {
        
        guard !email.isEmpty else {
            throw ValidationError.emptyEmail
        }
        
        let isRegistered = try await authenticationManager.isUserRegistered(email: email)
        
        guard isRegistered else {
            throw ValidationError.wrongEmail
        }
        
        try await authenticationManager.resetPassword(email: email)
    }
}
