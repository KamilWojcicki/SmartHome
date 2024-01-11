//
//  MainLaunchViewModel.swift
//
//
//  Created by Kamil Wójcicki on 08/10/2023.
//

import Foundation
import OnboardingInterface
import SwiftUI

@MainActor
final class MainLaunchViewModel: ObservableObject {
    @Published var showAlert: Bool = false
    @Published var error: Error?
    @Published var activeSheet: ActiveSheet?
    
    func dismissRecoveryView() {
        withAnimation(.bouncy) {
            activeSheet = nil
        }
    }
    
    func showRecoveryView(activeSheet: ActiveSheet) {
        withAnimation(.bouncy) {
            self.activeSheet = activeSheet
        }
    }
    
    func handleError(_ error: Error) {
        self.error = error
    }
    
    func showAlertToggle() {
        showAlert.toggle()
    }
}
