//
//  AddTaskViewModel.swift
//  todolistbyvoice
//
//  Created by Adrian Claure on 1/14/23.
//
import Foundation

class AddTaskViewModel: ObservableObject {
    private var taskDAO: TaskDAO = TaskDAO()
    
    init() {
    }
    
    func insertTask(task: Task) {
        taskDAO.insert(task)
    }
    
    func updateTask(task: Task) {
        taskDAO.update(task)
    }
}
