//
//  WelcomeView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/23/25.
//

import SwiftUI

// MARK: - WelcomeView

/// A view that greets the user and provides navigation to the main application.
struct WelcomeView: View {
    // MARK: - Properties

    /// The username of the currently signed-in user.
    var username: String

    // MARK: - Body

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // MARK: - Welcome Message
                Text("Welcome, \(username)!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .accessibilityLabel("Welcome, \(username)")

                // MARK: - Description
                Text("We're glad to have you here. Tap continue to start using SecureVault.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // MARK: - Navigation Link
                NavigationLink(destination: MainTabView()
                    .navigationBarBackButtonHidden(true)) {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .accessibilityLabel("Continue to the main application")
            }
            .padding()
            //.navigationTitle("Welcome")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
}

// MARK: - Previews

#if DEBUG
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(username: "TestUser")
    }
}
#endif
