//
//  AddGroupView.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-23.
//

import SwiftUI
import Firebase
import FirebaseStorage
import UIKit

struct AddGroupView: View {
    @State private var groupName = ""
    @State private var groupDescription = ""
    @State private var adminName = ""
    @State private var selectedColor: Color = .blue
    @State private var groupImage: UIImage? = nil
    @State private var showImagePicker = false

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Create New Group")
                    .font(.largeTitle)
                    .bold()

                TextField("Group Name", text: $groupName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                TextField("Group Description", text: $groupDescription)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                TextField("Admin Name", text: $adminName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                ColorPicker("Select Background Color", selection: $selectedColor)
                    .padding()

                Button(action: {
                    showImagePicker.toggle()
                }) {
                    Text(groupImage == nil ? "Choose Group Image" : "Image Selected")
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(image: $groupImage)
                }

                Spacer()

                Button(action: {
                    saveGroupToFirebase()
                }) {
                    Text("Create Group")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.top, 20)

                Spacer()
            }
            .padding()
        }
    }

    func saveGroupToFirebase() {
        guard !groupName.isEmpty, !groupDescription.isEmpty, !adminName.isEmpty else {
            print("Please fill in all fields")
            return
        }

        var groupData: [String: Any] = [
            "groupName": groupName,
            "groupDescription": groupDescription,
            "adminName": adminName,
            "selectedColor": selectedColor.toHex(),
            "createdAt": Timestamp()
        ]

        if let image = groupImage, let imageData = image.jpegData(compressionQuality: 0.8) {
            let imageID = UUID().uuidString
            let storageRef = Storage.storage().reference().child("group_images/\(imageID).jpg")

            storageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    print("Image upload error: \(error.localizedDescription)")
                    return
                }

                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Download URL error: \(error.localizedDescription)")
                        return
                    }

                    if let url = url {
                        groupData["groupImageUrl"] = url.absoluteString
                        saveGroupToFirestore(groupData: groupData)
                    }
                }
            }
        } else {
            saveGroupToFirestore(groupData: groupData)
        }
    }

    func saveGroupToFirestore(groupData: [String: Any]) {
        let db = Firestore.firestore()
        db.collection("groups").addDocument(data: groupData) { error in
            if let error = error {
                print("Firestore save error: \(error.localizedDescription)")
            } else {
                print("✅ Group created successfully")
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct ImagePicker: View {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ImagePickerControllerWrapper(image: $image, presentationMode: _presentationMode)
    }
}

struct ImagePickerControllerWrapper: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePickerControllerWrapper

        init(parent: ImagePickerControllerWrapper) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.image = selectedImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

extension Color {
    func toHex() -> String {
        let uiColor = UIColor(self)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rgb = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255)
        return String(format: "#%06x", rgb)
    }
}

#Preview {
    AddGroupView()
}
