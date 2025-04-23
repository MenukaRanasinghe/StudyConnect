//
//  HomeView.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-19.
//

import SwiftUI
import Firebase

struct GroupModel: Identifiable {
    var id: String
    var name: String
    var description: String
    var members: String
    var colorHex: String
}

struct HomeView: View {
    @State private var isShowingAddGroup = false
    @State private var groups: [GroupModel] = []

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 0) {
                                Text("Hello, ")
                                    .font(.title2)
                                    .bold()
                                Text("Shehani")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                            Text("You have 5 sessions today.")
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Button("SOS") {
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)

                        NavigationLink(destination: NotificationsScreen()) {
                            Image(systemName: "bell.fill")
                                .font(.title2)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 16)
                        }
                    }

                    TextField("Search Study Group", text: .constant(""))
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)

                    HStack {
                        Text("Explore Groups")
                            .font(.headline)
                        Spacer()
                        Button(action: {
                            isShowingAddGroup = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                        .sheet(isPresented: $isShowingAddGroup) {
                            AddGroupView()
                        }
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(groups) { group in
                                let gradient = LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(hex: group.colorHex).opacity(0.5),
                                        Color(hex: group.colorHex)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                NavigationLink(destination: GroupDetailsView(groupName: group.name)) {
                                    GradientGroupCardView(
                                        gradient: gradient,
                                        title: group.name,
                                        subtitle: group.description,
                                        members: group.members
                                    )
                                }
                            }
                        }
                        .padding(.vertical)
                        .padding(.horizontal, 4)
                    }

                    Text("Upcoming Session")
                        .font(.headline)

                    UpcomingSessionCard()

                    Spacer()
                }
                .padding()
            }
            .navigationBarHidden(true)
            .onAppear {
                fetchGroups()
            }
        }
    }

    func fetchGroups() {
        let db = Firestore.firestore()
        db.collection("groups").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching groups: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }
            self.groups = documents.map { doc in
                let data = doc.data()
                return GroupModel(
                    id: doc.documentID,
                    name: data["groupName"] as? String ?? "Unnamed",
                    description: data["groupDescription"] as? String ?? "No Description",
                    members: "10+",
                    colorHex: data["selectedColor"] as? String ?? "#3498db"
                )
            }
        }
    }
}

struct GradientGroupCardView: View {
    let gradient: LinearGradient
    let title: String
    let subtitle: String
    let members: String

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading, spacing: 8) {
                Spacer()
                Text(title)
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
                Text(subtitle)
                    .foregroundColor(.white.opacity(0.9))
                Spacer()
            }
            .padding()
            .frame(width: 150, height: 150)
            .background(gradient)
            .cornerRadius(16)

            Text(members)
                .font(.caption)
                .padding(10)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: -4, y: 2)
                .offset(x: -10, y: -10)
        }
    }
}

struct UpcomingSessionCard: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Calculus")
                    .font(.headline)
                Text("Differential calculus Past Paper Discussion")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("12.00 pm")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    HomeView()
}
