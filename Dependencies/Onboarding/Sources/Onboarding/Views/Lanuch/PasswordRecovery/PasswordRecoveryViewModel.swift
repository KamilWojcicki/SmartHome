//
//  PasswordRecoveryViewModel1.swift
//  
//
//  Created by Kamil Wójcicki on 20/10/2023.
//

import AuthenticationInterface
import DependencyInjection
import Foundation


final class PasswordRecoveryViewModel: ObservableObject {
    @Inject private var authenticationManager: AuthenticationManagerInterface
    @Published var email: String = ""
    
    func resetPassword() async throws {
        try validation()
        try await authenticationManager.resetPassword(email: email)
    }
    
    private func validation() throws {
        try Validation.validateField(email, fieldName: "email")
        try Validation.validateEmail(email: email)
    }
}
