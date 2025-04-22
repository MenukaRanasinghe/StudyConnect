//
//  UserNotes.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-21.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import MobileCoreServices

struct UserNotesView: View {
    @State private var files: [File] = []
    @State private var isUploading = false
    @State private var selectedFileURL: URL? = nil
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @StateObject private var coordinator = DocumentPickerCoordinator()
    
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    selectFile()
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.white)
                            .padding(.trailing, 5)
                        Text("Add New File")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding(.top, 30)
                
                if files.isEmpty {
                    Text("No files uploaded yet. Add a new file.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(files) { file in
                        HStack {
                            Image(systemName: getFileIcon(for: file.fileName))
                                .foregroundColor(.blue)
                                .padding(.trailing, 10)
                            
                            VStack(alignment: .leading) {
                                Text(file.fileName)
                                    .fontWeight(.bold)
                                
                                Text(file.createdAt, style: .date)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                downloadFile(file: file)
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
                fetchFiles()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func fetchFiles() {
        let db = Firestore.firestore()
        guard let user = Auth.auth().currentUser else { return }
        
        db.collection("user_files")
            .whereField("userID", isEqualTo: user.uid)
            .getDocuments { snapshot, error in
                if let error = error {
                    alertMessage = "Error fetching files: \(error.localizedDescription)"
                    showAlert = true
                } else {
                    files = snapshot?.documents.compactMap { document in
                        let data = document.data()
                        let fileName = data["fileName"] as? String ?? "Unknown"
                        let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
                        let fileURL = data["fileURL"] as? String ?? ""
                        return File(id: document.documentID, fileName: fileName, createdAt: createdAt, fileURL: fileURL)
                    } ?? []
                }
            }
    }
    
    func selectFile() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf, .plainText, .image], asCopy: true)
        documentPicker.delegate = coordinator
        documentPicker.allowsMultipleSelection = false
        documentPicker.modalPresentationStyle = .formSheet
        
        UIApplication.shared.windows.first?.rootViewController?.present(documentPicker, animated: true, completion: nil)
    }
    
    func uploadFile(fileURL: URL) {
        guard let user = Auth.auth().currentUser else {
            alertMessage = "User not logged in."
            showAlert = true
            return
        }
        
        let storageRef = Storage.storage().reference().child("files/\(UUID().uuidString).pdf")
        let metadata = StorageMetadata()
        metadata.contentType = "application/pdf"
        
        isUploading = true
        
        storageRef.putFile(from: fileURL, metadata: metadata) { metadata, error in
            isUploading = false
            if let error = error {
                alertMessage = "Error uploading file: \(error.localizedDescription)"
                showAlert = true
            } else {
                saveFileMetadata(fileURL: fileURL, userID: user.uid, filePath: storageRef.fullPath)
            }
        }
    }
    
    func saveFileMetadata(fileURL: URL, userID: String, filePath: String) {
        let db = Firestore.firestore()
        
        let fileData: [String: Any] = [
            "userID": userID,
            "fileURL": filePath,
            "fileName": fileURL.lastPathComponent,
            "createdAt": Timestamp()
        ]
        
        db.collection("user_files").addDocument(data: fileData) { error in
            if let error = error {
                alertMessage = "Error saving file metadata: \(error.localizedDescription)"
                showAlert = true
            } else {
                alertMessage = "File uploaded successfully!"
                showAlert = true
                fetchFiles()
            }
        }
    }
    
    func getFileIcon(for fileName: String) -> String {
        if fileName.lowercased().hasSuffix(".pdf") {
            return "doc.text"
        } else if fileName.lowercased().hasSuffix(".jpg") || fileName.lowercased().hasSuffix(".png") {
            return "photo"
        } else {
            return "doc"
        }
    }
    
    func downloadFile(file: File) {
        let storageRef = Storage.storage().reference(withPath: file.fileURL)
        
        let localURL = FileManager.default.temporaryDirectory.appendingPathComponent(file.fileName)
        
        storageRef.write(toFile: localURL) { url, error in
            if let error = error {
                alertMessage = "Error downloading file: \(error.localizedDescription)"
                showAlert = true
            } else {
                alertMessage = "File downloaded to \(localURL.path)"
                showAlert = true
            }
        }
    }
}

struct File: Identifiable {
    var id: String
    var fileName: String
    var createdAt: Date
    var fileURL: String
}

class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate, ObservableObject {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let fileURL = urls.first {
            (UIApplication.shared.windows.first?.rootViewController as? UserNotesView)?.uploadFile(fileURL: fileURL)
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    }
}

#Preview {
    UserNotesView()
}
