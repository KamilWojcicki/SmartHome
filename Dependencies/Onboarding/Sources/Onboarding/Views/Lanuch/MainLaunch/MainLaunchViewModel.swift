//
//  MainLaunchViewModel.swift
//
//
//  Created by Kamil Wójcicki on 08/10/2023.
//

import Foundation

@MainActor
public final class MainLaunchViewModel: ObservableObject {
    @Published var buttonSwitch: Bool = true
    @Published var transition: Bool = false
    @Published var showAlert: Bool = false
    @Published var error: Error?
}
