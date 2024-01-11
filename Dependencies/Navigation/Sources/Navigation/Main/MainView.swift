//
//  MainView.swift
//
//
//  Created by Kamil Wójcicki on 05/11/2023.
//

import SwiftUI
import SliderInfo

public struct MainView: View {
    @StateObject private var viewModel = MainViewModel()

    public init() { }
    
    public var body: some View {
        ZStack {
            if viewModel.showSliderInfo {
                SliderInfoView(showSliderInfo: $viewModel.showSliderInfo)
            } else {
                TabBarView()
            }
        }
        .task {
            try? await viewModel.checkIsFirstLogin()
        }
    }
}

#Preview {
    MainView()
}
