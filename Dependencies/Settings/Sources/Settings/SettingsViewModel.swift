//
//  SettingsViewModel.swift
//
//
//  Created by Kamil Wójcicki on 02/10/2023.
//

import DependencyInjection
import Foundation
import SwiftUI
import UserInterface

final class SettingsViewModel: ObservableObject {
    @Inject private var userManager: UserManagerInterface
    
    @Published var toogle: Bool = false
    @Published var selectedOption: String = "English"
    let languageOptions: [String] = [
        "English", "Polish"
    ]
    
    func signOut() throws {
        try userManager.signOut()
    }
}
