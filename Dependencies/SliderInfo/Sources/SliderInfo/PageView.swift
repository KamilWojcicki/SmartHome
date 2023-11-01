//
//  PageView.swift
//
//
//  Created by Kamil Wójcicki on 31/10/2023.
//

import Design
import SliderInfoInterface
import SwiftUI

struct PageView: View {
    let page: Page
    @Binding var textFieldText: String
    
    init(page: Page, textFieldText: Binding<String>) {
        self.page = page
        self._textFieldText = textFieldText
    }
    public var body: some View {
        VStack(spacing: 20) {
            page.animation
                .scaledToFit()
                .frame(height: 350)
                
            Text(page.name)
                .font(.title)
            
            Text(page.description)
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .frame(width: 300)
            
            buildTopicTextField()
        }
    }
    
    @ViewBuilder
    func buildTopicTextField() -> some View {
        VStack(spacing: 0) {
            if page.showTopicField == true {
                TextField("Enter a TOPIC", text: $textFieldText)
                
                     Divider()
            }
        }
        .padding(.horizontal, 50)
    }
}

#Preview {
    PageView(page: Page.samplePage, textFieldText: .constant("Test"))
}
