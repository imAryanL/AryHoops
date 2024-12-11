//
//  RegistrationView.swift
//  AryHoops
//
//  Created by aryan on 12/1/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RegistrationView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isLoggedIn: Bool
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isLoading = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 89 / 255, green: 96 / 255, blue: 113 / 255)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                VStack(spacing: -10) {
                    Image("mango")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    
                    Text("AryHoops")
                        .font(.custom("Noteworthy-Bold", size: 35))
                        .foregroundColor(.white)
                }

                TextField("", text: $username)
                    .textFieldStyle(CustomTextFieldStyle())
                    .padding(.horizontal, 30)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .overlay(
                        HStack {
                            Text("username")
                                .foregroundColor(.gray)
                                .padding(.leading, 40)
                                .opacity(username.isEmpty ? 1 : 0)
                            Spacer()
                        }
                    )

                TextField("", text: $email)
                    .textFieldStyle(CustomTextFieldStyle())
                    .padding(.horizontal, 30)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .overlay(
                        HStack {
                            Text("email")
                                .foregroundColor(.gray)
                                .padding(.leading, 40)
                                .opacity(email.isEmpty ? 1 : 0)
                            Spacer()
                        }
                    )

                SecureField("", text: $password)
                    .textFieldStyle(CustomTextFieldStyle())
                    .padding(.horizontal, 30)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .overlay(
                        HStack {
                            Text("password")
                                .foregroundColor(.gray)
                                .padding(.leading, 40)
                                .opacity(password.isEmpty ? 1 : 0)
                            Spacer()
                        }
                    )

                Button(action: registerUser) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Create Account")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color.orange)
                .cornerRadius(20)
                .padding(.horizontal, 30)

                Spacer()

                Button("Already have an account? Login here") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.orange)
                .padding(.bottom, 10)
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }

    func registerUser() {
        guard !email.isEmpty, !password.isEmpty else {
            self.errorMessage = "Email and password cannot be empty."
            self.showError = true
            return
        }

        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                } else {
                    if let user = result?.user {
                        saveUserData(user: user)
                    }
                }
            }
        }
    }

    func saveUserData(user: User) {
        let userData = ["username": username, "email": email]
        Firestore.firestore().collection("users").document(user.uid).setData(userData) { error in
            if let error = error {
                self.errorMessage = "Failed to save user data: \(error.localizedDescription)"
                self.showError = true
            } else {
                // Successfully saved user data
                self.isLoggedIn = true  // Set logged in state to true
                self.presentationMode.wrappedValue.dismiss()  // Dismiss the registration view
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(isLoggedIn: .constant(false))
    }
}
