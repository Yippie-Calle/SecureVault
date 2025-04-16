//
//  MainTabView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            FileVaultView()
                .tabItem {
                    Label("Files", systemImage: "folder.fill")
                }

            NotesVaultView()
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}
