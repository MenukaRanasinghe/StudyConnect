//
//  AddGroupView.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-23.
//

import SwiftUI
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
                    print("Group Created")
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

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
}

#Preview {
    AddGroupView()
}
