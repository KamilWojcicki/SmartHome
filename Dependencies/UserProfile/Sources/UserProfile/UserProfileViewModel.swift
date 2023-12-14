//
//  UserProfileViewModel.swift
//
//
//  Created by Kamil Wójcicki on 09/12/2023.
//

import CloudStorageInterface
import DependencyInjection
import Foundation
import PhotosUI
import SwiftUI
import UserInterface
import UserProfileInterface

@MainActor
public final class UserProfileViewModel: ObservableObject {
    @Inject private var cloudStorageManager: CloudStorageInterface
    @Inject private var userManager: UserManagerInterface
    @Published var selectedPhoto: PhotosPickerItem? = nil
    @Published var image: UIImage? = nil
    @Published var imageUrl: URL? = nil
    @Published var user: User? = nil
    @Published var activeSheet: ActiveSheet?
    @Published var newPassword: String = ""
    @Published var userMqttKey: String = ""
    @Published var userMqttPassword: String = ""
    @Published var userDisplayName: String = ""
    
    public init() {
        Task {
            do {
                try await getCurrentUser()
                try await getProfileImage()
                try await getUserInformations()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateUserProfileImagePath(path: String) async throws {
        let data: [String : Any] = [
            User.CodingKeys.profileImagePath.rawValue : path
        ]
        try await userManager.updateUserData(data: data)
    }
    
    func saveProfileImage(item: PhotosPickerItem) async throws {
        guard let user = user else { return }
            guard let data = try await item.loadTransferable(type: Data.self) else { return }
        guard let image = UIImage(data: data) else { return }
            let path = try await cloudStorageManager.saveImage(image: image, userId: user.id)
        print("path", path)
            print("SUCCESS!")
            let url = try await cloudStorageManager.getUrlForImage(path: path)
            try await updateUserProfileImagePath(path: url.absoluteString)
        guard let userProfileImagePath = user.profileImagePath else { return }
        print("user profile image path: ", userProfileImagePath)
        try await getProfileImage()
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
        self.userDisplayName = user.displayName ?? "Unknown"
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
    
    func deleteAccount() async throws {
        guard let user = self.user else { return }
        try await userManager.deleteAccount()
        try await userManager.deleteAllUserData(user: user)
        try userManager.signOut()
        
    }
    
    func showSheet(activeSheet: ActiveSheet) {
        withAnimation {
            self.activeSheet = activeSheet
        }
    }
    
    func dismissSheet() {
        withAnimation {
            self.activeSheet = nil
        }
    }
}
