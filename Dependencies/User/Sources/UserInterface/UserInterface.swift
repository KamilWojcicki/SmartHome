//
//  UserInterface.swift
//
//
//  Created by Kamil Wójcicki on 03/10/2023.
//

import Foundation

public protocol UserManagerInterface {
    var signInResult: AsyncStream<Bool> { get }
    
    
    func signInAnonymously() async throws
}
