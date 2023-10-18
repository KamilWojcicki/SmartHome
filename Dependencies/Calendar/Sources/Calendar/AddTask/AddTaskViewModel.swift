//
//  AddTaskViewModel.swift
//
//
//  Created by Kamil Wójcicki on 15/10/2023.
//

import Foundation

public final class AddTaskViewModel: ObservableObject {
    @Published var taskName: String = ""
    @Published var taskDescription: String = ""
    @Published var taskDate: Date = .init()
    
}
