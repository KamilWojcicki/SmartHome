//
//  MainLaunchView.swift
//
//
//  Created by Kamil Wójcicki on 08/10/2023.
//

import SwiftUI
import Components

public struct MainLaunchView: View {
    @StateObject private var viewModel = MainLaunchViewModel()
    @State private var selectedSegment: SegmentedControlViewModel.SelectedItem = .login
    public init() { }
    
    public var body: some View {
        GeometryReader { reader in
            ZStack {
                buildView(for: selectedSegment)
                
                SegmentedControl(selectedItem: $selectedSegment) { item in
                    selectedSegment = item
                }
                .padding(30)
                
                if viewModel.showRecoveryView {
                    PasswordRecoveryView(size: reader.size)
                }
            }
            .onReceive(viewModel.$error) { error in
                if error != nil {
                    print("Received error: \(error?.localizedDescription ?? "unknown error")")
                    viewModel.showAlertToggle()
                }
            }
            .alert(Text("Error"), isPresented: $viewModel.showAlert, actions: {
                
            }, message: {
                Text(viewModel.error?.localizedDescription ?? "")
            })
            .environmentObject(viewModel)
        }
    }
    
    @ViewBuilder
    private func buildView(for view: SegmentedControlViewModel.SelectedItem) -> some View {
        switch view {
        case .register:
            RegisterView()
        case .login:
            LoginView()
        }
    }
}

#Preview {
    MainLaunchView()
}
