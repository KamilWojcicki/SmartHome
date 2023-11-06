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
import SwiftUI

final class LoginViewModel: ObservableObject {
    @Inject private var authenticationManager: AuthenticationManagerInterface
    @Published var email: String = ""
    @Published var password: String = ""
    
    func signIn() async throws {
        try validateField()
        try await authenticationManager.signInUser(email: email, password: password)
    }
    
    private func validateField() throws {
        try Validation.validateField(email, fieldName: "email")
        try Validation.validateEmail(email: email)
        try Validation.validateField(password, fieldName: "password")
    }
}
