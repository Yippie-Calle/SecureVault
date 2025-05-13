//
//  PasswordRecoveryView.swift
//  SecureVault
//
//  Created by Bryan Calle on 5/13/25.
//

import SwiftUI

// MARK: - PasswordRecoveryView

/// A view for recovering and resetting the user's password.
struct PasswordRecoveryView: View {
    // MARK: - State Properties

    /// The username entered by the user.
    @State private var username: String = ""

    /// The new password entered by the user.
    @State private var newPassword: String = ""

    /// The confirmation of the new password entered by the user.
    @State private var confirmPassword: String = ""

    /// A flag to control the display of alerts.
    @State private var showAlert: Bool = false

    /// The message to display in the alert.
    @State private var alertMessage: String = ""

    // MARK: - Body

    var body: some View {
        Form {
            // MARK: - Username Section
            Section(header: Text("Username").font(.headline)) {
                TextField("Enter your username", text: $username)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .accessibilityLabel("Username")
            }

            // MARK: - New Password Section
            Section(header: Text("New Password").font(.headline)) {
                SecureField("Enter new password", text: $newPassword)
                    .textContentType(.newPassword)
                    .accessibilityLabel("New Password")

                SecureField("Confirm new password", text: $confirmPassword)
                    .textContentType(.newPassword)
                    .accessibilityLabel("Confirm New Password")
            }

            // MARK: - Reset Button
            Section {
                Button("Reset Password") {
                    handlePasswordReset()
                }
                .accessibilityLabel("Reset Password")
            }
        }
        .navigationTitle("Password Recovery")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Notice"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    // MARK: - Actions

    /// Handles the password reset logic.
    private func handlePasswordReset() {
        guard !username.isEmpty, !newPassword.isEmpty, !confirmPassword.isEmpty else {
            alertMessage = "All fields are required."
            showAlert = true
            return
        }

        guard newPassword == confirmPassword else {
            alertMessage = "New passwords do not match."
            showAlert = true
            return
        }

        // Validate the username
        if DatabaseManager.shared.validateUser(username: username, password: "") {
            // Update the password in the database and keychain
            if DatabaseManager.shared.addUser(username: username, password: newPassword) &&
                KeychainManager.save(value: newPassword, for: username) {
                alertMessage = "Password reset successfully."
            } else {
                alertMessage = "Failed to reset the password. Please try again."
            }
        } else {
            alertMessage = "Username not found."
        }

        showAlert = true
    }
}

// MARK: - Previews

#if DEBUG
struct PasswordRecoveryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PasswordRecoveryView()
        }
    }
}
#endif
