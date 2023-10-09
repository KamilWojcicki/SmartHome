//
//  File.swift
//  
//
//  Created by Kamil Wójcicki on 18/09/2023.
//

import SwiftUI
import Lottie

public struct LottieView: UIViewRepresentable {
    private var animationView = LottieAnimationView()
    private var animationConfiguration: Configuration
    
    public init(animationConfiguration: Configuration) {
        self.animationConfiguration = animationConfiguration
    }
    
    public func makeUIView(context: Context) -> UIView {
        lottieView(
            colorScheme: context.environment.colorScheme,
            view: UIView()
        )
    }
    
    private func lottieView(
        colorScheme: ColorScheme,
        view: UIView
    ) -> UIView {
        
        switch colorScheme {
        case .light:
            animationView.animation = .named(
                animationConfiguration.lightMode.filename,
                bundle: animationConfiguration.lightMode.bundle
            )
        case .dark:
            animationView.animation = .named(
                animationConfiguration.darkMode.filename,
                bundle: animationConfiguration.darkMode.bundle
            )
        @unknown default:
            fatalError()
        }
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    public func updateUIView(
        _ uiView: UIView,
        context: Context
    ) {
        animationView.play()
    }
}
