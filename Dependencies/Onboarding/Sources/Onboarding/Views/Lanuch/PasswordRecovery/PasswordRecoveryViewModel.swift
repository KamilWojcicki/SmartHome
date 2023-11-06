//
//  PasswordRecoveryViewModel1.swift
//  
//
//  Created by Kamil Wójcicki on 20/10/2023.
//

import DependencyInjection
import Foundation
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
        try Validation.validateField(email, fieldName: "email")
        try Validation.validateEmail(email: email)
    }
}
