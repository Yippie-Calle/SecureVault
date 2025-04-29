//
//  UserManager.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/27/25.
//

import Foundation

// MARK: - UserManager

/// A manager responsible for handling user authentication and account-related operations.
class UserManager: ObservableObject {
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

    /// Initializes the `UserManager` with default values.
    init() {
        self.isSignedIn = UserDefaults.standard.bool(forKey: "isSignedIn")
        self.currentUsername = UserDefaults.standard.string(forKey: "currentUsername")
    }

    // MARK: - Account Management

    /// Creates a new account with the given username and password.
    /// - Parameters:
    ///   - username: The username for the new account.
    ///   - password: The password for the new account.
    /// - Returns: `true` if the account was created successfully, otherwise `false`.
    func createAccount(username: String, password: String) -> Bool {
        guard !accountExists(username: username) else {
            return false // Username already exists
        }
        KeychainManager.save(value: password, for: username)
        UserDefaults.standard.set(username, forKey: "currentUsername")
        isSignedIn = true
        currentUsername = username
        return true
    }

    /// Validates the provided credentials.
    /// - Parameters:
    ///   - username: The username to validate.
    ///   - password: The password to validate.
    /// - Returns: `true` if the credentials are valid, otherwise `false`.
    func validateCredentials(username: String, password: String) -> Bool {
        if let storedPassword = KeychainManager.retrieveValue(for: username) {
            return password == storedPassword
        }
        return false
    }

    /// Checks if an account exists for the given username.
    /// - Parameter username: The username to check.
    /// - Returns: `true` if the account exists, otherwise `false`.
    func accountExists(username: String) -> Bool {
        return KeychainManager.retrieveValue(for: username) != nil
    }

    // MARK: - Authentication Actions

    /// Signs the user in with the given username.
    /// - Parameter username: The username of the user.
    func signIn(username: String) {
        isSignedIn = true
        currentUsername = username
        UserDefaults.standard.set(username, forKey: "currentUsername")
    }

    /// Signs the user out and clears the current username.
    func signOut() {
        isSignedIn = false
        currentUsername = nil
        UserDefaults.standard.removeObject(forKey: "currentUsername")
    }
}
