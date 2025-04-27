//
//  LocalAuthentication.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/23/25.
//
import SwiftUI
import LocalAuthentication

// MARK: - BiometricAuthManager

/// A manager responsible for handling biometric authentication.
class BiometricAuthManager: ObservableObject {
    // MARK: - Published Properties

    /// Indicates whether biometrics are enabled.
    @Published var useBiometrics: Bool = false

    // MARK: - Authentication

    /// Authenticates the user using biometrics (Face ID / Touch ID).
    func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Enable Face ID / Touch ID") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.useBiometrics = true
                    } else {
                        self.useBiometrics = false
                        if let authError = authenticationError {
                            print("Authentication failed: \(authError.localizedDescription)")
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.useBiometrics = false
                if let evalError = error {
                    print("Biometrics not available: \(evalError.localizedDescription)")
                }
            }
        }
    }
}
