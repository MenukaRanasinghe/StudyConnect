//
//  NotificationsScreen.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct NotificationsScreen: View {
    @State private var sessions: [Session] = []
    @State private var isLoading = true

    let today = Calendar.current.startOfDay(for: Date())

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Today, \(formattedDate())")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding(.horizontal)

                if isLoading {
                    HStack {
                        Spacer()
                        ProgressView("Loading Sessions...")
                            .progressViewStyle(CircularProgressViewStyle())
                        Spacer()
                    }
                    .padding()
                } else {
                    if sessions.isEmpty {
                        Text("No sessions today!")
                            .font(.headline)
                            .padding(.horizontal)
                    } else {
                        Text("You have sessions today:")
                            .font(.headline)
                            .padding(.horizontal)

                        VStack(spacing: 12) {
                            ForEach(sessions) { session in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(session.sessionName)
                                        .font(.headline)

                                    Text(session.sessionDate, style: .time)
                                        .foregroundColor(.gray)

                                    Text(session.groupName)
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .padding(.top)
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchSessionsForToday()
        }
    }

    func fetchSessionsForToday() {
        let db = Firestore.firestore()
        db.collection("sessions")
            .whereField("sessionDate", isGreaterThanOrEqualTo: today)
            .whereField("sessionDate", isLessThanOrEqualTo: today.addingTimeInterval(24 * 60 * 60))
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching sessions: \(error.localizedDescription)")
                    isLoading = false
                    return
                }

                if let snapshot = snapshot {
                    sessions = snapshot.documents.compactMap { document in
                        try? document.data(as: Session.self)
                    }
                }

                isLoading = false
            }
    }

    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: Date())
    }
}

struct Session: Identifiable, Codable {
    @DocumentID var id: String?
    var sessionName: String
    var sessionDate: Date
    var groupName: String
}

#Preview {
    NavigationStack {
        NotificationsScreen()
    }
}
