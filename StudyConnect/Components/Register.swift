//
//  Register.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-09.
//

import SwiftUI
import CoreData

struct RegisterPage: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSecure = true
    
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
                saveUserData(email: email, password: password)
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
            
            HStack {
                Text("Already have an account ? ")
                NavigationLink(destination: LoginPage()) {
                    Text("Sign In")
                        .fontWeight(.semibold)
                        .foregroundColor(Color.blue)
                }
            }
            HStack {
                Text("Or Continue With")
            }
            .padding(.top, 15)
            
            HStack {
                Button(action: {
                    print("Login in with Gmail")
                }) {
                    Image("gmail")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .padding(10)
                }
                
                Button(action: {
                    print("Login in with Facebook")
                }) {
                    Image("facebook")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .padding(10)
                }
                
                Button(action: {
                    print("Login in with Apple")
                }) {
                    Image("apple")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .padding(10)
                }
            }
            .padding(.top, 30)
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }

    func saveUserData(email: String, password: String) {
        let newUser = User(context: viewContext)
        newUser.email = email
        newUser.password = password

        do {
            try viewContext.save()
            print("User saved to Core Data")
        } catch {
            print("Error saving user: \(error.localizedDescription)")
        }
    }
}

#Preview {
    RegisterPage()
}
