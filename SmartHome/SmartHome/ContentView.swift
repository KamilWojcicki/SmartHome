//
//  ContentView.swift
//  SmartHome
//
//  Created by Kamil Wójcicki on 03/10/2023.
//

import SwiftUI
import Components

struct ContentView: View {
    @State private var binding: Bool = false
    var body: some View {
        VStack {
            Row(symbol: "heart.fill", variant: .toggle(text: "test", binding: $binding))
            ButtonSwitch(switchButton: $binding)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
