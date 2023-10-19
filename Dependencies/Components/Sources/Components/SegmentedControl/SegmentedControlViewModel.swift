//
//  SegmentedControlViewModel.swift
//
//
//  Created by Kamil Wójcicki on 12/10/2023.
//

import Foundation

public final class SegmentedControlViewModel: ObservableObject {
    public enum SelectedItem: String ,CaseIterable, Identifiable {
        case register
        case login
        
        
       public var id: String {
            rawValue
        }
    }
    
    @Published private(set) var selectedItem: SelectedItem = .login
    private let selectedAction: (SelectedItem) -> Void
    
    public init(selectedAction: @escaping (SelectedItem) -> Void) {
        self.selectedAction = selectedAction
    }
    func select(_ item: SelectedItem) {
        selectedItem = item
        selectedAction(item)
    }
}
