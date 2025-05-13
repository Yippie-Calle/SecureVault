//
//  MainTabView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//

import SwiftUI

// MARK: - MainTabView

/// A view that provides a tab-based navigation interface for the app.
struct MainTabView: View {
    // MARK: - State Objects

    /// The view model for managing notes in the vault.
    @StateObject private var notesViewModel = NotesVaultViewModel()

    // MARK: - Body

    var body: some View {
        TabView {
            // MARK: - File Vault Tab
            FileVaultView()
                .tabItem {
                    Label("Files", systemImage: "folder.fill")
                }
                .accessibilityLabel("File Vault Tab")

            // MARK: - Notes Vault Tab
            NotesVaultView()
                .environmentObject(notesViewModel)
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }
                .accessibilityLabel("Notes Vault Tab")

            // MARK: - Settings Tab
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .accessibilityLabel("Settings Tab")
        }
        .accentColor(.blue) // Ensures a consistent tab selection color
    }
}

// MARK: - Previews

#if DEBUG
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
#endif
