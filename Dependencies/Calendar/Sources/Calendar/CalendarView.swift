//
//  CalendarView.swift
//
//
//  Created by Kamil Wójcicki on 13/10/2023.
//

import CalendarInterface
import Components
import Design
import Localizations
import SwiftUI
import Tasks
import ToDoInterface
import Utilities

struct CalendarView: View {
    
    @StateObject private var viewModel = CalendarViewModel()
    
    var body: some View {
        ScrollView(.vertical) {
            buildTimeLineView()
                .padding(15)
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            buildHeaderView()
        }
        .safeAreaInset(edge: .bottom, content: {
            Colors.safeAreaInset.ignoresSafeArea()
                .frame(maxHeight: 70)
        })
        .sheet(isPresented: $viewModel.addNewTask) {
            AddTaskView { task in
                viewModel.tasks.append(task)
            }
        }
        .sheet(isPresented: $viewModel.showTasksList) {
            TasksView()
        }
        .onAppear {
            viewModel.fetchTasks()
        }
        .onDisappear {
            viewModel.stopTimer()
        }
    }
    
    @ViewBuilder
    func buildTimeLineView() -> some View {
        ScrollViewReader { proxy in
            let hours = Calendar.current.hours
            let midHour = hours[hours.count / 2]
            VStack {
                ForEach(hours, id: \.self) { hour in
                    buildTimeLineViewRow(hour)
                        .id(hour)
                }
            }
            .onAppear {
                proxy.scrollTo(midHour)
            }
        }
    }
    @ViewBuilder
    func buildTimeLineViewRow(_ date: Date) -> some View {
        HStack(alignment: .top) {
            Text(date.toString("HH:mm "))
                .font(.caption)
                .frame(width: 45, alignment: .leading)
            
            let filteredTasks = viewModel.filterTasks(for: date)
            
            if filteredTasks.isEmpty {
                Rectangle()
                    .stroke(.gray.opacity(0.5), style: StrokeStyle(lineWidth: 0.5, lineCap: .butt, lineJoin: .bevel, dash: [5], dashPhase: 2))
                    .frame(height: 0.5)
                    .offset(y: 10)
            } else {
                VStack(spacing: 10) {
                    ForEach(filteredTasks) { task in
                        buildTaskRow(task)
                    }
                }
            }
        }
        .hAlign(.leading)
        .padding(.vertical, 15)
    }
    @ViewBuilder
    func buildTaskRow(_ task: ToDo) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(task.taskName.uppercased())
            
            if task.taskDescription != "" {
                Text(task.taskDescription)
            }
        }
        .hAlign(.leading)
        .padding(12)
        .background {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Colors.jaffa)
                    .frame(width: 4)
                
                Rectangle()
                    .fill(Colors.jaffa.opacity(0.3))
            }
        }
    }
    @ViewBuilder
    func buildHeaderView() -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("today_title".localized)
                    
                    Text(String(format: "calendar_welcome_title".localized, viewModel.displayName))
                }
                .hAlign(.leading)
                
                Button {
                    viewModel.showTasksList.toggle()
                } label: {
                    HStack {
                        Image(systemName: "list.bullet.circle")
                        Text("task_lists_button_title".localized)
                            .font(.caption)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background {
                        Capsule()
                            .fill(Colors.jaffa.gradient)
                    }
                    .tint(Colors.white)
                }

                
                Button {
                    viewModel.addNewTask.toggle()
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("add_task_button_title".localized)
                            .font(.caption)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background {
                        Capsule()
                            .fill(Colors.jaffa.gradient)
                    }
                    .tint(Colors.white)
                }
            }
            
            Text(Date().toString("MMM YYYY"))
                .hAlign(.leading)
                .padding(.top, 15)
            
            buildWeekRow()
        }
        .padding(15)
        .background {
            VStack(spacing: 0) {
                Colors.safeAreaInset.ignoresSafeArea()
                
                Rectangle()
                    .fill(
                        .linearGradient(
                            colors: [
                                Colors.safeAreaInset,
                                Color.clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 20)
            }
        }
    }
    @ViewBuilder
    func buildWeekRow() -> some View {
        HStack(spacing: 0) {
            ForEach(Calendar.current.currentWeek) { weekDay in
                let status = Calendar.current.isDate(weekDay.date, inSameDayAs: viewModel.currentDay)
                VStack(spacing: 6) {
                    Text(weekDay.string.prefix(3))
                    
                    Text(weekDay.date.toString("dd"))
                }
                .foregroundStyle(status ? Colors.jaffa: Colors.black)
                .hAlign(.center)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        viewModel.currentDay = weekDay.date
                    }
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, -15)
    }
}

#Preview {
    CalendarView()
}
