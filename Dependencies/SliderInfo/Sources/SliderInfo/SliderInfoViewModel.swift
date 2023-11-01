//
//  SliderInfoViewModel.swift
//
//
//  Created by Kamil Wójcicki on 31/10/2023.
//

import DependencyInjection
import Foundation
import SliderInfoInterface
import SwiftUI
import UserInterface

final class SliderInfoViewModel: ObservableObject {
    @Inject private var userManager: UserManagerInterface
    @Published var pageIndex = 0
    @Published var topic: String = ""
    @Published var user: User? = nil
    @Published var showView: Bool = false
    let pages: [Page] = Page.pages
    
    func incrementPage() {
        pageIndex += 1
    }
    
    func toggleView() {
        showView.toggle()
    }
    
    func updateUser() throws {
        do {
            self.user = try userManager.getCurrentUser()
            updateField(user: user)
        } catch {
            throw URLError(.badURL)
        }
        
    }
    
    private func updateField(user: User?) {
        Task {
            do {
                guard let user = user else { return }
                
                try userManager.update(parentObject: User?.none, object: user, data: ["isFirstLogin": false, "email": "testkamil@gmail.com"])
            } catch {
                print(error)
            }
        }
    }
}
