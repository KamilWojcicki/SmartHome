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
    
    @Published var toogle: Bool = false
    @Published var activeSheet: ActiveSheet?
    @Published var isMailComposerPresented: Bool = false
    
    var mailData: ContactInterface.MailData {
        .init(
            subject: "Case",
            recipients: ["kamilwojcickinjr@gmail.com"],
            body: """
                 Model: \(UIDevice.current.modelName)
                 Wersja iOS: \(UIDevice.current.systemVersion)
                 Wersja aplikacji: \(Bundle.main.appVersion)
                 Opisz swoje zgłoszenie poniżej
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
    
    func showMailComposer() {
        self.isMailComposerPresented = true
    }
}
