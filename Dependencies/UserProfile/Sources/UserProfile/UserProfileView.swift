//
//  UserProfileView.swift
//
//
//  Created by Kamil Wójcicki on 09/12/2023.
//

import Components
import Design
import SwiftUI
import PhotosUI
import UserProfileInterface

public struct UserProfileView: View {
    @StateObject private var viewModel = UserProfileViewModel()
    @Environment(\.dismiss) private var dismiss
    public init() { }
    
    public var body: some View {
        ZStack {
            VStack(spacing: 20) {
                buildUserImage()
                
                Spacer()
                
                buildUserEmailRow()
                
                buildUserDisplayNameRow()
                
                if viewModel.user?.providerId == "password" {
                    buildUserPasswordRow()
                }
                
                buildUserMqttKeyRow()
                
                buildUserMqttPasswordRow()
                
                buildDeleteUserRow()
                
                Spacer()
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .tint(Colors.jaffa)
                            .contentShape(Rectangle())
                    }
                }
            }
            .padding()
        }
        .sheet(item: $viewModel.activeSheet) { sheet in
            switch sheet {
            case .changePassword:
                buildChangePasswordContent()
            case .changeDisplayName:
                buildChangeDisplayNameContent()
            case .changeMqttKey:
                buildMqttKeyContent()
            case .changeMqttPassword:
                builMqttPasswordContent()
            case .reauthenticateUser:
                buildReauthenticateUserContent()
            }
        }
        .withAlert(errorTitle: "confirm_delete_account_tile".localized, errorMessageToggle: $viewModel.showAlert) {
            Task {
                do {
                    if viewModel.user?.providerId == "password" {
                        viewModel.showSheet(activeSheet: .reauthenticateUser)
                    } else {
                        try await viewModel.deleteAccountSSO()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        .task {
            try? await viewModel.getCurrentUser()
            try? await viewModel.getProfileImage()
            try? await viewModel.getUserInformations()
        }
    }
}

#Preview {
    UserProfileView()
}

extension UserProfileView {
    @ViewBuilder
    private func buildUserImage() -> some View {
        VStack {
            if let image = viewModel.image {
                if viewModel.showProgressView {
                    ProgressView("uploading_message".localized)
                        .frame(width: 150, height: 150)
                } else {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                }
            } else if let image = viewModel.imageUrl {
                AsyncImage(url: image) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                        .frame(width: 150, height: 150)
                }
            } else {
                Image(systemName: "person.fill")
                    .font(.system(size: 90))
                    .frame(width: 150, height: 150)
            }
        }
        .background {
            Circle()
                .stroke(lineWidth: 3)
        }
        
        PhotosPicker(
            selection: $viewModel.selectedPhoto,
            matching: .images,
            photoLibrary: .shared()
        ) {
            Text("change_photo_photos_picker".localized)
                .foregroundStyle(Colors.jaffa)
        }
    }
}

//Change Password Content
extension UserProfileView {
    @ViewBuilder
    private func buildChangePasswordContent() -> some View {
        SheetContent(
            variant: .withField(
                field: .secure(
                    secureFieldText: $viewModel.newPassword,
                    placecholder: "new_password_placecholder".localized
                ), text: "change_password_tile".localized,
                labelButtonText: "change_password_tile".localized,
                action: {
                    Task {
                        do {
                            try await viewModel.changeUserPassword(newPassword: viewModel.newPassword)
                            viewModel.dismissSheet()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            ), action: {
                viewModel.dismissSheet()
            }
            
        )
    }
}

//Change Display Name Content
extension UserProfileView {
    @ViewBuilder
    private func buildChangeDisplayNameContent() -> some View {
        SheetContent(
            variant: .withField(
                field: .text(
                    textFieldText: $viewModel.userDisplayName,
                    placecholder: "new_display_name_placecholder".localized
                ), text: "change_display_name_tile".localized,
                labelButtonText: "change_display_name_tile".localized,
                action: {
                    Task {
                        do {
                            try await viewModel.changeUserDisplayName(displayName: viewModel.userDisplayName)
                            viewModel.dismissSheet()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            ), action: {
                viewModel.dismissSheet()
            }
        )
    }
}

//Change Mqtt Key Content
extension UserProfileView {
    @ViewBuilder
    private func buildMqttKeyContent() -> some View {
        
        SheetContent(
            variant: .withField(
                field: .text(
                    textFieldText: $viewModel.userMqttKey,
                    placecholder: "new_mqtt_key_placecholder".localized
                ), text: "change_mqtt_key_tile".localized,
                labelButtonText: "change_mqtt_key_tile".localized,
                action: {
                    Task {
                        do {
                            try await viewModel.changeUserMqttKey(newKey: viewModel.userMqttKey)
                            viewModel.dismissSheet()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            ), action: {
                viewModel.dismissSheet()
            }
        )
    }
}

//Change Mqtt Password Content
extension UserProfileView {
    @ViewBuilder
    private func builMqttPasswordContent() -> some View {
        SheetContent(
            variant: .withField(
                field: .secure(
                    secureFieldText: $viewModel.userMqttPassword,
                    placecholder: "new_mqtt_password_placecholder".localized
                ), text: "change_mqtt_password_tile".localized,
                labelButtonText: "change_mqtt_password_tile".localized,
                action: {
                    Task {
                        do {
                            try await viewModel.changeUserMqttPassword(newPassword: viewModel.userMqttPassword)
                            viewModel.dismissSheet()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            ), action: {
                viewModel.dismissSheet()
            }
        )
    }
}

//Reauthenticate User
extension UserProfileView {
    @ViewBuilder
    private func buildReauthenticateUserContent() -> some View {
        SheetContent(
            variant: .withFields(
                fields: [
                    .text(
                        textFieldText: $viewModel.userReauthenticateEmail,
                        placecholder: "Email"
                    ),
                    .secure(
                        secureFieldText: $viewModel.userReauthenticatePassword,
                        placecholder: "Password"
                    )
                ],
                text: "Reauthenticate User",
                labelButtonText: "Reauthenticate User",
                action: {
                    Task {
                        do {
                            try await viewModel.deleteAccount(email: viewModel.userReauthenticateEmail, password: viewModel.userReauthenticatePassword)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            )
        ) {
            viewModel.dismissSheet()
        }
    }
}

//Rows
extension UserProfileView {
    @ViewBuilder
    private func buildUserEmailRow() -> some View {
        Row(
            symbol: "envelope.fill",
            variant: .plainText(
                text: viewModel.user?.email ?? "unknown".localized,
                action: {
                    
                }
            )
        )
    }
    
    @ViewBuilder
    private func buildUserDisplayNameRow() -> some View {
        Row(
            symbol: "person.fill",
            variant: .plainText(
                text: viewModel.userDisplayName,
                action: {
                    viewModel.showSheet(activeSheet: .changeDisplayName)
                }
            )
        )
    }
    
    @ViewBuilder
    private func buildUserPasswordRow() -> some View {
        Row(
            symbol: "key.fill",
            variant: .plainText(
                text: "change_password_tile".localized,
                action: {
                    viewModel.showSheet(activeSheet: .changePassword)
                }
            )
        )
    }
    
    @ViewBuilder
    private func buildUserMqttKeyRow() -> some View {
        Row(
            symbol: "key.radiowaves.forward.fill",
            variant: .plainText(
                text: "change_mqtt_key_tile".localized,
                action: {
                    viewModel.showSheet(activeSheet: .changeMqttKey)
                }
            )
        )
    }
    
    @ViewBuilder
    private func buildUserMqttPasswordRow() -> some View {
        Row(
            symbol: "lock.iphone",
            variant: .plainText(
                text: "change_mqtt_password_tile".localized,
                action: {
                    viewModel.showSheet(activeSheet: .changeMqttPassword)
                }
            )
        )
    }
    
    @ViewBuilder
    private func buildDeleteUserRow() -> some View {
        Row(
            symbol: "person.fill.xmark",
            variant: .plainText(
                text: "delete_Account_tile".localized,
                action: {
                    viewModel.showAlert.toggle()
                }
            )
        )
    }
}
