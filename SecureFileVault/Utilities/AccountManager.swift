//
//  AccountManager.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/23/25.
//

import Foundation

// MARK: - AccountManager

/// A manager responsible for handling account-related operations.
class AccountManager: ObservableObject {
    // MARK: - Published Properties

    /// Indicates whether the user is logged in.
    @Published var isLoggedIn: Bool = false

    // MARK: - Account Management

    /// Checks if an account exists.
    /// - Returns: `true` if an account exists, otherwise `false`.
    func accountExists() -> Bool {
        return UserDefaults.standard.string(forKey: "username") != nil
    }

    /// Validates the provided credentials against stored credentials.
    /// - Parameters:
    ///   - username: The username to validate.
    ///   - password: The password to validate.
    /// - Returns: `true` if the credentials are valid, otherwise `false`.
    func validateCredentials(username: String, password: String) -> Bool {
        let storedUsername = UserDefaults.standard.string(forKey: "username")
        let storedPassword = UserDefaults.standard.string(forKey: "password")
        return username == storedUsername && password == storedPassword
    }

    /// Creates a new account with the given username and password.
    /// - Parameters:
    ///   - username: The username for the new account.
    ///   - password: The password for the new account.
    func createAccount(username: String, password: String) {
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(password, forKey: "password")
        isLoggedIn = true
    }

    /// Logs the user out by updating the login status.
    func logOut() {
        isLoggedIn = false
    }
}
