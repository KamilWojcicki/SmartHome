//
//  RootView.swift
//
//
//  Created by Kamil Wójcicki on 03/10/2023.
//

import Navigation
import Onboarding
import SliderInfo
import SwiftUI

public struct RootView: View {
    @StateObject private var viewModel = RootViewModel()
    @AppStorage("hasSeenIntro") var hasSeenIntro = false
    
    public init() { }
    
    public var body: some View {
        ZStack {
            if viewModel.isLogIn {
                if viewModel.isFirstLogin {
                    SliderInfoView()
                } else {
                    TabBarView()
                }
            } else {
                MainLaunchView()
            }
        }
        .onAppear {
            print("what is variable in view:\(viewModel.isFirstLogin)")
        }
        .task {
            await viewModel.updateUserLoginState()
        }
    }
}

#Preview {
    RootView()
}
