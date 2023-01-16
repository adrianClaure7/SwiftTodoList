//
//  AudioPlayerView.swift
//  todolistbyvoice
//
//  Created by Adrian Claure on 1/16/23.
//

import SwiftUI
import AVFoundation

struct AudioPlayerView: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var currentTime = 0.0
    @State private var totalDuration = 0.0
    
    var audioUrl: URL?
    var deleteRendering: (() -> Void?)?
    var showDeleteButton: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.play()
                }) {
                    Image(systemName: "play")
                }
                Button(action: {
                    self.pause()
                }) {
                    Image(systemName: "pause")
                }
                Button(action: {
                    self.stop()
                }) {
                    Image(systemName: "stop")
                }
            }
            .padding(.all, 5)
            HStack {
                Text("\(currentTime, specifier: "%.1f")")
                Slider(value: $currentTime, in: 0...totalDuration, onEditingChanged: { _ in
                    self.audioPlayer?.currentTime = self.currentTime
                })
                Text("\(totalDuration, specifier: "%.1f")")
                if showDeleteButton {
                    Button(action: {
                        deleteRendering!()
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(.all, 5)
        }
        .onAppear(perform: setupAudio)
    }
    
    func setupAudio() {
        do {
            if audioUrl != nil {
                audioPlayer = try AVAudioPlayer(contentsOf: audioUrl!)
                totalDuration = audioPlayer?.duration ?? 0.0
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                    if self.isPlaying {
                        self.currentTime = self.audioPlayer?.currentTime ?? 0.0
                    }
                }
            }
        } catch {
            print("Error loading audio")
        }
    }
    
    func play() {
        audioPlayer?.play()
        isPlaying = true
    }
    
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0.0
        currentTime = 0.0
        isPlaying = false
    }
}

