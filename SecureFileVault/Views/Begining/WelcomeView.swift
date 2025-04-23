//
//  WelcomeView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/23/25.
//

import SwiftUI

struct WelcomeView: View {
    var username: String

    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome, \(username)!")
                    .font(.largeTitle)
                    .padding()
                NavigationLink("Continue", destination: MainTabView())
            }
        }
    }
}
