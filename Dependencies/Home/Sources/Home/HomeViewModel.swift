//
//  HomeViewModel.swift
//  
//
//  Created by Kamil Wójcicki on 02/10/2023.
//

import AuthenticationInterface
import DependencyInjection
import Foundation

final class HomeViewModel: ObservableObject {
    @Inject private var authenticationManager: AuthenticationManagerInterface
    
    func signOut() {
        do {
            try authenticationManager.signOut()
        } catch {
            print(error.localizedDescription)
        }
       
    }
}
