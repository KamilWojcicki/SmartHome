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
import Utilities

struct PasswordRecoveryView: View {
    @EnvironmentObject private var launchViewModel: MainLaunchViewModel
    @StateObject private var viewModel = PasswordRecoveryViewModel()
    
    var body: some View {
            buildContent()
                .onReceive(viewModel.$error) { error in
                    if error != nil {
                        print("Received error: \(error?.localizedDescription ?? "unknown error")")
                        viewModel.showAlertToggle()
                    }
                }
                .withErrorHandler(errorMessage: viewModel.error?.localizedDescription ?? "", errorMessageToggle: $viewModel.showAlert)
    }
}

extension PasswordRecoveryView {
    @ViewBuilder
    private func buildContent() -> some View {
        SheetContent(
            variant: .withField(
                field: .text(
                    textFieldText: $viewModel.email,
                    placecholder: "email_textfield".localized
                ),
                text: "recovery_password_title".localized,
                labelButtonText: "recovery_button_title".localized,
                action: {
                    Task {
                        do {
                            try await viewModel.resetPassword()
                            print("password reset!")
                            launchViewModel.dismissRecoveryView()
                        } catch {
                            print(error.localizedDescription)
                            viewModel.handleError(error)
                        }
                    }
                }
            ), action: {
                launchViewModel.dismissRecoveryView()
            }
        )
    }
}
