import Foundation
import AVFoundation
import Speech

class AudioRecorder {
    var transcription: String = ""
    var audioRecorder: AVAudioRecorder!

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

    func stopRecording() {
       
        audioRecorder.stop()
    }

    func transcribeAudio(completion: @escaping (String) -> ()) {
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: getFileURL())

        recognizer?.recognitionTask(with: request) { (result, error) in
            if let error = error {
                print("Error transcribing audio: \(error)")
            } else {
                self.transcription = result?.bestTranscription.formattedString ?? ""
                completion(self.transcription)
            }
        }
    }

    private func getFileURL() -> URL {
        let fileManager = FileManager.default
        let dirPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let soundFileURL = dirPaths[0].appendingPathComponent("recording.m4a")
        return soundFileURL
    }
}
