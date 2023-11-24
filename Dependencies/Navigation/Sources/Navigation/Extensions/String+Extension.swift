//
//  File.swift
//  
//
//  Created by Kamil Wójcicki on 22/11/2023.
//

import Foundation

extension String {
    func toBoolArray() -> [Bool] {
        let pins = Array(self.dropFirst())
        return pins.map { $0 == "1" }
    }
}
