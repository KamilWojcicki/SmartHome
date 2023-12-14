//
//  CloudStorageInterface.swift
//
//
//  Created by Kamil Wójcicki on 09/12/2023.
//

import Foundation

public protocol CloudStorageInterface {
    func saveImage(data: Data) async throws -> (path: String, name: String)
}
