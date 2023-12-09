//
//  File.swift
//  
//
//  Created by Kamil Wójcicki on 19/11/2023.
//

import Foundation

extension String {
    func toBoolArray() -> [Bool] {
        if self.first == "3" {
            let pins = Array(self.dropFirst())
            return pins.map { $0 == "1" }
        } else {
            return []
        }
    }
}
