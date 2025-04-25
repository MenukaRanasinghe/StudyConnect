//
//  UserRecordings.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import MobileCoreServices

struct UserRecordingsView: View {
    @State private var recordings: [Recording] = []
    @State private var isUploading = false
    @State private var selectedFileURL: URL? = nil
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @StateObject private var coordinator = RecordingPickerCoordinator()
    
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    selectRecording()
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.white)
                            .padding(.trailing, 5)
                        Text("Add New Recording")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding(.top, 30)
                
                if recordings.isEmpty {
                    Text("No recordings uploaded yet. Add a new recording.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(recordings) { recording in
                        HStack {
                            Image(systemName: getRecordingIcon(for: recording.fileName))
                                .foregroundColor(.blue)
                                .padding(.trailing, 10)
                            
                            VStack(alignment: .leading) {
                                Text(recording.fileName)
                                    .fontWeight(.bold)
                                
                                Text(recording.createdAt, style: .date)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                downloadRecording(recording: recording)
                            }) {
                                Image(systemName: "icloud.and.arrow.down.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .onAppear {
                fetchRecordings()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func fetchRecordings() {
        let db = Firestore.firestore()
        guard let user = Auth.auth().currentUser else { return }
        
        db.collection("recordings") // <-- Changed collection name
            .whereField("userID", isEqualTo: user.uid)
            .getDocuments { snapshot, error in
                if let error = error {
                    alertMessage = "Error fetching recordings: \(error.localizedDescription)"
                    showAlert = true
                } else {
                    recordings = snapshot?.documents.compactMap { document in
                        let data = document.data()
                        let fileName = data["fileName"] as? String ?? "Unknown"
                        let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
                        let fileURL = data["fileURL"] as? String ?? ""
                        return Recording(id: document.documentID, fileName: fileName, createdAt: createdAt, fileURL: fileURL)
                    } ?? []
                }
            }
    }
    
    func selectRecording() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio], asCopy: true)
        documentPicker.delegate = coordinator
        documentPicker.allowsMultipleSelection = false
        documentPicker.modalPresentationStyle = .formSheet
        
        UIApplication.shared.windows.first?.rootViewController?.present(documentPicker, animated: true, completion: nil)
    }
    
    func uploadRecording(fileURL: URL) {
        guard let user = Auth.auth().currentUser else {
            alertMessage = "User not logged in."
            showAlert = true
            return
        }
        
        let ext = fileURL.pathExtension.lowercased()
        let uuid = UUID().uuidString
        let storageRef = Storage.storage().reference().child("recordings/\(uuid).\(ext)")
        let metadata = StorageMetadata()
        metadata.contentType = "audio/\(ext)"
        
        isUploading = true
        
        storageRef.putFile(from: fileURL, metadata: metadata) { metadata, error in
            isUploading = false
            if let error = error {
                alertMessage = "Error uploading recording: \(error.localizedDescription)"
                showAlert = true
            } else {
                saveRecordingMetadata(fileURL: fileURL, userID: user.uid, filePath: storageRef.fullPath)
            }
        }
    }
    
    func saveRecordingMetadata(fileURL: URL, userID: String, filePath: String) {
        let db = Firestore.firestore()
        
        let fileData: [String: Any] = [
            "userID": userID,
            "fileURL": filePath,
            "fileName": fileURL.lastPathComponent,
            "createdAt": Timestamp()
        ]
        
        db.collection("recordings").addDocument(data: fileData) { error in // <-- Changed collection name
            if let error = error {
                alertMessage = "Error saving recording metadata: \(error.localizedDescription)"
                showAlert = true
            } else {
                alertMessage = "Recording uploaded successfully!"
                showAlert = true
                fetchRecordings()
            }
        }
    }
    
    func getRecordingIcon(for fileName: String) -> String {
        if fileName.lowercased().hasSuffix(".mp3") || fileName.lowercased().hasSuffix(".m4a") || fileName.lowercased().hasSuffix(".wav") {
            return "waveform"
        } else {
            return "doc"
        }
    }
    
    func downloadRecording(recording: Recording) {
        let storageRef = Storage.storage().reference(withPath: recording.fileURL)
        let localURL = FileManager.default.temporaryDirectory.appendingPathComponent(recording.fileName)
        
        storageRef.write(toFile: localURL) { url, error in
            if let error = error {
                alertMessage = "Error downloading recording: \(error.localizedDescription)"
                showAlert = true
            } else {
                alertMessage = "Recording downloaded to \(localURL.path)"
                showAlert = true
            }
        }
    }
}

struct Recording: Identifiable {
    var id: String
    var fileName: String
    var createdAt: Date
    var fileURL: String
}

class RecordingPickerCoordinator: NSObject, UIDocumentPickerDelegate, ObservableObject {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let fileURL = urls.first {
            NotificationCenter.default.post(name: .didPickRecording, object: fileURL)
        }
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {}
}

extension Notification.Name {
    static let didPickRecording = Notification.Name("didPickRecording")
}

#Preview {
    UserRecordingsView()
}
