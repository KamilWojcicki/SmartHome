//
//  File.swift
//  
//
//  Created by Kamil Wójcicki on 07/10/2023.
//

import UIKit

extension UIApplication {
    public static var rootViewController: UIViewController? {
        shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController
    }
}
