//
//  Register.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-09.
//

import SwiftUI
import CoreData
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct RegisterPage: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSecure = true
    @State private var errorMessage = ""
    
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)
                .foregroundColor(Color(hex: "#4B7BEC"))
            
            Text("Sign up to find your study squad and start learning together!")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal, 20)

            Text("Email")
                .font(.headline)
                .padding(.top, 30)
                .padding(.leading, 20)
                .frame(maxWidth:.infinity, alignment: .leading)
            
            TextField("Enter your email", text: $email)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding(.top, 5)
                .padding(.horizontal, 20)
            
            Text("Password")
                .font(.headline)
                .padding(.top, 20)
                .padding(.leading, 20)
                .frame(maxWidth:.infinity, alignment: .leading)
            
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
            
            Button(action: {
                registerUser(email: email, password: password)
            }) {
                Text("Sign Up")
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
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }
            
            HStack {
                Text("Already have an account ? ")
                NavigationLink(destination: LoginPage()) {
                    Text("Sign In")
                        .fontWeight(.semibold)
                        .foregroundColor(Color.blue)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
    }

    func registerUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = "Error creating user: \(error.localizedDescription)"
                return
            }

            guard let uid = result?.user.uid else {
                errorMessage = "Failed to retrieve user ID."
                return
            }

            saveUserData(uid: uid, email: email)
        }
    }

    func saveUserData(uid: String, email: String) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).setData([
            "email": email,
            "createdAt": Timestamp()
        ]) { error in
            if let error = error {
                errorMessage = "Error saving user data to Firestore: \(error.localizedDescription)"
            } else {
                print("User data saved to Firestore")
            }
        }
    }
}

#Preview {
    RegisterPage()
}
