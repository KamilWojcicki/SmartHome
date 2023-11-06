//
//  ToDoManager.swift
//
//
//  Created by Kamil Wójcicki on 06/11/2023.
//

import CloudDatabaseInterface
import DependencyInjection
import Foundation
import ToDoInterface

final class ToDoManager: ToDoManagerInterface {
    @Inject private var cloudDatabaseManager: CloudDatabaseManagerInterface
}
