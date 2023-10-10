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
    
    public init() { }
    
    public var body: some View {
        ZStack {
            if viewModel.buttonSwitch {
                LoginView()
            } else {
                RegisterView()
            }
            
            ButtonSwitch(switchButton: $viewModel.buttonSwitch)
                .padding(30)
        }
        .onReceive(viewModel.$error) { error in
            if error != nil {
                print("Received error: \(error?.localizedDescription ?? "diupka")")
                viewModel.showAlert.toggle()
            }
        }
        .alert(Text("Error"), isPresented: $viewModel.showAlert, actions: {
            
        }, message: {
            Text(viewModel.error?.localizedDescription ?? "gilgotanie")
        })
        .environmentObject(viewModel)
    }
}

#Preview {
    MainLaunchView()
}
