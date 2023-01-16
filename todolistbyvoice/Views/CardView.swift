//
//  CardView.swift
//  todolistbyvoice
//
//  Created by Adrian Claure on 1/15/23.
//
import SwiftUI
import AppKit


struct CardView: View {
    var task: Task
    var viewModel: TaskViewModel
    var _onDelete: (Int) -> Void
    @State private var showMenu = false
    @State private var isChecked = false
    @State private var showDeleteAlert = false

    var body: some View {
        VStack {
            Text(task.title)
                .font(.largeTitle)
                .padding(.top, 15)
            Divider()
            HStack {
                if !task.description!.isEmpty {
                    HStack {
                        Text("Descripcion:")
                            .font(.headline)
                        Text(task.description!)
                            .font(.body)
                    }
                }
                Text("Tarea Completada:")
                    .font(.headline)
                    .padding(.leading, 10)
                    .onTapGesture {
                        self.isChecked = !self.isChecked
                        viewModel.completeTask()
                    }
                Button(action: {
                    self.isChecked = !self.isChecked
                    viewModel.completeTask()
                }) {
                    if isChecked {
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "xmark")
                            .foregroundColor(.red)
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .onTapGesture {
                    self.isChecked = !self.isChecked
                    viewModel.completeTask()
                }
            }
            Divider()
            HStack {
                if task.audioPath != nil && task.audioPath != "" {
                    Button(action: {
                        print("Play task")
                    }) {
                        Image(systemName: "play")
                            .foregroundColor(.green)
                    }
                    Button(action: {
                        print("Download task")
                    }) {
                        Image(systemName: "icloud.and.arrow.down")
                            .foregroundColor(.blue)
                    }
                }
                Button(action: {
                    print("Edit task")
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.yellow)
                }
                Button (action: {
                    self.showDeleteAlert = true
                }){
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .alert(isPresented: $showDeleteAlert) {
                    Alert(title: Text("Delete"), message: Text("Are you sure you want to delete this item?"), primaryButton: .destructive(Text("Delete")) {
                        viewModel.deleteTask(id: task.id ?? -1)
                        _onDelete(task.id ?? -1)
                    }, secondaryButton: .cancel())
                }
            }
            .padding()
            Divider()
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 8)
        .onAppear {
            self.isChecked = task.status == 1 ? true : false
        }
        
    }
}

