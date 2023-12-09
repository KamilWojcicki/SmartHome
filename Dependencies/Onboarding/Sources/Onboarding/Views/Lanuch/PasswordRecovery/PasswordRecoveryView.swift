//
//  PasswordRecoveryView1.swift
//
//
//  Created by Kamil Wójcicki on 20/10/2023.
//

import Components
import Localizations
import SwiftUI

struct PasswordRecoveryView: View {
    @EnvironmentObject private var launchViewModel: MainLaunchViewModel
    @StateObject private var viewModel = PasswordRecoveryViewModel()
    
    var body: some View {
        buildContent()
    }
}

extension PasswordRecoveryView {
    @ViewBuilder
    private func buildContent() -> some View {
        Text("recovery_password_title".localized)
            .font(.title)
            .multilineTextAlignment(.center)
            .bold()
        
        TextField(textFieldLogin: $viewModel.email, placecholder: "email_textfield".localized)
        
        recoveryButton
    }
    
    private var recoveryButton: some View {
        Button {
            Task {
                do {
                    try await viewModel.resetPassword()
                    print("password reset!")
                    
                    launchViewModel.dismissRecoveryView()
                } catch {
                    self.launchViewModel.handleError(error)
                }
            }
        } label: {
            Text("recovery_button_title".localized)
                .withMainButtonViewModifier()
        }
    }
}
