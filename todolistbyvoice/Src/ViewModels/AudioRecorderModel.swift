import Foundation
import AVFoundation
import Speech

class AudioRecorderModel {
    var transcription: String = ""
    var audioRecorder: AVAudioRecorder!
    var audioNamePath: String
    
    init(audioNamePath: String) {
        self.audioNamePath = audioNamePath
    }
    func requestMicPermission() {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            if granted {
                print("Permission granted")
                self.checkMicAvailability()
            } else {
                print("Permission denied")
            }
        }
    }
    
    func currentTime() -> Int {
        return Int(audioRecorder == nil ? 0 : audioRecorder.currentTime)
    }
    
    func checkMicAvailability() {
        let mic = AVCaptureDevice.default(for: .audio)
        if mic != nil {
            print("Microphone is available")
            self.startRecording()
        } else {
            print("Microphone is not available")
        }
    }
    
    func startRecording() {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            audioRecorder = try AVAudioRecorder(url: self.getFileURL(), settings: settings)
            audioRecorder.record()
            print("Recording started")
        } catch {
            print("Error starting recording: \(error.localizedDescription)")
        }
    }
    
    func pauseRecording() {
        if audioRecorder.isRecording {
            audioRecorder.pause()
        }
    }
    
    func resumeRecording() {
        audioRecorder.record()
    }
    
    
    func stopRecording() {
        audioRecorder.stop()
    }
    
    func transcribeAudio(completion: @escaping (String) -> ()) {
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: self.getFileURL())
        
        recognizer?.recognitionTask(with: request) { (result, error) in
            if let error = error {
                print("Error transcribing audio: \(error)")
            } else {
                self.transcription = result?.bestTranscription.formattedString ?? ""
                completion(self.transcription)
            }
        }
    }
    
    func deleteRecording() {
        
    }
    
    func getFileURL() -> URL {
        let fileManager = FileManager.default
        let dirPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let soundFileURL = dirPaths[0].appendingPathComponent("records/\(self.audioNamePath).m4a")
        
        let dirURL = soundFileURL.deletingLastPathComponent()
        if !fileManager.fileExists(atPath: dirURL.path) {
            do {
                try fileManager.createDirectory(at: dirURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating directory: \(error)")
            }
        }
        
        return soundFileURL
    }
}
