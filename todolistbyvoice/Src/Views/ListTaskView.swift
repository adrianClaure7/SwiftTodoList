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
    @State var selectedTask: Task? = nil
    @State private var showDialog = false

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                TextStyles.topTitle(title: "TODO List").padding(.all, 13)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color.gray)
            Divider().padding(.top, 0)
            NewTaskDialogView(_onCreate: _onCreate)
            Divider()
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(tasks, id: \.id) { task in
                        let taskViewModel = TaskViewModel(task: task, taskDAO: self.taskDAO)
                        CardView(task: task, viewModel: taskViewModel, _onDelete: _onDelete, _onUpdate: _onUpdate)
                    }
                }
                .onAppear {
                    tasks = viewModel.getTasks()
                }
               .padding(.horizontal)
            }
        }
    }
    
    func _onDelete(id: Int) {
        self.tasks = self.viewModel.getTasks()
    }
    
    func _onUpdate(task: Task) {
        self.tasks = self.viewModel.getTasks()
    }
    
    func _onCreate(task: Task) {
        self.tasks = self.viewModel.getTasks()
    }
}

struct NewTaskDialogView: View {
    @State private var showDialog = false
    var _onCreate: (Task) -> Void

    var body: some View {
        VStack {
            Button(action: {
               self.showDialog = true
            }, label: {
               Text("New Task")
            })
            .buttonStyle(GreenButtonStyle())
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .sheet(isPresented: $showDialog) {
                AddTaskView(_onCreate: _onCreate, _onClose: _onClose)
                    .frame(minWidth: 200, maxWidth: 400, minHeight: 300, maxHeight: 500, alignment: .center)
            }
        }
        .padding(.top, 5)
    }

    func _onClose() {
        self.showDialog = false
    }
}
