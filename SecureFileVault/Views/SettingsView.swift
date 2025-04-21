//
//  SettingsView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//

import SwiftUI
import LocalAuthentication

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("userName") private var name = ""
    @AppStorage("userUsername") private var username = ""
    @AppStorage("allowOtherDevices") private var allowOtherDevices = false
    @AppStorage("useFaceID") private var useFaceID = false

    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
                Section(header: Text("Account")) {
                    TextField("Name", text: $name)
                    NavigationLink(destination: ChangePasswordView()) {
                        Text("Change Password")
                    }
                }

                Section(header: Text("Preferences")) {
                    Toggle("Allow access on other devices", isOn: $allowOtherDevices)
                }

                Section(header: Text("Security")) {
                    Toggle("Use Face ID", isOn: $useFaceID)
                    Button("Change Passcode") {
                        // Implement passcode change functionality here
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
        // Provide user feedback for unavailable biometrics
        DispatchQueue.main.async {
            print("Biometric authentication is not available: \(error?.localizedDescription ?? "Unknown error")")
        }
        completion(false)
    }
}
// Mark: - Change Password View
struct ChangePasswordView: View {
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var showPasswordError = false

    var body: some View {
        Form {
            SecureField("Current Password", text: $currentPassword)
            SecureField("New Password", text: $newPassword)
                .onChange(of: newPassword) { _ in
                    validatePassword()
                }
            if showPasswordError {
                Text("Password must be at least 12 characters long, include 1 uppercase letter, 1 special character, and 1 number.")
                    .font(.caption)
                    .foregroundColor(.red)
            }

            Button("Update Password") {
                if validatePassword() {
                    // Save new password securely
                }
            }
            .disabled(currentPassword.isEmpty || newPassword.isEmpty)
        }
        .navigationTitle("Change Password")
    }

    private func validatePassword() -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9]).{12,}$"
        let isValid = NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: newPassword)
        showPasswordError = !isValid
        return isValid
    }
}
// MARK: - Preview

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
#endif
