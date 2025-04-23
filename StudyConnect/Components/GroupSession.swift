//
//  GroupSession.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-23.
//

import SwiftUI

struct GroupSessionsView: View {
    @State private var selectedDate = 20
    @State private var isShowingAddSession = false

    let dates = Array(20...30)
    let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color(.systemGray6).edgesIgnoringSafeArea(.all)

                VStack(spacing: 0) {
                    VStack(spacing: 12) {
                        HStack {
                            Button(action: {}) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            Spacer()
                            Text("Calculus")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                            Spacer()
                            Spacer().frame(width: 44)
                        }
                        .padding(.top, 50)

                        Text("Mathematics")
                            .foregroundColor(.white)
                            .font(.subheadline)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(dates, id: \.self) { date in
                                    VStack {
                                        Text("\(date)")
                                            .fontWeight(.bold)
                                        Text(weekdays[date % 7])
                                            .font(.caption)
                                    }
                                    .frame(width: 55, height: 70)
                                    .background(selectedDate == date ? .white : Color.white.opacity(0.2))
                                    .cornerRadius(12)
                                    .onTapGesture {
                                        selectedDate = date
                                    }
                                    .foregroundColor(selectedDate == date ? .black : .white)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 50)
                    .background(Color(hex: "#4B7BEC"))
                    .frame(height: 350)
                    .clipShape(RoundedCorner(radius: 0, corners: [.bottomLeft, .bottomRight]))
                    .ignoresSafeArea(edges: .top)
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Sessions")
                            .font(.headline)
                            .padding(.horizontal)

                        sessionRow(title: "2015 Paper Discussion", instructor: "D.S.Silva", time: "12 PM")
                        sessionRow(title: "2016 Paper Discussion", instructor: "D.S.Silva", time: "12 PM")
                        sessionRow(title: "2018 Paper Discussion", instructor: "D.S.Silva", time: "12 PM")
                        sessionRow(title: "2021 Paper Discussion", instructor: "A.N.Ranasinghe", time: "1 PM")

                        Spacer()

                        HStack {
                            Spacer()
                            NavigationLink(value: "AddSession") {
                                EmptyView()
                            }
                            .navigationDestination(for: String.self) { _ in
                                AddSessionView(groupName: "Calculus")
                            }

                            Button(action: {
                                isShowingAddSession = true
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.black)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                            }
                            .padding()
                        }
                    }
                    .padding(.top, 25)
                    .background(
                        Color.white
                            .clipShape(RoundedCorner(radius: 30, corners: [.topLeft, .topRight]))
                    )
                    .offset(y:-70)
                    .frame(height: 630)
                    .ignoresSafeArea(edges: .bottom)
                }
            }
        }
    }

    private func sessionRow(title: String, instructor: String, time: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .fontWeight(.semibold)
                Text("By \(instructor)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(time)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 10.0
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct GroupSessionsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupSessionsView()
    }
}
