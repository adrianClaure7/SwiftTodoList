//
//  AddTaskView.swift
//  todolistbyvoice
//
//  Created by Adrian Claure on 1/14/23.
//
import SwiftUI

struct AddTaskView: View {
    @State private var title = ""
    @State private var description = ""
    @State private var audioPath = ""
    @State private var showingAlert = false
    @State private var viewModel = AddTaskViewModel()
    var _onCreate: (Task) -> Void
    var _onClose: () -> Void
    var task: Task? = nil
    @State var audioNamePath: String = String(describing: Date().timeIntervalSince1970)
    @State var canSave = false
    
    var body: some View {
        VStack {
            Text("Task Form")
                .font(.title)
                .padding()
                .padding(.bottom, 0)
            Divider()
            Text("Task:")
                .font(.headline)
                .padding(.bottom, 0)
            TextField("Task name", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .padding(.bottom, 0)
                .padding(.top, -10)
                .onAppear {
                    if let task = self.task {
                        self.title = task.title
                        self.audioPath = task.audioPath ?? ""
                        self.description = task.description ?? ""
                    }
                }
            AudioRecorderView(audioNamePath: String(describing: Date().timeIntervalSince1970), _setTranscription: _setTranscription, _setAudioPath: _setAudioPath, timeRecording: "00.00", audioRecorder: AudioRecorderModel(audioNamePath: audioNamePath), recordedAudioURL: URL(string: task?.audioPath ?? ""))
            HStack {
                Button(action: {
                    if self.task != nil {
                        let currentAudioPath = audioPath
                        let taskToUpdate = Task(id: self.task?.id, title: $title.wrappedValue, description: $description.wrappedValue, status: self.task?.status, audioPath: currentAudioPath)
                        viewModel.updateTask(task: taskToUpdate)
                        self.showingAlert = true
                        _onCreate(taskToUpdate)
                    } else {
                        var currentAudioPath: String? = nil
                        if !audioPath.isEmpty {
                            currentAudioPath = audioPath
                        }
                        let newTask = Task(id: nil, title: title, description: $description.wrappedValue, status: 0, audioPath: currentAudioPath)
                        viewModel.insertTask(task: newTask)
                        self.showingAlert = true
                        _onCreate(newTask)
                    }
                    _onClose()
                }) {
                    Text("Save")
                }
                .buttonStyle(GreenButtonStyle(isEnabled: !self.title.isEmpty))
                .alert(isPresented: $showingAlert) {
                    let complementaryText: String = self.task != nil ? "updated" : "added"
                    return Alert(title: Text("Task \(complementaryText)"), message: Text("\"\(title)\" has been \(complementaryText) to your task list."), dismissButton: .default(Text("OK")))
                }
                .disabled(self.title.isEmpty)
                Button(action: {
                    _onClose()
                }) {
                    Text("Cancel")
                }
                .buttonStyle(RedButtonStyle())
            }
            .padding(.all, 25)
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 8)
        
    }
    
    func _setAudioPath(audioPath: String) {
        self.audioPath = audioPath
    }
    
    func _setTranscription(transcription: String) {
        self.title = transcription
    }
}
