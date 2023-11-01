//
//  SliderInfoView.swift
//
//
//  Created by Kamil Wójcicki on 31/10/2023.
//

import Design
import SwiftUI
import SliderInfoInterface
import Navigation

public struct SliderInfoView: View {
    @StateObject private var viewModel = SliderInfoViewModel()
    private let dotAppearance = UIPageControl.appearance()
    @AppStorage("isFristLogin") var isFirstLogin: Bool = true

    public init() { }
    
    public var body: some View {
        NavigationStack {
            TabView(selection: $viewModel.pageIndex) {
                ForEach(viewModel.pages) { page in
                    VStack {
                        Spacer()
                        PageView(page: page, textFieldText: $viewModel.topic)
                        Spacer()
                        
                        if page == viewModel.pages.last {
                            Button("Get Started") {
//                                Task {
//                                    do {
//                                        try viewModel.updateUser()
//                                        
//                                    } catch {
//                                        print(error)
//                                    }
//                                }
                                isFirstLogin = false
                                viewModel.toggleView()
                            }
                        } else {
                            Button("Next") {
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
            .navigationDestination(isPresented: $viewModel.showView) {
                TabBarView()
            }
        }
    }
}

#Preview {
    SliderInfoView()
}
