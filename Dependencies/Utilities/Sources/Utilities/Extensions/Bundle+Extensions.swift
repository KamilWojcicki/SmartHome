//
//  Bundle+Extensions.swift
//  
//
//  Created by Kamil Wójcicki on 14/12/2023.
//

import Foundation

extension Bundle {
    public var appVersion: String {
        object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "---"
    }
    
    public func decode<T: Decodable>(
        _ type: T.Type,
        from file: String,
        withExtension fileExtension: String? = nil,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    ) -> T {
        guard let url = self.url(forResource: file, withExtension: fileExtension) else {
            fatalError("Error: Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Error: Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Error: Failed to decode \(file) from bundle.")
        }
        
        return loaded
    }

}
