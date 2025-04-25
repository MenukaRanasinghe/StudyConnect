//
//  Session.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-22.
//

import SwiftUI
import Speech

struct GroupMeetingView: View {
    @State private var isRecording = false
    @State private var transcribedText = ""
    @State private var summary = ""
    @State private var savedNotes: [String] = []
    @State private var showPopup = false
    private let speechRecognizer = SpeechRecognizer()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    Button(action: {
                        if isRecording {
                            speechRecognizer.stopTranscribing()
                            summary = generateSummary(from: transcribedText)
                        } else {
                            transcribedText = ""
                            summary = ""
                            speechRecognizer.startTranscribing { text in
                                transcribedText = text
                            }
                        }
                        isRecording.toggle()
                    }) {
                        Label(isRecording ? "Stop Recording" : "Record Session", systemImage: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(isRecording ? Color.red : Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding(.top, 20)
                .padding(.trailing, 20)

                Text("Group Meeting")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Image(systemName: "person.3.sequence.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.blue)

                Text("You're now in the group meeting room.")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                if !transcribedText.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Transcription:")
                            .font(.headline)
                        ScrollView {
                            Text(transcribedText)
                                .font(.body)
                                .foregroundColor(.black)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }

                if !summary.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Summary:")
                            .font(.headline)
                        Text(summary)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                }

                Spacer()

                Button(action: {
                    showPopup = true
                }) {
                    Text("Leave Meeting")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .alert(isPresented: $showPopup) {
                    Alert(
                        title: Text("Leave Meeting"),
                        message: Text("Would you like to summarize and save the meeting notes?"),
                        primaryButton: .default(Text("Summarize and Save")) {
                            saveNote()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
    
    func generateSummary(from text: String) -> String {
        let sentences = text.components(separatedBy: ". ").prefix(2)
        return sentences.joined(separator: ". ") + "."
    }

    func saveNote() {
        if summary.isEmpty {
            summary = generateSummary(from: transcribedText)
        }
        savedNotes.append(summary)
    }
}

struct GroupMeetingView_Previews: PreviewProvider {
    static var previews: some View {
        GroupMeetingView()
    }
}
