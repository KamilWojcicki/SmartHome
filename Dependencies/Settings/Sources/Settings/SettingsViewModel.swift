//
//  SettingsViewModel.swift
//
//
//  Created by Kamil Wójcicki on 02/10/2023.
//

import DependencyInjection
import Foundation
import SettingsInterface
import SwiftUI
import UserInterface

final class SettingsViewModel: ObservableObject {
    @Inject private var userManager: UserManagerInterface
    
    @Published var toogle: Bool = false
    @Published var activeSheet: ActiveSheet?
    
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
}
