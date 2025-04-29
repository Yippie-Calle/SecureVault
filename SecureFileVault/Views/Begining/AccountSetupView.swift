//
//  AccountSetupView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/18/25.
//

import SwiftUI
import LocalAuthentication

// MARK: - AccountSetupView

/// A view for setting up a new user account with personal information, account details, and preferences.
struct AccountSetupView: View {
    // MARK: - Environment Objects

    /// The authentication manager for handling sign-in and authentication.
    @EnvironmentObject var userManager: UserManager

    // MARK: - State Properties

    /// The user's name.
    @State private var name = ""

    /// The reason for using the app.
    @State private var reason = ""

    /// The username for the account.
    @State private var username = ""

    /// The password for the account.
    @State private var password = ""

    /// Whether to enable biometric authentication.
    @State private var useBiometrics = false

    /// Whether to allow access on other devices.
    @State private var allowOtherDevices = false

    /// Whether to navigate to the welcome screen.
    @State private var navigateToWelcome = false

    // MARK: - Body

    var body: some View {
        NavigationView {
            Form {
                // MARK: - Personal Information Section
                Section(header: Text("Personal Information")) {
                    TextField("Name", text: $name)
                    TextField("Reason for using this app", text: $reason)
                }

                // MARK: - Account Details Section
                Section(header: Text("Account Details")) {
                    TextField("Username", text: $username)
                    SecureField("Password", text: $password)
                        .onChange(of: password) { _ in
                            // Trigger validation on password change
                        }

                    if !password.isEmpty {
                        VStack(alignment: .leading, spacing: 5) {
                            PasswordRequirementRow(
                                requirement: "At least 12 characters",
                                isMet: password.count >= 12
                            )
                            PasswordRequirementRow(
                                requirement: "At least 1 uppercase letter",
                                isMet: password.range(of: "[A-Z]", options: .regularExpression) != nil
                            )
                            PasswordRequirementRow(
                                requirement: "At least 1 special character",
                                isMet: password.range(of: "[!@#$&*]", options: .regularExpression) != nil
                            )
                            PasswordRequirementRow(
                                requirement: "At least 1 number",
                                isMet: password.range(of: "[0-9]", options: .regularExpression) != nil
                            )
                        }
                    }
                }

                // MARK: - Preferences Section
                Section(header: Text("Preferences")) {
                    Toggle("Enable Face ID / Touch ID", isOn: $useBiometrics)
                        .onChange(of: useBiometrics) { newValue in
                            if newValue {
                                authenticateWithBiometrics()
                            }
                        }
                    Toggle("Allow access on other devices", isOn: $allowOtherDevices)
                }

                // MARK: - Create Account Button
                Button("Create Account") {
                                if validatePassword() {
                                    saveAccountDetails()
                                    navigateToWelcome = true
                                    userManager.signIn(username: username)
                                }
                            }
                            .disabled(name.isEmpty || username.isEmpty || !validatePassword())

                            NavigationLink(
                                destination: WelcomeView(username: username)
                                    .navigationBarBackButtonHidden(true),
                                isActive: $navigateToWelcome
                            ) {
                                EmptyView()
                            }
                        }
                        .navigationTitle("Set Up Account")
                        .navigationBarBackButtonHidden(true) // Hide back button in this view
                    }
                }

    // MARK: - Validation

    /// Validates the password against specific requirements.
    /// - Returns: A Boolean indicating whether the password is valid.
    private func validatePassword() -> Bool {
        let lengthRequirement = password.count >= 12
        let uppercaseRequirement = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let specialCharacterRequirement = password.range(of: "[!@#$&*]", options: .regularExpression) != nil
        let numberRequirement = password.range(of: "[0-9]", options: .regularExpression) != nil

        return lengthRequirement && uppercaseRequirement && specialCharacterRequirement && numberRequirement
    }

    // MARK: - Persistence

    /// Saves the account details to `UserDefaults`.
    private func saveAccountDetails() {
        UserDefaults.standard.set(name, forKey: "userName")
        UserDefaults.standard.set(username, forKey: "userUsername")
        UserDefaults.standard.set(allowOtherDevices, forKey: "allowOtherDevices")
    }

    // MARK: - Biometric Authentication

    /// Authenticates the user using biometrics (Face ID / Touch ID).
    private func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Enable Face ID / Touch ID") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        useBiometrics = true
                    } else {
                        useBiometrics = false
                        if let authError = authenticationError {
                            print("Authentication failed: \(authError.localizedDescription)")
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                useBiometrics = false
                if let evalError = error {
                    print("Biometrics not available: \(evalError.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - PasswordRequirementRow

/// A view that displays a password requirement and whether it is met.
struct PasswordRequirementRow: View {
    let requirement: String
    let isMet: Bool

    var body: some View {
        HStack {
            Image(systemName: isMet ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(isMet ? .green : .red)
            Text(requirement)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Previews

#if DEBUG
struct AccountSetupView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSetupView()
            .environmentObject(UserManager())
    }
}
#endif
