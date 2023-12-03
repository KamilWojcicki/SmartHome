//
//  LoginViewModel.swift
//
//
//  Created by Kamil Wójcicki on 08/10/2023.
//

import DependencyInjection
import Localizations
import SwiftUI
import UserInterface

final class LoginViewModel: ObservableObject {
    @Inject private var userManager: UserManagerInterface

    @Published var email: String = ""
    @Published var password: String = ""
    
    func signIn() async throws {
        try validateField()
        try await userManager.signIn(withEmail: email, password: password)
    }
    
    private func validateField() throws {
        try Validation.validateField(email, fieldName: "field_name_email".localized)
        try Validation.validateEmail(email: email)
        try Validation.validateField(password, fieldName: "field_name_password".localized)
    }
}
