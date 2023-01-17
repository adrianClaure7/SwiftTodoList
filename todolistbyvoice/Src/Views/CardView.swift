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
    var _onUpdate: (Task) -> Void
    
    @State private var showMenu = false
    @State private var isChecked = false
    @State private var showDeleteAlert = false
    @State private var showCopyAlert = false
    
    var body: some View {
        VStack {
            Text(task.title)
                .font(.largeTitle)
                .padding(.top, 15)
            Divider()
            VStack {
                if !task.description!.isEmpty {
                    HStack {
                        Text("Descripcion:")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 10)
                        Text(task.description!)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 10)
                    }
                }
                HStack {
                    Text("Tarea Completada:")
                        .font(.headline)
                        .padding(.leading, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onTapGesture {
                            self.isChecked = !self.isChecked
                            viewModel.completeTask(status: self.isChecked ? 1 : 0)
                        }
                    Button(action: {
                        self.isChecked = !self.isChecked
                        viewModel.completeTask(status: self.isChecked ? 1 : 0)
                    }) {
                        if isChecked {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "xmark")
                                .foregroundColor(.red)
                        }
                        
                    }
                    .padding(.leading, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        self.isChecked = !self.isChecked
                        viewModel.completeTask(status: self.isChecked ? 1 : 0)
                    }
                }
            }
            Divider()
            HStack {
                VStack {
                    if task.audioPath != nil && task.audioPath != "" {
                        AudioPlayerView(audioUrl: URL(string: task.audioPath ?? ""))
                    }
                    HStack {
                        if task.audioPath != nil && task.audioPath != "" {
                            Button(action: {
                                viewModel.downloadAudioPath()
                            }) {
                                Image(systemName: "icloud.and.arrow.down")
                                    .foregroundColor(.blue)
                            }
                            Button(action: {
                                copyToClipboard(audioPath: task.audioPath ?? "")
                                self.showCopyAlert = true
                            }) {
                                Image(systemName: "doc.on.doc")
                                    .foregroundColor(.purple)
                            }
                            .alert(isPresented: $showCopyAlert) {
                                Alert(title: Text("Copy to Clipboard"), message: Text("The AudioPath is: \( task.audioPath ?? "")."), dismissButton: .default(Text("OK")))
                            }
                        }
                        EditTaskDialogView(_onUpdate: _onUpdate, task: task)
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
                }
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 8)
        .onAppear {
            self.isChecked = task.status == 1 ? true : false
        }
        
    }
    
    func copyToClipboard(audioPath: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(audioPath, forType: .string)
    }
    
}

struct EditTaskDialogView: View {
    @State private var showDialog = false
    var _onUpdate: (Task) -> Void
    var task: Task
    
    var body: some View {
        Button(action: {
            self.showDialog = true
        }, label: {
            Image(systemName: "pencil")
                .foregroundColor(.yellow)
        })
        .sheet(isPresented: $showDialog) {
            AddTaskView(_onCreate: _onUpdate, _onClose: _onClose, task: task)
        }
    }
    
    func _onClose() {
        self.showDialog = false
    }
}
