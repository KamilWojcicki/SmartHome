//
//  AddTaskView.swift
//
//
//  Created by Kamil Wójcicki on 15/10/2023.
//

import SwiftUI
import CalendarInterface
import Design

struct AddTaskView: View {
    @StateObject private var viewModel = AddTaskViewModel()
    var onAdd: (TaskModel) -> ()
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 10) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .tint(Colors.white)
                        .contentShape(Rectangle())
                }
                
                Text("Create new task")
                    .foregroundStyle(Colors.white)
                    .padding(.vertical, 15)
                
                buildTitleView("NAME")
                
                TextField("Create new task", text: $viewModel.taskName)
                    .tint(Colors.white)
                    .padding(.top, 2)
                
                Divider()
                    .background(Colors.white)
                
                buildTitleView("DATE")
                    .padding(.top, 15)
                
                HStack(alignment: .bottom, spacing: 12) {
                    buildDateRow(
                        date: "EEEE dd, MMMM",
                        image: "calendar",
                        dateComponent: .date
                    )
                    
                    buildDateRow(
                        date: "hh:mm a",
                        image: "clock",
                        dateComponent: .hourAndMinute
                    )
                }
                .padding(.bottom, 15)
            }
            .environment(\.colorScheme, .dark)
            .hAlign(.leading)
            .padding(15)
            .background {
                Colors.oxfordBlue
                    .ignoresSafeArea()
            }
            
            VStack(alignment: .leading, spacing: 10) {
                buildTitleView("DESCRIPTION", Colors.black.opacity(0.4))
                
                TextField("Write a description about your TASK", text: $viewModel.taskDescription)
                    .padding(.top, 2)
                
                Rectangle()
                    .fill(Colors.black.opacity(0.2))
                    .frame(height: 1)
                
                Button {
                    let task = TaskModel(dateAdded: viewModel.taskDate, taskName: viewModel.taskName, taskDescription: viewModel.taskDescription)
                    
                    onAdd(task)
                    dismiss()
                    
                } label: {
                    Text("Create Task")
                        .foregroundStyle(Colors.white)
                        .padding(.vertical, 15)
                        .hAlign(.center)
                        .background {
                            Capsule()
                                .fill(Colors.jaffa.gradient)
                        }
                }
                .vAlign(.bottom)
                .disabled(viewModel.taskName == "")
                .opacity(viewModel.taskName == "" ? 0.6 : 1)
                
            }
            .padding(15)
            
        }
        .vAlign(.top)
    }
    
    @ViewBuilder
    func buildTitleView(_ value: String, _ color: Color = Colors.white.opacity(0.7)) -> some View {
        Text(value)
            .foregroundStyle(color)
    }
    @ViewBuilder
    func buildDateRow(date: String, image: String, dateComponent: DatePickerComponents) -> some View {
        HStack(spacing: 12) {
            Text(viewModel.taskDate.toString(date))
            
            Image(systemName: image)
                .font(.title3)
                .foregroundStyle(Colors.white)
                .overlay {
                    DatePicker("", selection: $viewModel.taskDate, displayedComponents: [dateComponent]
                    )
                    .blendMode(.destinationOver)
                }
        }
        .offset(y: -5)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Colors.white.opacity(0.7))
                .frame(height: 0.7)
                .offset(y: 5)
        }
    }
}

#Preview {
    AddTaskView { task in
        
    }
}
