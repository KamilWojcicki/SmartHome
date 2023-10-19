//
//  PasswordRecoveryViewModel.swift
//
//
//  Created by Kamil Wójcicki on 08/10/2023.
//

import Foundation
import SwiftUI
import DependencyInjection
import AuthenticationInterface
import OnboardingInterface

final class PasswordRecoveryViewModel: ObservableObject {
    
    @Inject private var authenticationManager: AuthenticationManagerInterface
    @Published var email: String = ""
    
    func resetPassword() async throws {
        try validation()
        print("dupa")
        try await authenticationManager.resetPassword(email: email)
        print("dupa po")
    }
    
    func validation() throws {
        try Validation.validateField(email, fieldName: "email")
        try Validation.validateEmail(email: email)
    }
}
