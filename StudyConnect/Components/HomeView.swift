//
//  HomeView.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-19.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct GroupModel: Identifiable {
    var id: String
    var name: String
    var description: String
    var members: String
    var colorHex: String
}

struct SessionModel: Identifiable {
    var id: String
    var sessionName: String
    var groupName: String
    var sessionDate: Date
}

struct HomeView: View {
    @State private var isShowingAddGroup = false
    @State private var groups: [GroupModel] = []
    @State private var username: String = ""
    @State private var todaySessionCount: Int = 0
    @State private var upcomingSession: SessionModel?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                headerSection

                TextField("Search Study Group", text: .constant(""))
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                exploreGroupsSection
                if let session = upcomingSession {
                    upcomingSessionSection(session: session)
                } else {
                    dummySessionSection()
                }

                Spacer()
            }
            .padding()
        }
        .navigationBarHidden(false)
        .onAppear {
            fetchUsername()
            fetchGroups()
            fetchTodaySessionCount()
            fetchUpcomingSession()
        }
    }

    var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 0) {
                    Text("Hello, ")
                        .font(.title2)
                        .bold()
                    Text(username)
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                Text("You have \(todaySessionCount) session\(todaySessionCount == 1 ? "" : "s") today.")
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
    }

    var exploreGroupsSection: some View {
        VStack(alignment: .leading) {
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
        }
    }

    func upcomingSessionSection(session: SessionModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            NavigationLink(destination: GroupMeetingView()) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(session.sessionName)
                        .font(.title2)
                        .bold()
                    Text("Group: \(session.groupName)")
                        .foregroundColor(.gray)
                    Text("Date: \(session.sessionDate.formatted(date: .abbreviated, time: .shortened))")
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal)
        .padding(.bottom)
    }

    func dummySessionSection() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            NavigationLink(destination: GroupMeetingView()) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("2015 maths paper discussion")
                        .font(.title2)
                        .bold()
                    Text("Group: Calculus Study Group")
                        .foregroundColor(.gray)
                    Text("Tap to join the session")
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal)
        .padding(.bottom)
    }

    func fetchUsername() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists {
                self.username = document.data()?["name"] as? String ?? "User"
            }
        }
    }

    func fetchGroups() {
        Firestore.firestore().collection("groups").getDocuments { snapshot, error in
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

    func fetchTodaySessionCount() {
        let db = Firestore.firestore()
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!

        db.collection("sessions")
            .whereField("sessionDate", isGreaterThanOrEqualTo: Timestamp(date: startOfDay))
            .whereField("sessionDate", isLessThan: Timestamp(date: endOfDay))
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching today's sessions: \(error.localizedDescription)")
                    return
                }
                self.todaySessionCount = snapshot?.documents.count ?? 0
            }
    }

    func fetchUpcomingSession() {
        let now = Date()
        let db = Firestore.firestore()

        db.collection("sessions")
            .whereField("sessionDate", isGreaterThan: Timestamp(date: now))
            .order(by: "sessionDate")
            .limit(to: 1)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching upcoming session: \(error.localizedDescription)")
                    self.upcomingSession = nil
                    return
                }

                if let doc = snapshot?.documents.first {
                    let data = doc.data()
                    if let timestamp = data["sessionDate"] as? Timestamp {
                        self.upcomingSession = SessionModel(
                            id: doc.documentID,
                            sessionName: data["sessionName"] as? String ?? "Unnamed Session",
                            groupName: data["groupName"] as? String ?? "Unknown Group",
                            sessionDate: timestamp.dateValue()
                        )
                    } else {
                        self.upcomingSession = nil
                    }
                } else {
                    self.upcomingSession = nil
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
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            Text("\(members) Members")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .frame(width: 180, height: 120)
        .background(gradient)
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}

#Preview {
    HomeView()
}
