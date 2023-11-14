//
//  TasksView.swift
//
//
//  Created by Kamil Wójcicki on 01/10/2023.
//

import Components
import Design
import DependencyInjection
import MqttInterface
import SwiftUI
import Utilities

struct TasksView: View {
    @StateObject private var viewModel = TasksViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(viewModel.tasks) { task in
                    Tile(
                        symbol: task.symbol,
                        variant: .device(
                            text: task.taskName,
                            plannedTime: task.dateExecuted.toString("HH:mm, dd.MM.yyyy"),
                            binding:
                              Binding(
                                get: { task.isOn },
                                set: { viewModel.updateToDoStatus(todo: task, isOn: $0) }
                            )
                        )
                    )
                }
            }
            .padding()
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            Colors.white.ignoresSafeArea()
                .frame(height: 0)
        }
        .safeAreaInset(edge: .bottom, content: {
            Colors.white.ignoresSafeArea()
                .frame(maxHeight: 60)
        })
    }
}

#Preview {
    TasksView()
}
