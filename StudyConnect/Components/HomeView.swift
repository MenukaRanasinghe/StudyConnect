//
//  HomeView.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-19.
//

import SwiftUI

struct HomeView: View {
    @State private var isShowingAddGroup = false

    var body: some View {
        NavigationView {
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

                HStack(spacing: 16) {
                    NavigationLink(destination: GroupDetailsView(groupName: "ABC")) {
                        GradientGroupCardView(
                            gradient: LinearGradient(
                                gradient: Gradient(colors: [Color(hex: "1DD1A1").opacity(0.5), Color(hex: "1DD1A1")]),
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            title: "ABC",
                            subtitle: "Accounting",
                            members: "10+"
                        )
                    }

                    NavigationLink(destination: GroupDetailsView(groupName: "Calculus")) {
                        GradientGroupCardView(
                            gradient: LinearGradient(
                                gradient: Gradient(colors: [Color(hex: "3498DB").opacity(0.5), Color(hex: "3498DB")]),
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            title: "Calculus",
                            subtitle: "Mathematics",
                            members: "30+"
                        )
                    }
                }

                Text("Upcoming Session")
                    .font(.headline)

                UpcomingSessionCard()

                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
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
