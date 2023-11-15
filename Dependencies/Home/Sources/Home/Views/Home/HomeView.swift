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
import MqttInterface

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @Inject private var mqttManager: MqttManagerInterface
    var body: some View {
        VStack(spacing: 30) {
            
            welcomeTextSection
            
            LottieView(animationConfiguration: .iot, loopMode: .loop)
            
            
            
            Spacer()
        }
        .onAppear {
            viewModel.startTimer()
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
            Text("Welcome back \(Text(viewModel.displayName)),")
                .font(.system(size: 32))
                
            Text("Remember about your today's tasks")
                .font(.system(size: 20))
                
                .foregroundColor(Colors.black.opacity(0.6))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .lineSpacing(7)
        
    }
    
}
