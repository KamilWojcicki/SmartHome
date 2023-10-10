//
//  PasswordRecoveryViewModel.swift
//
//
//  Created by Kamil Wójcicki on 08/10/2023.
//

import Foundation
import DependencyInjection
import AuthenticationInterface

public final class PasswordRecoveryViewModel: ObservableObject {
    
    @Inject private var authenticationManager: AuthenticationManagerInterface
    @Published var email: String = ""
    
    func resetPassword() async throws {
        try validation()
        try await authenticationManager.resetPassword(email: email)
    }
    
    func validation() throws {
        try Validation.validateField(email, fieldName: "email")
    }
}
