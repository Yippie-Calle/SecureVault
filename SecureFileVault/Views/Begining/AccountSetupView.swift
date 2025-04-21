//
//  AccountSetupView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/18/25.
//

import SwiftUI

struct AccountSetupView: View {
    @State private var name = ""
    @State private var reason = ""
    @State private var username = ""
    @State private var password = ""
    @State private var useBiometrics = false
    @State private var allowOtherDevices = false
    @State private var showPasswordError = false
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
                            validatePassword()
                        }
                    if showPasswordError {
                        Text("Password must be at least 12 characters long, include 1 uppercase letter, 1 special character, and 1 number.")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }

                Section(header: Text("Preferences")) {
                    Toggle("Enable Face ID / Touch ID", isOn: $useBiometrics)
                    Toggle("Allow access on other devices", isOn: $allowOtherDevices)
                }

                Button("Create Account") {
                    if validatePassword() {
                        saveAccountDetails()
                        navigateToWelcome = true
                    }
                }
                .disabled(name.isEmpty || username.isEmpty || password.isEmpty)

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
        let passwordRegex = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9]).{12,}$"
        let isValid = NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
        showPasswordError = !isValid
        return isValid
    }

    private func saveAccountDetails() {
        UserDefaults.standard.set(name, forKey: "userName")
        UserDefaults.standard.set(username, forKey: "userUsername")
        UserDefaults.standard.set(allowOtherDevices, forKey: "allowOtherDevices")
    }
}
