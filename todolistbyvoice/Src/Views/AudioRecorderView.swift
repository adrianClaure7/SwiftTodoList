//
//  AudioRecorderView.swift
//  todolistbyvoice
//
//  Created by Adrian Claure on 1/16/23.
//

import SwiftUI
import AVFoundation

struct AudioRecorderView: View {
    var audioNamePath: String
    var currentTime = 0
    var _setTranscription: (_ transcription: String) -> Void
    var _setAudioPath: (_ audioPath: String) -> Void
    @State var timeRecording: String
    @State var audioRecorder: AudioRecorderModel
    @State var isRecording = false
    @State var isPaused = false
    @State var recordedAudioURL: URL?
    @State var transcription: String = ""
    
    var body: some View {
        VStack {
            if recordedAudioURL == nil {
                HStack {
                    if isRecording || isPaused {
                        Button(action: stopRecording) {
                            Image(systemName: "stop")
                        }
                        Text("\(self.timeRecording)")
                    } else {
                        Button(action: startRecording) {
                            Image(systemName: "mic")
                        }
                        Text("Tap to Record")
                    }
                }
            } else {
                AudioPlayerView(audioUrl: recordedAudioURL, deleteRendering: deleteRecording, showDeleteButton: true)
            }
        }
    }
    
    func startRecording() {
        audioRecorder.requestMicPermission()
        isRecording = true
        startTimer()
    }
    
    func resumeRecording() {
        audioRecorder.resumeRecording()
        isRecording = true
        isPaused = false
        startTimer()
    }
    
    func pauseRecording() {
        audioRecorder.pauseRecording()
        isPaused = true
        isRecording = false
    }
    
    func stopRecording() {
        audioRecorder.stopRecording()
        recordedAudioURL = audioRecorder.getFileURL()
        _setAudioPath(audioRecorder.getFileURL().path)
        self.audioRecorder.transcribeAudio { transcription in
            self.transcription = transcription
            _setTranscription(transcription)
        }
        isRecording = false
    }
    
    func startTimer() {
        if self.isRecording {
            let time = audioRecorder.currentTime()
            let minutes = time / 60
            let seconds = time - minutes * 60
            self.timeRecording = String(format: "%02d:%02d", minutes, seconds)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.startTimer()
            }
        }
    }
    
    func deleteRecording() {
        audioRecorder.deleteRecording()
        _setAudioPath("")
        recordedAudioURL = nil
        isRecording = false
        isPaused = false
    }
}
