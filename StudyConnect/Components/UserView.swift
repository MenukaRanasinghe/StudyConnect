//
//  UserView.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-19.
//

import SwiftUI
import PhotosUI

struct UserView: View {
    @State private var profileImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
            }
            .padding(.horizontal)

            Text("My Profile")
                .font(.title2)
                .bold()
                .padding(.top, -30)
            PhotosPicker(selection: $selectedItem, matching: .images) {
                ZStack {
                    if let image = profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .shadow(radius: 4)
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
                            .shadow(radius: 4)
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

            Text("Nisha De Silva")
                .font(.headline)

            Text("ndsilva@gmail.com")
                .foregroundColor(.blue)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color(.systemGray6))
                .cornerRadius(10)

            VStack(spacing: 16) {
                HStack(spacing: 20) {
                    NavigationLink(destination: UserGeneralView()){
                        profileIcon(title: "General", imageName: "General")
                    }
                   
                    profileIcon(title: "Awards", imageName: "Awards")
                }

                HStack(spacing: 20) {
                    profileIcon(title: "Recordings", imageName: "Recordings")
                    
                    NavigationLink(destination: UserNotesView()){
                        profileIcon(title: "Notes", imageName: "Notes")
                    }
                    
                }
            }

            Spacer()
        }
        .padding(.top, 30)
        .padding(.horizontal)
    }

    func profileIcon(title: String, imageName: String) -> some View {
        VStack {
            Image(imageName)
                .resizable()
                .frame(width: 30, height: 30)
                .padding(10)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
        }
        .frame(width: 120, height: 80)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    UserView()
}
