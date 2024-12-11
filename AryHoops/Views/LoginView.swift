//  LoginView.swift
//  AryHoops
//
//  Created by aryan on 12/1/24.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @Binding var isLoggedIn: Bool // Accept a binding to manage login state
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false

    func loginUser() {
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                } else {
                    print("User logged in successfully")
                    isLoggedIn = true // Update the binding to navigate to HomeView
                }
            }
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 89 / 255, green: 96 / 255, blue: 113 / 255)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: -10) {
                    Image("mango")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)

                    Text("AryHoops")
                        .font(.custom("Noteworthy-Bold", size: 35))
                        .foregroundColor(.white)

                    VStack(spacing: 20) {
                        TextField("", text: $email)
                            .textFieldStyle(CustomTextFieldStyle())
                            .padding(.horizontal, 20)
                            .frame(maxWidth: 300)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .overlay(
                                HStack {
                                    Text("email")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 30)
                                        .opacity(email.isEmpty ? 1 : 0)
                                    Spacer()
                                }
                            )

                        SecureField("", text: $password)
                            .textFieldStyle(CustomTextFieldStyle())
                            .padding(.horizontal, 20)
                            .frame(maxWidth: 300)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .overlay(
                                HStack {
                                    Text("password")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 30)
                                        .opacity(password.isEmpty ? 1 : 0)
                                    Spacer()
                                }
                            )

                        Button(action: loginUser) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Login")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                        }
                        .frame(maxWidth: 100, minHeight: 44)
                        .background(Color.orange)
                        .cornerRadius(15)
                    }
                    .padding(.top, 45)
                }

                Spacer()

                VStack(spacing: 7) {
                    Text("Don't have an account yet?")
                        .foregroundColor(.white)
                        .fontWeight(.bold)

                    NavigationLink(destination: RegistrationView(isLoggedIn: $isLoggedIn)) {
                        Text("Register here")
                            .foregroundColor(.orange)
                            .fontWeight(.bold)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedIn: .constant(false)) // Provide a constant binding for the preview
    }
}
