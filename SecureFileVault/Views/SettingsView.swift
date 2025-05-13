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

    /// The authentication manager for handling sign-in and authentication.
    @EnvironmentObject var userManager: UserManager

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
                Section(header: Text("Appearance").font(.headline)) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                        .accessibilityLabel("Toggle Dark Mode")
                }

                // MARK: - Account Section
                Section(header: Text("Account").font(.headline)) {
                    TextField("Name", text: $name)
                        .textContentType(.name)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                        .accessibilityLabel("User Name")

                    NavigationLink(destination: ChangePasswordView()) {
                        Text("Change Password")
                    }
                }

                // MARK: - Preferences Section
                Section(header: Text("Preferences").font(.headline)) {
                    Toggle("Allow access on other devices", isOn: $allowOtherDevices)
                        .accessibilityLabel("Allow Access on Other Devices")
                }

                // MARK: - Security Section
                Section(header: Text("Security").font(.headline)) {
                    Toggle("Use Face ID", isOn: $useFaceID)
                        .accessibilityLabel("Enable Face ID")

                    Button("Change Passcode") {
                        alertMessage = "Change Passcode functionality is not implemented yet."
                        showAlert = true
                    }
                    .accessibilityLabel("Change Passcode")
                }

                // MARK: - Log Out Section
                Section {
                    Button("Log Out") {
                        userManager.signOut()
                    }
                    .foregroundColor(.red)
                    .accessibilityLabel("Log Out")
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Notice"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

// MARK: - Previews

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(UserManager())
    }
}
#endif
