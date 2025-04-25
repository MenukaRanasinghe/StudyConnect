//
//  Session.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-22.
//

import SwiftUI
import Speech

struct GroupMeetingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isRecording = false
    @State private var transcribedText = ""
    @State private var summary = ""
    @State private var savedNotes: [String] = []
    @State private var showPopup = false

    let loggedInUser = "Menuka Silva"
    let participants = ["Alex Perera", "Nimali Gunasekara", "Kasun Jayasuriya", "Tharindu Fernando", "Thisara Dissanayake", "Saman Silva"]

    private let speechRecognizer = SpeechRecognizer()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {

                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(.blue)
                        .font(.headline)
                    }

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
                        Label(isRecording ? "Stop Recording" : "Record Session",
                              systemImage: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(isRecording ? Color.red : Color.blue)
                        .cornerRadius(10)
                    }
                }
                .padding(.top, 10)
                .padding(.horizontal)

                Text("Group Meeting")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        
                        VStack(spacing: 8) {
                            ZStack(alignment: .topTrailing) {
                                Rectangle()
                                    .fill(Color.blue.opacity(0.8))
                                    .frame(height: 120)
                                    .cornerRadius(12)
                                    .overlay(
                                        Text(initials(from: loggedInUser))
                                            .font(.largeTitle)
                                            .bold()
                                            .foregroundColor(.white)
                                    )

                                HStack(spacing: 8) {
                                    Image(systemName: "mic.fill")
                                    Image(systemName: "video.fill")
                                }
                                .foregroundColor(.white)
                                .padding(6)
                                .background(Color.black.opacity(0.5))
                                .cornerRadius(8)
                                .padding(6)
                            }
                            Text(loggedInUser)
                                .font(.caption)
                                .bold()
                                .multilineTextAlignment(.center)
                        }

                        ForEach(participants, id: \.self) { participant in
                            VStack(spacing: 8) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.5))
                                    .frame(height: 120)
                                    .cornerRadius(12)
                                    .overlay(
                                        Text(initials(from: participant))
                                            .font(.largeTitle)
                                            .bold()
                                            .foregroundColor(.white)
                                    )
                                Text(participant)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

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
            .navigationBarHidden(true)
        }
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

    func initials(from name: String) -> String {
        let components = name.components(separatedBy: " ")
        let initials = components.compactMap { $0.first }.prefix(2)
        return initials.map { String($0) }.joined().uppercased()
    }
}

struct GroupMeetingView_Previews: PreviewProvider {
    static var previews: some View {
        GroupMeetingView()
    }
}
