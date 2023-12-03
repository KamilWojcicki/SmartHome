//
//  HomeView.swift
//
//
//  Created by Kamil Wójcicki on 02/10/2023.
//

import Animation
import Components
import DependencyInjection
import Design
import Localizations
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    var body: some View {
        VStack(spacing: 30) {
            
                welcomeTextSection
                
                weatherSection
                
                LottieView(animationConfiguration: .iot, loopMode: .loop)
                    .padding(.top, -80)
                
                Spacer()
            
        }
        .padding()
        .task {
            await viewModel.getWeather()
        }
    }
}

#Preview {
    HomeView()
}

extension HomeView {
    
    private var welcomeTextSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(String(format: "home_welcome_title".localized, viewModel.displayName))
                .font(.system(size: 32))
                
            Text("home_welcome_subtitle".localized)
                .font(.system(size: 20))
                
                .foregroundColor(Colors.black.opacity(0.6))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .lineSpacing(7)
        
    }
    
    private var weatherSection: some View {
        Tile(variant: .weather(temperature: viewModel.temperature, time: "", date: "", symbol: viewModel.symbol))
    }
    
}
