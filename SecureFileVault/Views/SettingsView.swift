//
//  SettingsView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//

import SwiftUI
import LocalAuthentication

// MARK: - SettingsView

/// A view for managing app settings, including appearance, account, preferences, and security.
struct SettingsView: View {
    // MARK: - AppStorage Properties

    /// A flag to toggle dark mode.
    @AppStorage("isDarkMode") private var isDarkMode = false

    /// The user's name.
    @AppStorage("userName") private var name = ""

    /// The user's username.
    @AppStorage("userUsername") private var username = ""

    /// A flag to allow access on other devices.
    @AppStorage("allowOtherDevices") private var allowOtherDevices = false

    /// A flag to enable Face ID authentication.
    @AppStorage("useFaceID") private var useFaceID = false

    // MARK: - State Properties

    /// A flag to control the display of alerts.
    @State private var showAlert = false

    /// The message to display in the alert.
    @State private var alertMessage = ""

    // MARK: - Body

    var body: some View {
        NavigationView {
            Form {
                // MARK: - Appearance Section
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }

                // MARK: - Account Section
                Section(header: Text("Account")) {
                    TextField("Name", text: $name)
                    NavigationLink(destination: ChangePasswordView()) {
                        Text("Change Password")
                    }
                }

                // MARK: - Preferences Section
                Section(header: Text("Preferences")) {
                    Toggle("Allow access on other devices", isOn: $allowOtherDevices)
                }

                // MARK: - Security Section
                Section(header: Text("Security")) {
                    Toggle("Use Face ID", isOn: $useFaceID)
                    Button("Change Passcode") {
                        // Display an alert for unimplemented functionality.
                        alertMessage = "Change Passcode functionality is not implemented yet."
                        showAlert = true
                    }
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .navigationTitle("Settings")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Notice"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

// MARK: - Biometric Authentication

/// Authenticates the user using biometrics (e.g., Face ID or Touch ID).
/// - Parameter completion: A closure that returns a boolean indicating success or failure.
func authenticateWithBiometrics(completion: @escaping (Bool) -> Void) {
    let context = LAContext()
    var error: NSError?

    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Log in to your account") { success, _ in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    } else {
        // Provide user feedback for unavailable biometrics.
        DispatchQueue.main.async {
            print("Biometric authentication is not available: \(error?.localizedDescription ?? "Unknown error")")
        }
        completion(false)
    }
}

// MARK: - ChangePasswordView

/// A view for changing the user's password.
struct ChangePasswordView: View {
    // MARK: - State Properties

    /// The current password entered by the user.
    @State private var currentPassword = ""

    /// The new password entered by the user.
    @State private var newPassword = ""

    /// A flag to indicate if the password validation failed.
    @State private var showPasswordError = false

    // MARK: - Body

    var body: some View {
        Form {
            // MARK: - Current Password Field
            SecureField("Current Password", text: $currentPassword)

            // MARK: - New Password Field
            SecureField("New Password", text: $newPassword)
                .onChange(of: newPassword) { _ in
                    validatePassword()
                }

            // MARK: - Password Validation Error
            if showPasswordError {
                Text("Password must be at least 12 characters long, include 1 uppercase letter, 1 special character, and 1 number.")
                    .font(.caption)
                    .foregroundColor(.red)
            }

            // MARK: - Update Password Button
            Button("Update Password") {
                if validatePassword() {
                    // Save new password securely.
                }
            }
            .disabled(currentPassword.isEmpty || newPassword.isEmpty)
        }
        .navigationTitle("Change Password")
    }

    // MARK: - Password Validation

    /// Validates the new password based on specific criteria.
    /// - Returns: A boolean indicating whether the password is valid.
    private func validatePassword() -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9]).{12,}$"
        let isValid = NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: newPassword)
        showPasswordError = !isValid
        return isValid
    }
}

// MARK: - Previews

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
#endif
