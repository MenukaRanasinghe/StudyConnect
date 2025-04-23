//
//  AddSessionView.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-23.
//

import SwiftUI
import Firebase

struct AddSessionView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var sessionName: String = ""
    @State private var sessionDate: Date = Date()
    var groupName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Add Session Page")
                .font(.title)
                .padding(.bottom, 10)

            TextField("Session Name", text: $sessionName)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            DatePicker("Date & Time", selection: $sessionDate, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(.compact)

            Button(action: saveSession) {
                Text("Save Session")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
        .navigationBarTitle("Add Session", displayMode: .inline)
    }

    func saveSession() {
        let db = Firestore.firestore()
        let sessionData: [String: Any] = [
            "sessionName": sessionName,
            "sessionDate": Timestamp(date: sessionDate),
            "groupName": groupName 
        ]

        db.collection("sessions").addDocument(data: sessionData) { error in
            if let error = error {
                print("Error saving session: \(error.localizedDescription)")
            } else {
                print("Session saved successfully")
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

#Preview {
    AddSessionView(groupName: "Calculus Study Group")
}
