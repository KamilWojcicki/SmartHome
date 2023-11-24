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
                        Text("You don't have any tasks.")
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
                            Button("Delete") {
                                viewModel.deleteTask(todo: task)
                            }
                        }
                    }
                }
            }
            .padding(15)
        }
    }
}

#Preview {
    TasksView()
}
