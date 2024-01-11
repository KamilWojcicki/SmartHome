//
//  UserProfileViewModel.swift
//
//
//  Created by Kamil Wójcicki on 09/12/2023.
//

import CloudStorageInterface
import DependencyInjection
import Foundation
import Localizations
import PhotosUI
import SwiftUI
import UserInterface
import UserProfileInterface

@MainActor
public final class UserProfileViewModel: ObservableObject {
    @Inject private var cloudStorageManager: CloudStorageInterface
    @Inject private var userManager: UserManagerInterface
    @Published var selectedPhoto: PhotosPickerItem? = nil {
        didSet {
            setImage(from: selectedPhoto)
            showProgressView = true
        }
    }
    @Published var showAlert: Bool = false
    @Published var image: UIImage? = nil
    @Published var imageUrl: URL? = nil
    @Published var user: User? = nil
    @Published var activeSheet: ActiveSheet?
    @Published var newPassword: String = ""
    @Published var userMqttKey: String = ""
    @Published var userMqttPassword: String = ""
    @Published var userDisplayName: String = ""
    @Published var showProgressView: Bool = false
    @Published var userReauthenticateEmail: String = ""
    @Published var userReauthenticatePassword: String = ""
    
    private func updateUserProfileImagePath(path: String) async throws {
        let data: [String : Any] = [
            User.CodingKeys.profileImagePath.rawValue : path
        ]
        try await userManager.updateUserData(data: data)
    }
    
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        
        Task {
            guard let user = user else { return }
            if let data = try? await selection.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    image = uiImage
                    let path = try await cloudStorageManager.saveImage(image: uiImage, userId: user.id)
                    let url = try await cloudStorageManager.getUrlForImage(path: path)
                    try await userManager.updateProfileImagePath(url.absoluteString)
                    showProgressView = false
                    return
                }
            }
        }
    }
    
    func getCurrentUser() async throws {
        self.user = try await userManager.fetchUser()
    }
    
    func getProfileImage() async throws {
        guard let user = user else { return }
        guard let userProfileImagePath = user.profileImagePath else { return }
        self.imageUrl = URL(string: userProfileImagePath)
    }
    
    func getUserInformations() async throws {
        guard let user = user else { return }
        self.userDisplayName = user.displayName ?? "unknown".localized
        self.userMqttKey = user.topic
        self.userMqttPassword = user.mqttPassword
    }
    
    func changeUserPassword(newPassword: String) async throws {
        try await userManager.updatePassword(newPassword: newPassword)
    }
    
    func changeUserDisplayName(displayName: String) async throws {
        let data: [String : Any] = [
            User.CodingKeys.displayName.rawValue : displayName
        ]
        try await userManager.updateUserData(data: data)
    }
    
    func changeUserMqttKey(newKey: String) async throws {
        let data: [String : Any] = [
            User.CodingKeys.topic.rawValue : newKey
        ]
        try await userManager.updateUserData(data: data)
    }
    
    func changeUserMqttPassword(newPassword: String) async throws {
        let data: [String : Any] = [
            User.CodingKeys.mqttPassword.rawValue : newPassword
        ]
        try await userManager.updateUserData(data: data)
    }
    
    func deleteAccount(email: String, password: String) async throws {
        try await userManager.deleteAccount(email: email, password: password)
    }
    
    func deleteAccountSSO() async throws {
        try await userManager.deleteAccountSSO()
    }
    
    func showSheet(activeSheet: ActiveSheet) {
        withAnimation {
            self.activeSheet = activeSheet
        }
    }
    
    func dismissSheet() {
        withAnimation {
            activeSheet = nil
        }
    }
}
