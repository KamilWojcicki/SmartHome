//
//  DeviceManager.swift
//
//
//  Created by Kamil Wójcicki on 15/11/2023.
//

import CloudDatabaseInterface
import DependencyInjection
import DeviceInterface
import Foundation

final class DeviceManager: DeviceManagerInterface {
    @Inject private var cloudDatabaseManager: CloudDatabaseManagerInterface
    
    func readAllDevices() async throws -> [Device] {
        try await cloudDatabaseManager.readAll(objectsOfType: Device.self)
    }
}
