//
//  AddTaskView.swift
//
//
//  Created by Kamil Wójcicki on 15/10/2023.
//

import SwiftUI
import CalendarInterface
import Design
import DeviceInterface
import Localizations
import ToDoInterface

struct AddTaskView: View {
    @StateObject private var viewModel = AddTaskViewModel()
    var onAdd: (ToDo) -> ()
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 10) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .tint(Colors.whiteOnly)
                        .contentShape(Rectangle())
                }
                
                Text("create_new_task_title".localized)
                    .foregroundStyle(Colors.whiteOnly)
                    .padding(.vertical, 15)
                
                buildTitleView("name_view_title".localized)
                
                TextField("create_new_task_title".localized, text: $viewModel.taskName)
                    .tint(Colors.whiteOnly)
                    .padding(.top, 2)
                
                Divider()
                    .background(Colors.whiteOnly)
                
                HStack {
                    VStack {
                        buildTitleView("device_view_title".localized)
                            .padding(.top, 15)
                        
                        Picker("", selection: $viewModel.selectedDevice) {
                            ForEach(viewModel.availableDevices, id: \.self) { device in
                                Text(device.description).tag(device)
                            }
                        }
                        .tint(Colors.whiteOnly)
                        .font(.headline)
                        .padding(5)
                        .frame(minWidth: 130, maxWidth: .infinity)
                        .background(Colors.jaffa)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .offset(y: 10)
                    }
                    VStack {
                        buildTitleView("action_view_title".localized)
                            .padding(.top, 15)
                        
                        Picker("", selection: $viewModel.selectedAction) {
                            ForEach(Device.State.allCases, id: \.self) { action in
                                Text(action.description).tag(action)
                            }
                        }
                        .tint(Colors.whiteOnly)
                        .font(.headline)
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity)
                        .background(Colors.jaffa)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .offset(y: 10)
                    }
                }
                
                buildTitleView("date_view_title".localized)
                    .padding(.top, 15)
                
                HStack(alignment: .bottom, spacing: 12) {
                    buildDateRow(
                        date: "EEEE dd, MMMM",
                        image: "calendar",
                        dateComponent: .date
                    )
                    
                    buildDateRow(
                        date: "HH:mm",
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
                buildTitleView("description_view_title".localized, Colors.black.opacity(0.4))
                
                TextField("description_placechlder_text".localized, text: $viewModel.taskDescription)
                    .padding(.top, 2)
                
                Rectangle()
                    .fill(Colors.black.opacity(0.2))
                    .frame(height: 1)
                
                Button {
                    Task {
                        do {
                            try await viewModel.addTask(onAdd: onAdd)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    dismiss()
                } label: {
                    Text("create_task_button_title".localized)
                        .foregroundStyle(Colors.whiteOnly)
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
    func buildTitleView(_ value: String, _ color: Color = Colors.whiteOnly.opacity(0.7)) -> some View {
        Text(value)
            .foregroundStyle(color)
    }
    @ViewBuilder
    func buildDateRow(date: String, image: String, dateComponent: DatePickerComponents) -> some View {
        HStack(spacing: 12) {
            Text(viewModel.taskDate.toString(date))
            
            Image(systemName: image)
                .font(.title3)
                .foregroundStyle(Colors.whiteOnly)
                .overlay {
                    DatePicker(
                        "",
                        selection: $viewModel.taskDate,
                        in: Date.now...,
                        displayedComponents: [dateComponent]
                    )
                    .blendMode(.destinationOver)
                }
        }
        .offset(y: -5)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Colors.whiteOnly.opacity(0.7))
                .frame(height: 0.7)
                .offset(y: 5)
        }
    }
}

#Preview {
    AddTaskView { task in
        
    }
}
