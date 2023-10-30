//
//  ErrorHandlingViewModel.swift
//
//
//  Created by Kamil Wójcicki on 08/10/2023.
//

import Foundation

final class ErrorHandlingViewModel: ObservableObject {
    @Published private(set) var errorMessage: String = ""
    @Published var showErrorMessage: Bool = false
}
