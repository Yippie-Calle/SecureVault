//
//  ChangePasswordView.swift
//  SecureVault
//
//  Created by Bryan Calle on 5/13/25.
//

import SwiftUI

// MARK: - ChangePasswordView

/// A view for changing the user's password.
struct ChangePasswordView: View {
    // MARK: - State Properties

    /// The current password entered by the user.
    @State private var currentPassword: String = ""

    /// The new password entered by the user.
    @State private var newPassword: String = ""

    /// The confirmation of the new password entered by the user.
    @State private var confirmPassword: String = ""

    /// A flag to control the display of alerts.
    @State private var showAlert: Bool = false

    /// The message to display in the alert.
    @State private var alertMessage: String = ""

    // MARK: - Environment Objects

    /// The user manager for handling user authentication.
    @EnvironmentObject var userManager: UserManager

    // MARK: - Body

    var body: some View {
        Form {
            // MARK: - Current Password Section
            Section(header: Text("Current Password").font(.headline)) {
                SecureField("Enter current password", text: $currentPassword)
                    .textContentType(.password)
                    .accessibilityLabel("Current Password")
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

            // MARK: - Save Button
            Section {
                Button("Save Changes") {
                    handleChangePassword()
                }
                .accessibilityLabel("Save Password Changes")
            }
        }
        .navigationTitle("Change Password")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Notice"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    // MARK: - Actions

    /// Handles the password change logic.
    private func handleChangePassword() {
        guard let username = userManager.currentUsername else {
            alertMessage = "No user is currently signed in."
            showAlert = true
            return
        }

        guard !currentPassword.isEmpty, !newPassword.isEmpty, !confirmPassword.isEmpty else {
            alertMessage = "All fields are required."
            showAlert = true
            return
        }

        guard newPassword == confirmPassword else {
            alertMessage = "New passwords do not match."
            showAlert = true
            return
        }

        // Validate the current password
        if !DatabaseManager.shared.validateUser(username: username, password: currentPassword) {
            alertMessage = "Current password is incorrect."
            showAlert = true
            return
        }

        // Update the password in the database and keychain
        if DatabaseManager.shared.addUser(username: username, password: newPassword) &&
            KeychainManager.save(value: newPassword, for: username) {
            alertMessage = "Password changed successfully."
        } else {
            alertMessage = "Failed to update the password. Please try again."
        }

        showAlert = true
    }
}

// MARK: - Previews

#if DEBUG
struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChangePasswordView()
                .environmentObject(UserManager())
        }
    }
}
#endif
