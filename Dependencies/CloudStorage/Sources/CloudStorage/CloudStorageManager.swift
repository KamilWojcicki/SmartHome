//
//  CloudStorageManager.swift
//
//
//  Created by Kamil Wójcicki on 09/12/2023.
//

import CloudStorageInterface
import FirebaseStorage
import Foundation
import UIKit

final class CloudStorageManager: CloudStorageInterface {
    private lazy var storage = Storage.storage().reference()
    
    private var imagesReference: StorageReference {
        storage.child("images")
    }
    
    private func userReference(userId: String) -> StorageReference {
        storage.child("Users").child(userId)
    }
    
    private func saveImage(data: Data, userId: String) async throws -> String {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(UUID().uuidString).jpeg"
        let returnedMetaData = try await userReference(userId: userId).child(path).putDataAsync(data, metadata: meta)
        
        guard let returnedPath = returnedMetaData.path else {
            throw URLError(.badServerResponse)
        }
        
        return returnedPath
    }
    
    //SAVE
    func saveImage(image: UIImage, userId: String) async throws -> String {
        guard let data = image.jpegData(compressionQuality: 0.6) else {
            throw URLError(.backgroundSessionWasDisconnected)
        }
        
        return try await saveImage(data: data, userId: userId)
    }
    
    //READ
    func getUrlForImage(path: String) async throws -> URL {
        let result = try await Storage.storage().reference(withPath: path).downloadURL()
        print(result)
        return result
    }
}
