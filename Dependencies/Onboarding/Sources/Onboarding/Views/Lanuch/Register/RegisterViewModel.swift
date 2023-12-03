//
//  RegisterViewModel.swift
//
//
//  Created by Kamil Wójcicki on 08/10/2023.
//

import Foundation
import DependencyInjection
import Localizations
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
        try await userManager.signUp(withEmail: email, password: password, displayName: fullname)
    }
    
    private func validateField() throws {
        try Validation.validateField(email, fieldName: "field_name_email".localized)
        try Validation.validateEmail(email: email)
        try Validation.validateField(fullname, fieldName: "field_name_fullname".localized)
        try Validation.validateFullname(fullname: fullname)
        try Validation.validateField(password, fieldName: "field_name_password".localized)
        try Validation.validateField(confirmPassword, fieldName: "field_name_confirm_password".localized)
        try Validation.validatePassword(password: password, confirmPassword: confirmPassword)
    }
}
