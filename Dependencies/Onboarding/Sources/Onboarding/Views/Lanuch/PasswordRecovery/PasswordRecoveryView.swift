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
    
    let size: CGSize
    
    var body: some View {
        ZStack(alignment: .bottom) {
            background
            
            VStack(spacing: 40) {
                VStack {
                    Button {
                        launchViewModel.showRecoveryViewToggle()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(20)
                
                Text("recovery_password_title".localized)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .bold()
                
                TextField(textFieldLogin: $viewModel.email, placecholder: "email_textfield".localized)
                
                recoveryButton
            }
            .padding(.horizontal)
            .frame(width: size.width, height: size.height * 0.6)
            .background {
                RoundedRectangle(cornerRadius: 50)
                    .fill(Color.white)
                    .edgesIgnoringSafeArea(.bottom)
            }
            .offset(y: launchViewModel.showRecoveryView ? size.height * 0 : size.height * 1)
        }
    }
}

extension PasswordRecoveryView {
    private var background: some View {
        Rectangle()
            .fill(.ultraThinMaterial)
            .ignoresSafeArea()
            .opacity(launchViewModel.showRecoveryView ? 1 : 0)
    }
    
    private var recoveryButton: some View {
        Button {
            Task {
                do {
                    try await viewModel.resetPassword()
                    print("password reset!")
                    
                    launchViewModel.showRecoveryViewToggle()
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
