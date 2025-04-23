//
//  LoginOrCreateAccountView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/23/25.
//
import SwiftUI

struct LoginOrCreateAccountView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var username = ""
    @State private var password = ""
    @State private var isCreatingAccount = false

    var body: some View {
        VStack {
            if isCreatingAccount {
                AccountSetupView()
                    .environmentObject(authManager)
            } else {
                VStack {
                    Text("Have an account? Log in!")
                        .font(.headline)
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Log In") {
                        if authManager.validateCredentials(username: username, password: password) {
                            authManager.signIn()
                        }
                    }
                    .disabled(username.isEmpty || password.isEmpty)

                    Button("Don't have an account? Create one") {
                        isCreatingAccount = true
                    }
                }
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}
