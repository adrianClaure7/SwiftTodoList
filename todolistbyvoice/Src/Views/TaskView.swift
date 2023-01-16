//
//  TaskView.swift
//  todolistbyvoice
//
//  Created by Adrian Claure on 1/14/23.
//

import SwiftUI

struct TaskView: View {
    var task: Task
    @ObservedObject var viewModel: TaskViewModel

    var body: some View {
            VStack {
                Text(viewModel.task.title)
//                Text(viewModel.task.description)
//                Text("Status: \(viewModel.task.status?)")
                HStack {
                    Button("Complete") {
                        self.viewModel.completeTask(status: 1)
                    }
                    Button("Delete") {
                        self.viewModel.deleteTask(id: task.id ?? -1)
                    }
                }
            }
        }
}
