//
//  UIDevice+Extensions.swift
//
//
//  Created by Kamil Wójcicki on 14/12/2023.
//

import UIKit

extension UIDevice {
    private struct DeviceModel: Decodable {
        let identifier: String
        let model: String
        static var all: [DeviceModel] {
            Bundle
                .module
                .decode([DeviceModel].self, from: "DeviceModels.json")
        }
    }
    
    public var modelName: String {
        #if targetEnvironment(simulator)
            let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
        #else
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
        #endif
        return DeviceModel.all.first(where: { $0.identifier == identifier })?.model ?? identifier
    }
}
