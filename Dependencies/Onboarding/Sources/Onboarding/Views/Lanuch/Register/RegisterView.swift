//
//  RegisterView.swift
//
//
//  Created by Kamil Wójcicki on 08/10/2023.
//

import Components
import Localizations
import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @EnvironmentObject private var launchViewModel: MainLaunchViewModel
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                
                header
                
                registerTextFields
                
                signUpButton
                
                Spacer()
            }
            .padding(.horizontal, 30)
        }
    }
}

#Preview {
    RegisterView()
}

extension RegisterView {
    
    private var header: some View {
        VStack(spacing: 15) {
            Text("register_welcome_title".localized)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("register_welcome_subtitle".localized)
                .font(.title)
                .multilineTextAlignment(.center)
            
            
        }
    }
    
    private var registerTextFields: some View {
        VStack(spacing: 20) {
            TextField(textFieldLogin: $viewModel.email, placecholder: "register_email_placecholder".localized)
            
            TextField(textFieldLogin: $viewModel.fullname, placecholder: "register_fullname_placecholder".localized)
            
            SecureField(textFieldPassword: $viewModel.password, placecholder: "register_password_placecholder".localized)
            
            SecureField(textFieldPassword: $viewModel.confirmPassword, placecholder: "register_confirm_password_placecholder".localized)
        }
        .padding(.top, 20)
    }
    
    private var signUpButton: some View {
        Button {
            Task {
                do {
                    try await viewModel.signUp()
                    print("User added successfully!")
                } catch {
                    self.launchViewModel.handleError(error)
                }
            }
        } label: {
            Text("sign_up_button_title".localized)
                .withMainButtonViewModifier()
        }
    }
}
