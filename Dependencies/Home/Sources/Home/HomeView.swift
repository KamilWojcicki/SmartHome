//
//  HomeView.swift
//
//
//  Created by Kamil Wójcicki on 02/10/2023.
//

import Animation
import DependencyInjection
import Design
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    var body: some View {
        VStack(spacing: 30) {
            
            welcomeTextSection
            
            LottieView(animationConfiguration: .iot)
            
            Spacer()
        }
        .padding()
        
    }
}

#Preview {
    HomeView()
}

extension HomeView {
    
    private var welcomeTextSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Welcome back Kamil,")
                .font(.system(size: 32))
                
            Text("Remember about your today's tasks")
                .font(.system(size: 20))
                
                .foregroundColor(Colors.black.opacity(0.6))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .lineSpacing(7)
        
    }
    
}
