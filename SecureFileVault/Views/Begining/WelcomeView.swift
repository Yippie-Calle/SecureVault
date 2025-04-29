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
            VStack {
                // MARK: - Welcome Message
                Text("Welcome, \(username)!")
                    .font(.largeTitle)
                    .padding()

                // MARK: - Navigation Link
                NavigationLink("Continue", destination: MainTabView()
                    .navigationBarBackButtonHidden(true))
            }
        }
        .navigationBarBackButtonHidden(true)
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
