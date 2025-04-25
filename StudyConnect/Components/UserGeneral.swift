//
//  UserGeneral.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-20.
//

import SwiftUI
import PhotosUI
import FirebaseAuth
import FirebaseFirestore

struct UserGeneralView: View {
    @State private var profileImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?

    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var location: String = ""

    let db = Firestore.firestore()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                Text("Edit Profile")
                    .font(.title3)
                    .bold()
                    .padding(.top, -10)

                PhotosPicker(selection: $selectedItem, matching: .images) {
                    ZStack {
                        if let image = profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color(.systemGray5))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.gray)
                                )
                        }
                    }
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            profileImage = uiImage
                        }
                    }
                }

                Group {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                    TextField("Phone", text: $phone)
                    TextField("Location", text: $location)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 2)
                .padding(.horizontal)

                VStack(alignment: .leading) {
                    Text("Activity Hours")
                        .font(.subheadline)
                        .bold()
                    Image(uiImage: UIImage(named: "General-2") ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(8)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 2)
                .padding(.horizontal)

                Button(action: {
                    updateUserData()
                }) {
                    Text("Update")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.top, 20)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .onAppear {
            fetchUserData()
        }
    }

    func fetchUserData() {
        guard let user = Auth.auth().currentUser else {
            print("No user logged in")
            return
        }

        print("Fetching data for user ID: \(user.uid)")

        db.collection("users").document(user.uid).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
                return
            }

            guard let data = snapshot?.data() else {
                print("No data found for user \(user.uid)")
                return
            }

            print("Fetched user data: \(data)")
            name = data["name"] as? String ?? ""
            email = data["email"] as? String ?? ""
            phone = data["phone"] as? String ?? ""
            location = data["location"] as? String ?? ""
        }
    }

    func updateUserData() {
        guard let user = Auth.auth().currentUser else { return }

        let updatedData: [String: Any] = [
            "name": name,
            "email": email,
            "phone": phone,
            "location": location
        ]

        db.collection("users").document(user.uid).updateData(updatedData) { error in
            if let error = error {
                print("Failed to update user: \(error.localizedDescription)")
            } else {
                print("User updated successfully")
            }
        }
    }
}

#Preview {
    UserGeneralView()
}
