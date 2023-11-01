//
//  LoginViewModel.swift
//
//
//  Created by Kamil Wójcicki on 08/10/2023.
//


import DependencyInjection
import SwiftUI
import UserInterface

final class LoginViewModel: ObservableObject {
    @Inject private var userManager: UserManagerInterface
    @Published var email: String = ""
    @Published var password: String = ""
    
    func signIn() async throws {
        try validateField()
        try await userManager.signIn(email: email, password: password)
        
    }
    
    private func validateField() throws {
        try Validation.validateField(email, fieldName: "email")
        try Validation.validateEmail(email: email)
        try Validation.validateField(password, fieldName: "password")
    }
}
