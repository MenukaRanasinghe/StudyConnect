//
//  NotificationsScreen.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct Session: Identifiable {
    var id: String
    var sessionName: String
    var sessionDate: Date
    var groupName: String
}

struct NotificationsScreen: View {
    @State private var sessions: [Session] = []
    @State private var isLoading = true

    @Environment(\.dismiss) private var dismiss

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

                        HStack {
                            Spacer()
                            VStack(spacing: 16) {
                                ForEach(sessions) { session in
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Text(session.sessionName)
                                                .font(.headline)
                                            Spacer()
                                            Text(session.sessionDate, style: .time)
                                                .foregroundColor(.gray)
                                                .font(.subheadline)
                                        }
                                        Text(session.groupName)
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                                    .frame(maxWidth: 500)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            Spacer()
                        }
                    }
                }
            }
            .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground).ignoresSafeArea())
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
                        let data = document.data()
                        guard let sessionName = data["sessionName"] as? String,
                              let groupName = data["groupName"] as? String,
                              let timestamp = data["sessionDate"] as? Timestamp else {
                            return nil
                        }
                        let sessionDate = timestamp.dateValue()
                        return Session(
                            id: document.documentID,
                            sessionName: sessionName,
                            sessionDate: sessionDate,
                            groupName: groupName
                        )
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

#Preview{
    NotificationsScreen()
}
