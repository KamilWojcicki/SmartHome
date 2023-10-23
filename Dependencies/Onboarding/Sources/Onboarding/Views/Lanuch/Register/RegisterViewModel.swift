//
//  RegisterViewModel.swift
//
//
//  Created by Kamil Wójcicki on 08/10/2023.
//

import Foundation
import AuthenticationInterface
import DependencyInjection
import OnboardingInterface

@MainActor
final class RegisterViewModel: ObservableObject {
    
    @Inject private var authenticationManager: AuthenticationManagerInterface
    
    @Published var email: String = ""
    @Published var fullname: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    func signUp() async throws {
        try validateField()
        try await authenticationManager.createUser(email: email, password: password)
        try await authenticationManager.signInUser(email: email, password: password)
    }
    
    private func validateField() throws {
        try Validation.validateField(email, fieldName: "email")
        try Validation.validateEmail(email: email)
        try Validation.validateField(fullname, fieldName: "fullname")
        try Validation.validateFullname(fullname: fullname)
        try Validation.validateField(password, fieldName: "password")
        try Validation.validateField(confirmPassword, fieldName: "confirmPassword")
        try Validation.validatePassword(password: password, confirmPassword: confirmPassword)
    }
}
