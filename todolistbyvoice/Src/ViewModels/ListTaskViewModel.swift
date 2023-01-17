//
//  ListTaskViewModel.swift
//  todolistbyvoice
//
//  Created by Adrian Claure on 1/14/23.
//

import Foundation

class ListTaskViewModel: ObservableObject {
    var taskDAO: TaskDAO
    
    init() {
        taskDAO = TaskDAO()
    }
    func getTasks() -> [Task]  {
        let tasks = Task.convertToTasks(taskDAO.selectAll())
        return tasks
    }
}
