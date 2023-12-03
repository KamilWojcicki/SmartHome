//
//  PageView.swift
//
//
//  Created by Kamil Wójcicki on 31/10/2023.
//

import Design
import Localizations
import SliderInfoInterface
import SwiftUI

struct PageView: View {
    private let page: Page
    @Binding private var textFieldText: String
    @Binding private var passwordFieldText: String
    @ObservedObject var viewModel : SliderInfoViewModel
    
    init(page: Page, textFieldText: Binding<String>, passwordFieldText: Binding<String>, viewModel: SliderInfoViewModel) {
        self.page = page
        self._textFieldText = textFieldText
        self._passwordFieldText = passwordFieldText
        self.viewModel = viewModel
    }
    var body: some View {
        VStack(spacing: 20) {
            page.animation
                .scaledToFit()
                .frame(height: 350)
            
            Text(page.name)
                .font(.title)
                .multilineTextAlignment(.center)
            
            Text(page.description)
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .frame(width: 300)
            
            buildTopicTextField()
        }
    }
    
    @ViewBuilder
    func buildTopicTextField() -> some View {
        VStack(spacing: 15) {
            if page.showTopicField == true {
                VStack(spacing: 0) {
                    TextField("key_textfield".localized, text: $textFieldText)
                        .textInputAutocapitalization(.never)
                    
                    Divider()
                    
                }
                VStack(spacing: 0) {
                    SecureField("password_textfield".localized, text: $passwordFieldText)
                        .textInputAutocapitalization(.never)
                    
                    Divider()
                }
                
            } else if page.showDeviceList == true {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                    ForEach(viewModel.devices, id: \.self) { device in
                        HStack(spacing: 10) {
                            Image(systemName: viewModel.userDevices.contains(device) ? "checkmark.circle.fill" : "checkmark.circle")
                                .foregroundStyle(viewModel.userDevices.contains(device) ? Color.green : Color.black)
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.buttonIsPressed(device: device)
                                    }
                                }
                            Image(systemName: device.symbol)
                            Text(device.deviceName)
                        }
                        .frame(maxWidth: 250, alignment: .leading)
                        .font(.body)
                    }
                }

            }
        }
        .padding(.horizontal, 50)
    }
}

#Preview {
    PageView(page: Page.samplePage, textFieldText: .constant("Test"), passwordFieldText: .constant("Test"), viewModel: SliderInfoViewModel())
}
