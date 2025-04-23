//
//  AccountManager.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/23/25.
//

import Foundation

class AccountManager: ObservableObject {
    @Published var isLoggedIn: Bool = false

    func accountExists() -> Bool {
        return UserDefaults.standard.string(forKey: "username") != nil
    }

    func validateCredentials(username: String, password: String) -> Bool {
        let storedUsername = UserDefaults.standard.string(forKey: "username")
        let storedPassword = UserDefaults.standard.string(forKey: "password")
        return username == storedUsername && password == storedPassword
    }

    func createAccount(username: String, password: String) {
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(password, forKey: "password")
        isLoggedIn = true
    }

    func logOut() {
        isLoggedIn = false
    }
}
