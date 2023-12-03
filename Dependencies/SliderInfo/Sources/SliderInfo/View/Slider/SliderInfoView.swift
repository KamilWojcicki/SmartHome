//
//  SliderInfoView.swift
//
//
//  Created by Kamil Wójcicki on 31/10/2023.
//

import Design
import Localizations
import SwiftUI
import SliderInfoInterface

public struct SliderInfoView: View {
    @StateObject private var viewModel = SliderInfoViewModel()
    private let dotAppearance = UIPageControl.appearance()
    @Binding private var showSliderInfo: Bool
    public init(showSliderInfo: Binding<Bool>) {
        self._showSliderInfo = showSliderInfo
    }
    
    public var body: some View {
        TabView(selection: $viewModel.pageIndex) {
            ForEach(viewModel.pages) { page in
                VStack {
                    Spacer()
                    
                    PageView(page: page, textFieldText: $viewModel.topic, passwordFieldText: $viewModel.password, viewModel: viewModel)
                    
                    Spacer()
                    
                    if page == viewModel.pages.last {
                        Button("get_started_button_title".localized) {
                            Task {
                                do {
                                    try await viewModel.updateUser()
                                    showSliderInfo = false
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    } else {
                        Button("next_button_title".localized) {
                            viewModel.incrementPage()
                        }
                    }
                    
                    Spacer()
                }
                .tag(page.tag)
            }
        }
        .animation(.easeInOut, value: viewModel.pageIndex)
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
        .onAppear {
            dotAppearance.currentPageIndicatorTintColor = UIColor(Colors.jaffa)
            dotAppearance.pageIndicatorTintColor = UIColor(Colors.nobel)
        }
    }
}

#Preview {
    SliderInfoView(showSliderInfo: .constant(true))
}
