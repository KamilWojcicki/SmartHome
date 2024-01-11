//
//  TasksView.swift
//
//
//  Created by Kamil Wójcicki on 01/10/2023.
//

import Components
import Design
import DependencyInjection
import Localizations
import MqttInterface
import SwiftUI
import Utilities

public struct TasksView: View {
    @StateObject private var viewModel = TasksViewModel()
    @Environment(\.dismiss) private var dismiss
    
    public init() { }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .tint(Colors.jaffa)
                        .contentShape(Rectangle())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if viewModel.tasks.isEmpty {
                    Text("empty_tasks_title".localized)
                            .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ForEach(viewModel.tasks) { task in
                        Tile(
                            variant: .deviceSchedule(
                                text: task.taskName,
                                plannedTime: task.dateExecuted.toString("HH:mm, dd.MM.yyyy"),
                                state: task.state,
                                symbol: task.symbol
                            )
                        )
                        .contextMenu {
                            Button("delete_task_button_title".localized) {
                                viewModel.deleteTask(todo: task)
                            }
                        }
                    }
                }
            }
            .padding(15)
        }
        .task {
            try? await viewModel.fetchTasks()
        }
    }
}

#Preview {
    TasksView()
}
