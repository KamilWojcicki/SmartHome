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
import UserInterface

final class DeviceManager: DeviceManagerInterface {
    @Inject private var cloudDatabaseManager: CloudDatabaseManagerInterface
    @Inject private var userManager: UserManagerInterface
    
    var user: User?
    
    private func currentUser() async throws -> User {
            if user == nil {
                self.user = try await userManager.fetchUser()
            }
            
            guard let user = user else {
                throw URLError(.badServerResponse) // custom
            }
            return user
        }
}

extension DeviceManager {
    func readAllUserDevices() async throws -> [Device] {
        let user = try await currentUser()
        return try await cloudDatabaseManager.readAll(parentObject: user, objectsOfType: Device.self)
    }
    
    func updateUserDevice(device: Device, data: [String : Any]) async throws {
        let user = try await currentUser()
        try await cloudDatabaseManager.updateInSubCollection(parentObject: user, object: device, data: data)
    }
    
     func addDevicesToUser() {
        Task {
            do {
                let user = try await currentUser()
                let devices = try await readAllDevices()

                for device in devices {
                    try cloudDatabaseManager.createInSubCollection(parentObject: user, object: device)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    internal func readAllDevices() async throws -> [Device] {
        try await cloudDatabaseManager.readAll(objectsOfType: Device.self)
    }
}
