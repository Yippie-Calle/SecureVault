//
//  AuthManager.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/22/25.
//

import Foundation

// MARK: - AuthManager

/// A manager responsible for handling authentication-related operations.
class AuthManager: ObservableObject {
    // MARK: - Published Properties

    /// Indicates whether the user is signed in.
    @Published var isSignedIn: Bool {
        didSet {
            UserDefaults.standard.set(isSignedIn, forKey: "isSignedIn")
        }
    }

    /// The username of the currently signed-in user.
    @Published var currentUsername: String?

    // MARK: - Initialization

    /// Initializes the `AuthManager` with default values.
    init() {
        self.isSignedIn = UserDefaults.standard.bool(forKey: "isSignedIn")
        self.currentUsername = nil // Initialize with nil or a default value
    }

    // MARK: - Authentication Actions

    /// Signs the user in and sets a default username.
    func signIn() {
        isSignedIn = true
        currentUsername = "DefaultUsername" // Set a default username or fetch from a source
    }

    /// Signs the user out and clears the current username.
    func signOut() {
        isSignedIn = false
        currentUsername = nil
    }

    /// Validates the provided credentials.
    /// - Parameters:
    ///   - username: The username to validate.
    ///   - password: The password to validate.
    /// - Returns: `true` if the credentials are valid, otherwise `false`.
    func validateCredentials(username: String, password: String) -> Bool {
        // Add validation logic here
        return !username.isEmpty && !password.isEmpty
    }
}
