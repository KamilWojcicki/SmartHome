//
//  TabBarView.swift
//
//
//  Created by Kamil Wójcicki on 12/10/2023.
//

import SwiftUI
import Design

public struct TabBarView: View {
    @StateObject private var viewModel = TabBarViewModel()
    @Namespace private var namespace
    
    public init() {
        UITabBar.appearance().isHidden = true
    }
    
    public var body: some View {
        let selectedTab = Binding {
            self.viewModel.selectedTab ?? ""
        } set: {
            self.viewModel.selectedTab = $0
        }
        
        ZStack(alignment: .bottom) {
            SwiftUI.TabView(selection: selectedTab) {
                ForEach(viewModel.tabs, id: \.title) { tab in
                    tab.rootView
                }
            }
            buildTabBarView()
                .padding(6)
                .background(
                    Colors.oxfordBlue
                        .ignoresSafeArea(edges: .bottom))
                .cornerRadius(10)
                .shadow(color: Colors.black.opacity(0.3), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
            
        }
    }
    
    private func buildTabBarView() -> some View {
        HStack {
            ForEach(viewModel.tabs, id: \.title) { tab in
                let isSelectedTab = viewModel.selectedTab == tab.title
                
                Spacer()
                
                VStack {
                    Image(systemName: isSelectedTab ? tab.activeImage : tab.image)
                        .font(.title2)
                        .scaleEffect(isSelectedTab ? 1.2 : 1.0)
                    
                    Text(tab.title.capitalized)
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                }
                .foregroundColor(isSelectedTab ? Colors.jaffa : Colors.white)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(
                    ZStack {
                        if isSelectedTab {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Colors.white)
                                .matchedGeometryEffect(id: "background_rectangle", in: namespace)
                        }
                    }
                )
                .onTapGesture {
                    viewModel.tapped(tab: tab.title)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    TabBarView()
}
