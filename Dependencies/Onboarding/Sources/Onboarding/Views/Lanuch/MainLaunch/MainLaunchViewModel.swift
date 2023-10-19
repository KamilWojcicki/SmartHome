//
//  MainLaunchViewModel.swift
//
//
//  Created by Kamil Wójcicki on 08/10/2023.
//

import Foundation
import Combine

final class MainLaunchViewModel: ObservableObject {
    @Published var showAlert: Bool = false
    @Published var error: Error?
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()

    init() {
      $error
        .receive(on: RunLoop.main)
        .sink { [weak self] error in
            self?.showAlert = error != nil
        }
        .store(in: &cancellables)
    }
}
