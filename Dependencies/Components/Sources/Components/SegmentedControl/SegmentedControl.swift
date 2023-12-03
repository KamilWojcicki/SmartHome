//
//  SegmentedControl.swift
//
//
//  Created by Kamil Wójcicki on 12/10/2023.
//

import Design
import Localizations
import SwiftUI

public struct SegmentedControl: View {
    @StateObject private var viewModel: SegmentedControlViewModel
    @Binding private var selectedItem: SegmentedControlViewModel.SelectedItem


    public init(selectedItem: Binding<SegmentedControlViewModel.SelectedItem>,selectedAction: @escaping (Item) -> Void) {
        self._selectedItem = selectedItem
        self._viewModel = StateObject(wrappedValue: SegmentedControlViewModel(selectedAction: selectedAction))
        
    }
    
    public var body: some View {
                HStack(spacing: 0) {
                    
                    ForEach(Item.allCases, content: buildButton)
                }
                .clipShape(.rect(cornerRadius: 15))
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Colors.oxfordBlue, lineWidth: 2)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                
    }
    @ViewBuilder
    private func buildButton(for item: Item) -> some View {
        let isSelected = viewModel.selectedItem == item
        Button {
            viewModel.select(item)
        } label: {
            VStack {
                Text(title(for: item))
                    .tint(isSelected ? Colors.white : Colors.black)
                    .font(.headline)
                    
            }
            .frame(height: 65)
            .frame(maxWidth: .infinity)
        }
        .background(isSelected ? Colors.oxfordBlue : Colors.white)
        .animation(.linear(duration: 0.3), value: isSelected)
    }
    
    private func title(for item: Item) -> String {
        switch item {
        case .register: return "register_button_title".localized
        case .login: return "login_button_title".localized
        }
    }
    public typealias Item = SegmentedControlViewModel.SelectedItem
}

#Preview {
    ZStack {
        Color.red
            
        
        .padding(24)
    }
}
