//
//  SettingsViewModel.swift
//
//
//  Created by Kamil Wójcicki on 02/10/2023.
//

import AuthenticationInterface
import DependencyInjection
import Foundation
import SwiftUI

final class SettingsViewModel: ObservableObject {
    @Inject private var authenticationManager: AuthenticationManagerInterface
    
    func signOut() throws {
        try authenticationManager.signOut()
    }
}
