//
//  AddTaskView.swift
//
//
//  Created by Kamil Wójcicki on 15/10/2023.
//

import SwiftUI
import CalendarInterface

struct AddTaskView: View {
    var onAdd: (TaskModel) -> ()
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Text("Add Task View")
    }
}

#Preview {
    AddTaskView { task in
        
    }
}
