//
//  ContentView.swift
//  todolistbyvoice
//
//  Created by Adrian Claure on 1/13/23.
//

import SwiftUI

struct ContentView: View {
    @State var isMenuOpen: Bool = false
    @State var transcription: String = ""
    var audioRecorder = AudioRecorder()

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Sidebar")
                    .font(.headline)
                    .padding()
                List {
                    Text("Item 1")
                    Text("Item 2")
                    Text("Item 3")
                }
            }
            .frame(width: 150)
            .background(Color.gray)
            
            Spacer()
                        
            VStack {
                   Text("Transcription: \(transcription)")
                   Button("Start Recording") {
                       self.audioRecorder.requestMicPermission()
                   }
                   Button("Stop Recording") {
                       self.audioRecorder.stopRecording()
                       self.audioRecorder.transcribeAudio { transcription in
                           self.transcription = transcription
                       }
                   }
               }
            }
        }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}