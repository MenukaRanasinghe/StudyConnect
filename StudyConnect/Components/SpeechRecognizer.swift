//
//  SpeechRecognizer.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-22.
//

import Foundation
import AVFoundation
import Speech

class SpeechRecognizer {
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var request = SFSpeechAudioBufferRecognitionRequest()
    private var recognitionTask: SFSpeechRecognitionTask?

    func startTranscribing(update: @escaping (String) -> Void) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            guard authStatus == .authorized else {
                print("Speech recognition not authorized.")
                return
            }

            do {
                let audioSession = AVAudioSession.sharedInstance()
                try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
                try audioSession.setActive(true)

                let inputNode = self.audioEngine.inputNode
                let recordingFormat = inputNode.outputFormat(forBus: 0)

                inputNode.removeTap(onBus: 0) // just in case
                inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                    self.request.append(buffer)
                }

                self.audioEngine.prepare()
                try self.audioEngine.start()

                self.recognitionTask = self.speechRecognizer.recognitionTask(with: self.request) { result, error in
                    if let result = result {
                        DispatchQueue.main.async {
                            update(result.bestTranscription.formattedString)
                        }
                    } else if let error = error {
                        print("Speech recognition error: \(error.localizedDescription)")
                    }
                }
            } catch {
                print("Audio setup error: \(error)")
            }
        }
    }

    func stopTranscribing() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        request.endAudio()
        recognitionTask?.cancel()
    }
}
