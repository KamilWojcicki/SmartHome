//
//  CloudStorageInterface.swift
//
//
//  Created by Kamil Wójcicki on 09/12/2023.
//

import Foundation
import UIKit

public protocol CloudStorageInterface {
    func saveImage(data: Data, userId: String) async throws -> String
    func saveImage(image: UIImage, userId: String) async throws -> String
    func getUrlForImage(path :String) async throws -> URL
    func getImage(userId: String, path: String) async throws -> UIImage
}
