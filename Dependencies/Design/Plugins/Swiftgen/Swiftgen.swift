//
//  Swiftgen.swift
//  
//
//  Created by Kamil Wójcicki on 21/09/2023.
//

import PackagePlugin
import Foundation

@main
internal struct SwiftGenPlugin: CommandPlugin {
    internal enum CommandError: Error {
        case lintFailure
        case unknown(exitCode: Int32)
    }

    internal func performCommand(
        context: PackagePlugin.PluginContext,
        arguments: [String]
    ) async throws {
        let process = Process()
        process.launchPath = try context.tool(named: "swiftgen").path.string
        process.arguments = [
            "config",
            "run",
            "--config", "\(context.package.directory.appending("Plugins/Swiftgen/swiftgen.yml"))"
        ]

        process.environment = [
            "PROJECT_DIR": "\(context.package.directory)",
            "DERIVED_SOURCES_DIR:": "\(context.pluginWorkDirectory)"
        ]

        try process.run()
        process.waitUntilExit()

        switch process.terminationStatus {
        case EXIT_SUCCESS:
            break
        case EXIT_FAILURE:
            throw CommandError.lintFailure
        default:
            throw CommandError.unknown(exitCode: process.terminationStatus)
        }
    }
}
