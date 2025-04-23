//
//  AuthManager.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/22/25.
//

import Foundation

class AuthManager: ObservableObject {
    @Published var isSignedIn: Bool {
        didSet {
            UserDefaults.standard.set(isSignedIn, forKey: "isSignedIn")
        }
    }
    @Published var currentUsername: String? // Added property

    init() {
        self.isSignedIn = UserDefaults.standard.bool(forKey: "isSignedIn")
        self.currentUsername = nil // Initialize with nil or a default value
    }

    func signIn() {
        isSignedIn = true
        currentUsername = "DefaultUsername" // Set a default username or fetch from a source
    }

    func signOut() {
        isSignedIn = false
        currentUsername = nil
    }

    func validateCredentials(username: String, password: String) -> Bool {
        // Add validation logic here
        return !username.isEmpty && !password.isEmpty
    }
}
