//
//  PasswordRecoveryViewModel1.swift
//  
//
//  Created by Kamil Wójcicki on 20/10/2023.
//

import DependencyInjection
import Foundation
import Localizations
import UserInterface

@MainActor
final class PasswordRecoveryViewModel: ObservableObject {
    @Inject private var userManager: UserManagerInterface

    @Published var email: String = ""
    
    func resetPassword() async throws {
        try validation()
        try await userManager.resetPassword(withEmail: email)
    }
    
    private func validation() throws {
        try Validation.validateField(email, fieldName: "field_name_email".localized)
        try Validation.validateEmail(email: email)
    }
}
