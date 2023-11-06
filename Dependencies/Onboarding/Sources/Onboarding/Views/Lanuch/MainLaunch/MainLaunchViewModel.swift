//
//  MainLaunchViewModel.swift
//
//
//  Created by Kamil Wójcicki on 08/10/2023.
//

import Foundation
import SwiftUI

@MainActor
final class MainLaunchViewModel: ObservableObject {
    @Published var showAlert: Bool = false
    @Published var error: Error?
    @Published var showRecoveryView: Bool = false
    
    func showRecoveryViewToggle() {
        withAnimation(.bouncy) {
            showRecoveryView.toggle()
        }
    }
    
    func handleError(_ error: Error) {
        self.error = error
    }
    
    func showAlertToggle() {
        showAlert.toggle()
    }
}
