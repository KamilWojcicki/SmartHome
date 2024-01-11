//
//  SettingsViewModel.swift
//
//
//  Created by Kamil Wójcicki on 02/10/2023.
//

import ContactInterface
import DependencyInjection
import Foundation
import SettingsInterface
import SwiftUI
import UserInterface
import Utilities

final class SettingsViewModel: ObservableObject {
    @Inject private var userManager: UserManagerInterface
    
    @Published var activeSheet: ActiveSheet?
    @Published var isMailComposerPresented: Bool = false
    @Published var showAlert: Bool = false
    var mailData: ContactInterface.MailData {
        .init(
            subject: "mail_composer_case_tile".localized,
            recipients: ["kamilwojcickinjr@gmail.com"],
            body: """
               \(String(format: "mail_composer_model_text".localized, UIDevice.current.modelName))
                \(String(format: "mail_composer_ios_version_text".localized, UIDevice.current.systemVersion))
                \(String(format: "mail_composer_app_version_text".localized, Bundle.main.appVersion))
                
                 \("mail_composer_description_text".localized)
                 --------------------------------------
               """
        )
    }
    
    func signOut() throws {
        try userManager.signOut()
    }
    
    func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
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
    
    func showMailComposer() {
        self.isMailComposerPresented = true
    }
}
