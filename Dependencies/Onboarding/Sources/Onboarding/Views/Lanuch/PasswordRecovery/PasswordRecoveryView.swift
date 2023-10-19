//
//  PasswordRecoveryView.swift
//
//
//  Created by Kamil Wójcicki on 08/10/2023.
//

import SwiftUI
import Components

struct PasswordRecoveryView: View {
    @EnvironmentObject private var launchViewModel: MainLaunchViewModel
    @StateObject private var viewModel = PasswordRecoveryViewModel()
    @Binding private var showSheet: Bool
    
    init(showSheet: Binding<Bool>) {
        self._showSheet = showSheet
    }
    
    var body: some View {
        VStack(spacing: 40) {
            
            Text("Enter your e-mail to get a recovery password")
                .multilineTextAlignment(.center)
                .font(.title)
                .bold()
            
            TextField(textFieldLogin: $viewModel.email, placecholder: "Enter your email:")
            
            recoveryButton
            
        }
        .padding(30)
        .alert(launchViewModel.errorMessage ?? "", isPresented: $launchViewModel.showAlert) {
            
        }
    }
}

#Preview {
    PasswordRecoveryView(showSheet: .constant(true))
}

extension PasswordRecoveryView {
    
    private var recoveryButton: some View {
        Button {
            Task {
                do {
                    try await viewModel.resetPassword()
                    print("password reset!")
                    launchViewModel.showAlert = true
                    launchViewModel.errorMessage = "Chuj ci w dupe"
                    showSheet.toggle()
                } catch {
                    self.launchViewModel.showAlert = true
                    self.launchViewModel.errorMessage = error.localizedDescription
                    print(error)
                }
            }
        } label: {
            Text("Recovery now!")
                .withMainButtonViewModifier()
        }
    }
}
