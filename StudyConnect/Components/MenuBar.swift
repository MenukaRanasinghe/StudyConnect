//
//  MenuBar.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-19.
//

import SwiftUI

struct MenuBar: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case 0:
                        MessageView()
                    case 1:
                        FindView()
                    case 2:
                        HomeView()
                    case 3:
                        UserView()
                    default:
                        Text("Unknown Tab")
                    }
                }
                .frame(maxHeight: .infinity)

                HStack(spacing: 40) {
                    MenuBarItem(defaultImage: "message", selectedImage: "messsage-s", title: "", index: 0, selectedTab: $selectedTab)
                    MenuBarItem(defaultImage: "find", selectedImage: "find-s", title: "", index: 1, selectedTab: $selectedTab)
                    MenuBarItem(defaultImage: "home-2", selectedImage: "home-s-2", title: "", index: 2, selectedTab: $selectedTab)
                    MenuBarItem(defaultImage: "user", selectedImage: "user-s", title: "", index: 3, selectedTab: $selectedTab)
                }
                .padding()
                .cornerRadius(10)
                .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: -2)
            }
        }
    }
}

struct MenuBarItem: View {
    var defaultImage: String
    var selectedImage: String
    var title: String
    var index: Int
    @Binding var selectedTab: Int

    var body: some View {
        VStack {
            Image(selectedTab == index ? selectedImage : defaultImage)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)

            if !title.isEmpty {
                Text(title)
                    .font(.caption)
                    .foregroundColor(selectedTab == index ? .blue : .gray)
            }
        }
        .onTapGesture {
            selectedTab = index
        }
    }
}

#Preview {
    MenuBar()
}
