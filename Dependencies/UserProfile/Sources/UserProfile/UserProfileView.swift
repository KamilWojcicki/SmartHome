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
        GeometryReader { reader in
            ZStack {
                VStack(spacing: 20) {
                    buildUserImage()
                        .onChange(of: viewModel.selectedPhoto) { newValue in
                            if let newValue {
                                Task {
                                    do {
                                        try await viewModel.saveProfileImage(item: newValue)
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                        }
                    
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
                
                buildSheet(size: reader.size)
            }
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
            if viewModel.imageUrl == nil {
                Image(systemName: "person.fill")
                    .font(.system(size: 90))
                    .frame(width: 150, height: 150)
            } else {
                AsyncImage(url: viewModel.imageUrl) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .id(UUID())
                } placeholder: {
                    ProgressView()
                        .frame(width: 150, height: 150)
                }
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
            Text("Change photo")
        }
    }
    
    @ViewBuilder
    private func buildSheet(size: CGSize) -> some View {
        CustomSheet(size: size, item: $viewModel.activeSheet) { sheet in
            switch sheet {
            case .changePassword:
                buildChangePasswordContent()
            case .changeDisplayName:
                buildChangeDisplayNameContent()
            case .changeMqttKey:
                buildMqttKeyContent()
            case .changeMqttPassword:
                builMqttPasswordContent()
            }
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
                    placecholder: "New Password"
                ),
                labelButtonText: "Change Password",
                action: {
                    try await viewModel.changeUserPassword(newPassword: viewModel.newPassword)
                    viewModel.dismissSheet()
                }
            )
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
                    placecholder: "New Display Name"
                ),
                labelButtonText: "Change Display Name",
                action: {
                    try await viewModel.changeUserDisplayName(displayName: viewModel.userDisplayName)
                    viewModel.dismissSheet()
                }
            )
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
                    placecholder: "New Mqtt Key"
                ),
                labelButtonText: "Change Mqtt Key",
                action: {
                    try await viewModel.changeUserMqttKey(newKey: viewModel.userMqttKey)
                    viewModel.dismissSheet()
                }
            )
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
                    placecholder: "New Mqtt Password"
                ),
                labelButtonText: "Change Mqtt Password",
                action: {
                    try await viewModel.changeUserMqttPassword(newPassword: viewModel.userMqttPassword)
                    viewModel.dismissSheet()
                }
            )
        )
    }
}

//Rows
extension UserProfileView {
    @ViewBuilder
    private func buildUserEmailRow() -> some View {
        Row(
            symbol: "envelope.fill",
            variant: .plainText(
                text: viewModel.user?.email ?? "Unknown",
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
                text: "Change password",
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
                text: "Change Mqtt Key",
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
                text: "Change Mqtt Password",
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
                text: "Delete account",
                action: {
                    Task {
                        do {
                            try await viewModel.deleteAccount()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            )
        )
    }
}
