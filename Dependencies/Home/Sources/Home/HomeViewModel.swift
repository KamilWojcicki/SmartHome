//
//  HomeViewModel.swift
//  
//
//  Created by Kamil Wójcicki on 02/10/2023.
//

import DependencyInjection
import Foundation
import UserInterface

final class HomeViewModel: ObservableObject {
    @Inject private var userManager: UserManagerInterface
    
}
