//
//  UserManager.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/27/25.
//

import Foundation

// MARK: - UserManager

/// A manager responsible for handling user authentication and session persistence.
class UserManager: ObservableObject {
    // MARK: - Published Properties
    
    /// Indicates whether the user is signed in.
    @Published var isSignedIn: Bool {
        didSet {
            // Persist the signed-in state in UserDefaults.
            UserDefaults.standard.set(isSignedIn, forKey: "isSignedIn")
        }
    }
    
    /// The username of the currently signed-in user.
    @Published var currentUsername: String? {
        didSet {
            // Persist the current username in UserDefaults.
            UserDefaults.standard.set(currentUsername, forKey: "currentUsername")
        }
    }
    
    // MARK: - Initialization
    
    /// Initializes the `UserManager` with persisted values from UserDefaults.
    init() {
        // Retrieve the signed-in state and username from UserDefaults.
        self.isSignedIn = UserDefaults.standard.bool(forKey: "isSignedIn")
        self.currentUsername = UserDefaults.standard.string(forKey: "currentUsername")
    }
    
    // MARK: - Authentication Actions
    
    /// Signs the user in with the given username.
    /// - Parameter username: The username of the user.
    func signIn(username: String) {
        isSignedIn = true
        currentUsername = username
    }
    
    /// Signs the user out and clears the current username.
    func signOut() {
        isSignedIn = false
        currentUsername = nil
        // Remove the persisted username from UserDefaults.
        UserDefaults.standard.removeObject(forKey: "currentUsername")
    }
    
    /// Validates the provided username and password.
    /// - Parameters:
    ///   - username: The username to validate.
    ///   - password: The password to validate.
    /// - Returns: A Boolean indicating whether the credentials are valid.
    func validateCredentials(username: String, password: String) -> Bool {
        return DatabaseManager.shared.validateUser(username: username, password: password)
    }

    func createAccount(username: String, password: String) -> Bool {
        return DatabaseManager.shared.addUser(username: username, password: password)
    }
}
