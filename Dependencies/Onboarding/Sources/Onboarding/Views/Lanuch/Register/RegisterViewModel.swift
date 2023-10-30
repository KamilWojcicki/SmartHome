//
//  RegisterViewModel.swift
//
//
//  Created by Kamil Wójcicki on 08/10/2023.
//

import Foundation
import DependencyInjection
import UserInterface

@MainActor
final class RegisterViewModel: ObservableObject {
    
    @Inject private var userManager: UserManagerInterface
    
    @Published var email: String = ""
    @Published var fullname: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    func signUp() async throws {
        try validateField()
        try await userManager.signUp(email: email, password: password)
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
