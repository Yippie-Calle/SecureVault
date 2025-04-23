//
//  AccountSetupView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/18/25.
//

import SwiftUI
import LocalAuthentication

struct AccountSetupView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var name = ""
    @State private var reason = ""
    @State private var username = ""
    @State private var password = ""
    @State private var useBiometrics = false
    @State private var allowOtherDevices = false
    @State private var navigateToWelcome = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Name", text: $name)
                    TextField("Reason for using this app", text: $reason)
                }

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

                Section(header: Text("Preferences")) {
                    Toggle("Enable Face ID / Touch ID", isOn: $useBiometrics)
                        .onChange(of: useBiometrics) { newValue in
                            if newValue {
                                authenticateWithBiometrics()
                            }
                        }
                    Toggle("Allow access on other devices", isOn: $allowOtherDevices)
                }

                Button("Create Account") {
                    if validatePassword() {
                        saveAccountDetails()
                        navigateToWelcome = true
                        authManager.signIn()
                    }
                }
                .disabled(name.isEmpty || username.isEmpty || !validatePassword())

                NavigationLink(
                    destination: WelcomeView(username: username),
                    isActive: $navigateToWelcome
                ) {
                    EmptyView()
                }
            }
            .navigationTitle("Set Up Account")
        }
    }

    private func validatePassword() -> Bool {
        let lengthRequirement = password.count >= 12
        let uppercaseRequirement = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let specialCharacterRequirement = password.range(of: "[!@#$&*]", options: .regularExpression) != nil
        let numberRequirement = password.range(of: "[0-9]", options: .regularExpression) != nil

        return lengthRequirement && uppercaseRequirement && specialCharacterRequirement && numberRequirement
    }

    private func saveAccountDetails() {
        UserDefaults.standard.set(name, forKey: "userName")
        UserDefaults.standard.set(username, forKey: "userUsername")
        UserDefaults.standard.set(allowOtherDevices, forKey: "allowOtherDevices")
    }

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
#if DEBUG
struct AccountSetupView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSetupView()
            .environmentObject(AuthManager())
    }
}
#endif
