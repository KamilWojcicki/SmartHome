//
//  RootView.swift
//
//
//  Created by Kamil Wójcicki on 03/10/2023.
//

import Navigation
import Onboarding
import SwiftUI

public struct RootView: View {
    @StateObject private var viewModel = RootViewModel()
    
    public init() { }
    
    public var body: some View {
        ZStack {
            if viewModel.isLogIn {
                NavView()
            } else {
                MainLaunchView()
            }
        }
        .task {
            await viewModel.updateUserLoginState()
        }
    }
}

#Preview {
    RootView()
}
