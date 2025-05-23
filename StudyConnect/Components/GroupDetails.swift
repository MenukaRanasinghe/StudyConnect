//
//  GroupDetails.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-22.
//

import SwiftUI

struct GroupDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    let groupName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .padding()
                }

                Spacer()

                Button(action: {
                }) {
                    Image(systemName: "ellipsis")
                        .font(.title2)
                        .rotationEffect(.degrees(90))
                        .foregroundColor(.black)
                        .padding()
                }
            }
            .padding(.horizontal)

            Text("Group Details")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)

            VStack(alignment: .leading, spacing: 4) {
                Text(groupName)
                    .font(.title)
                    .fontWeight(.bold)

                Text("By D.S.Silva")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            .padding(.horizontal)

            Image("group")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .cornerRadius(16)
                .padding(.horizontal)

            Text("Welcome to the Differential Calculus Study Group! 📘 This group is for students looking to understand limits, derivatives, and their applications. Join us to collaborate, solve problems, and improve your calculus skills together! 🚀📝")
                .font(.body)
                .padding(.horizontal)

            Text("21 Members")
                .foregroundColor(.gray)
                .font(.subheadline)
                .padding(.horizontal)

            Text("Upcoming Session")
                .font(.headline)
                .padding(.horizontal)

            NavigationLink(destination: GroupSessionsView()) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Calculus")
                            .fontWeight(.semibold)
                        Text("Differential calculus Past Paper Discussion")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Text("12.00 pm")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 3)
                .padding(.horizontal)
            }

            Spacer()
        }
        .padding(.top, 20)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct GroupDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GroupDetailsView(groupName: "Calculus")
        }
    }
}
