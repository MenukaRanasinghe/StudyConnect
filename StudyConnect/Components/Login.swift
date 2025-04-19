//
//  Login.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-09.
//

import SwiftUI
import CoreData

struct LoginPage: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var email = ""
    @State private var password = ""
    @State private var isSecure = true
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoggedIn = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("Sign In")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                    .foregroundColor(Color(hex: "#4B7BEC"))

                Text("Please Sign In to continue.")
                    .font(.title3)
                    .fontWeight(.bold)

                Group {
                    Text("Email")
                        .font(.headline)
                        .padding(.top, 30)
                        .padding(.leading, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    TextField("Enter your email", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(.top, 5)
                        .padding(.horizontal, 20)
                }

                Group {
                    Text("Password")
                        .font(.headline)
                        .padding(.top, 20)
                        .padding(.leading, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    HStack {
                        if isSecure {
                            SecureField("Enter your password", text: $password)
                        } else {
                            TextField("Enter your password", text: $password)
                        }

                        Button(action: {
                            isSecure.toggle()
                        }) {
                            Image(systemName: isSecure ? "eye" : "eye.slash")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.top, 5)
                    .padding(.horizontal, 20)
                }

                Button(action: {
                    loginUser()
                }) {
                    Text("Sign In")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 30)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)

                HStack {
                    Text("Don't have an account?")
                    NavigationLink(destination: RegisterPage()) {
                        Text("Sign Up")
                            .fontWeight(.semibold)
                            .foregroundColor(Color.blue)
                    }
                }

                Text("Or Continue With")
                    .padding(.top, 15)

                HStack {
                    ImageButton("gmail")
                    ImageButton("facebook")
                    ImageButton("apple")
                }
                .padding(.top, 30)

                Spacer()
            }
            .padding(.horizontal, 20)
            .alert(isPresented: $showAlert) {
                Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }

            NavigationLink(destination: MenuBar(initialTab: 2), isActive: $isLoggedIn) {
                EmptyView()
            }
        }
    }

    private func loginUser() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)

        do {
            let users = try viewContext.fetch(fetchRequest)
            if let user = users.first {
                if user.password == password {
                    alertMessage = "Login successful!"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isLoggedIn = true
                    }
                } else {
                    alertMessage = "Incorrect password."
                    showAlert = true
                }
            } else {
                alertMessage = "No account found with this email."
                showAlert = true
            }
        } catch {
            alertMessage = "Login failed: \(error.localizedDescription)"
            showAlert = true
        }
    }
}

private func ImageButton(_ name: String) -> some View {
    Button(action: {
        print("Login with \(name)")
    }) {
        Image(name)
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
            .padding(10)
    }
}

#Preview {
    LoginPage()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
