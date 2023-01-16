//
//  AddTaskView.swift
//  todolistbyvoice
//
//  Created by Adrian Claure on 1/14/23.
//
import SwiftUI

struct AddTaskView: View {
    @State private var title = ""
    @State private var showingAlert = false
    @State private var viewModel = AddTaskViewModel()
    var _onCreate: (Task) -> Void

    var body: some View {
        VStack {
            TextField("Task name", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                let task = Task(id: nil, title: title, description: nil, status: 0, audioPath: nil)
                viewModel.insertTask(task: task)
                self.showingAlert = true
                _onCreate(task)
            }) {
                Text("Add Task")
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Task added"), message: Text("\"\(title)\" has been added to your task list."), dismissButton: .default(Text("OK")))
            }
        }
    }
}
