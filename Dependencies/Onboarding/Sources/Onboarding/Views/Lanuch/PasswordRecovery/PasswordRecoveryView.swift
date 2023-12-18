//
//  PasswordRecoveryView1.swift
//
//
//  Created by Kamil Wójcicki on 20/10/2023.
//

import Components
import Design
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
            .foregroundStyle(Colors.blackOnly)
            .font(.title)
            .multilineTextAlignment(.center)
            .bold()
        
        TextField(textFieldLogin: $viewModel.email, placecholder: "email_textfield".localized)
        
        recoveryButton
    }
    
    private var recoveryButton: some View {
        Text("recovery_button_title".localized)
            .withMainButtonViewModifier()
            .onTapGesture {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("password reset!")
                        
                        launchViewModel.dismissRecoveryView()
                    } catch {
                        self.launchViewModel.handleError(error)
                    }
                }
            }
    }
    
    @ViewBuilder
    private func buildSheet(size: CGSize) -> some View {
        CustomSheet(
            size: size,
            item: $viewModel.activeSheet) { sheet in
                switch sheet {
                case .passwordRecovery:
                    buildPasswordRecoveryContent()
                }
            }
    }
    
    @ViewBuilder
    private func buildPasswordRecoveryContent() -> some View {
        SheetContent(
            variant: .withField(
                field: .text(
                    textFieldText: $viewModel.email,
                    placecholder: "email_textfield".localized
                ),
                labelButtonText: "recovery_button_title".localized,
                action: {
                    try await viewModel.resetPassword()
                    print("password reset!")
                    
                    launchViewModel.dismissRecoveryView()
                }
            )
        )
    }
}
