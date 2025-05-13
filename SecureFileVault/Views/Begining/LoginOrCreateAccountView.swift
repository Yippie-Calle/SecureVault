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
    @EnvironmentObject var userManager: UserManager

    // MARK: - State Properties

    /// The username entered by the user.
    @State private var username = ""

    /// The password entered by the user.
    @State private var password = ""

    /// A flag indicating whether the user is creating a new account.
    @State private var isCreatingAccount = false

    /// A flag indicating whether login failed.
    @State private var loginFailed = false

    /// Tracks the number of failed login attempts.
    @State private var failedAttempts = 0

    /// A flag to navigate to the password recovery view.
    @State private var showPasswordRecovery = false

    // MARK: - Body

    var body: some View {
        NavigationView {
            VStack {
                if isCreatingAccount {
                    // MARK: - Account Creation View
                    AccountSetupView()
                        .environmentObject(userManager)
                        .onDisappear {
                            // Reset fields when returning from account creation
                            username = ""
                            password = ""
                            loginFailed = false
                            failedAttempts = 0
                        }
                } else {
                    // MARK: - Login View
                    VStack(spacing: 20) {
                        // MARK: - Header
                        Image(systemName: "lock.shield.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.blue)
                            .padding(.bottom, 20)

                        Text("SecureFileVault")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        // MARK: - Username Field
                        TextField("Username", text: $username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .padding(.horizontal)

                        // MARK: - Password Field
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        // MARK: - Error Message
                        if loginFailed {
                            Text("Invalid username or password.")
                                .foregroundColor(.red)
                                .font(.caption)
                        }

                        // MARK: - Log In Button
                        Button(action: {
                            if userManager.validateCredentials(username: username, password: password) {
                                userManager.signIn(username: username)
                                loginFailed = false
                                failedAttempts = 0
                            } else {
                                loginFailed = true
                                failedAttempts += 1
                            }
                        }) {
                            Text("Log In")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .disabled(username.isEmpty || password.isEmpty)

                        // MARK: - Forgot Password Button
                        if failedAttempts >= 3 {
                            Button(action: {
                                showPasswordRecovery = true
                            }) {
                                Text("Forgot your password?")
                                    .foregroundColor(.blue)
                            }
                            .sheet(isPresented: $showPasswordRecovery) {
                                PasswordRecoveryView()
                            }
                        }

                        // MARK: - Create Account Button
                        Button(action: {
                            isCreatingAccount = true
                        }) {
                            Text("Don't have an account? Create one")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                }
            }
            //.navigationBarTitle(isCreatingAccount ? "Create Account" : "Log In", displayMode: .inline)
        }
    }
}

// MARK: - Previews

#if DEBUG
struct LoginOrCreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        LoginOrCreateAccountView()
            .environmentObject(UserManager())
    }
}
#endif
