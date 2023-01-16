//
//  ListTaskView.swift
//  todolistbyvoice
//
//  Created by Adrian Claure on 1/14/23.
//
import SwiftUI

struct ListTaskView: View {
    var taskDAO = TaskDAO()
    @ObservedObject var viewModel: ListTaskViewModel = ListTaskViewModel()
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    @State var tasks: [Task] = []

    var body: some View {
        AddTaskView(_onCreate: _onCreate)
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(tasks, id: \.id) { task in
                let taskViewModel = TaskViewModel(task: task, taskDAO: self.taskDAO)
                CardView(task: task, viewModel: taskViewModel, _onDelete: _onDelete)
           }
        }
        .onAppear {
            tasks = viewModel.getTasks()
        }
       .padding(.horizontal)
    }
    
    func _onDelete(id: Int) {
        self.tasks = self.viewModel.getTasks()
    }
    
    func _onCreate(task: Task) {
        self.tasks = self.viewModel.getTasks()
    }
}
