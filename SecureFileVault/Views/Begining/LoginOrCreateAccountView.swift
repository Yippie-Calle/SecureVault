//
//  LoginOrCreateAccountView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/23/25.
//
import SwiftUI

// MARK: - LoginOrCreateAccountView

/// A view that allows the user to either log in or create a new account.
struct LoginOrCreateAccountView: View {
    // MARK: - Environment Objects

    /// The authentication manager for handling user authentication.
    @EnvironmentObject var authManager: AuthManager

    // MARK: - State Properties

    /// The username entered by the user.
    @State private var username = ""

    /// The password entered by the user.
    @State private var password = ""

    /// A flag indicating whether the user is creating a new account.
    @State private var isCreatingAccount = false

    // MARK: - Body

    var body: some View {
        VStack {
            if isCreatingAccount {
                // MARK: - Account Creation View
                AccountSetupView()
                    .environmentObject(authManager)
            } else {
                // MARK: - Login View
                VStack {
                    // MARK: - Login Header
                    Text("Have an account? Log in!")
                        .font(.headline)

                    // MARK: - Username Field
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    // MARK: - Password Field
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    // MARK: - Log In Button
                    Button("Log In") {
                        if authManager.validateCredentials(username: username, password: password) {
                            authManager.signIn()
                        }
                    }
                    .disabled(username.isEmpty || password.isEmpty)

                    // MARK: - Create Account Button
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

// MARK: - Previews

#if DEBUG
struct LoginOrCreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        LoginOrCreateAccountView()
            .environmentObject(AuthManager())
    }
}
#endif
