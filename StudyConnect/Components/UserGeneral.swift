//
//  UserGeneral.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-20.
//

import SwiftUI
import PhotosUI

struct UserGeneralView: View {
    @State private var profileImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    
    @State private var name: String = "Nisha De Silva"
    @State private var email: String = "ndsilva@gmail.com"
    @State private var phone: String = "0771234567"
    @State private var locationVisible: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: {
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .font(.title2)
                }
                Spacer()
            }
            .padding(.horizontal)
            
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

            Text(name)
                .font(.headline)
            
            Text(email)
                .foregroundColor(.blue)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color(.systemGray6))
                .cornerRadius(10)

            Group {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
                TextField("Phone", text: $phone)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 2)
            .padding(.horizontal)

            Toggle("Location Visibility", isOn: $locationVisible)
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

            Spacer()

            .padding()
            .background(Color.white.shadow(radius: 4))
        }
        .padding(.top, 20)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

#Preview {
    UserGeneralView()
}
