//
//  SplashScreenView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//

import SwiftUI

// MARK: - SplashScreenView

/// A view that displays a splash screen with animations before navigating to the next screen.
struct SplashScreenView: View {
    // MARK: - State Objects

    /// The authentication manager for handling user authentication.
    @StateObject private var userManager = UserManager()

    // MARK: - State Properties

    /// A flag indicating whether to show the company logo.
    @State private var showCompanyLogo = true

    /// A flag indicating whether to show the app logo.
    @State private var showAppLogo = false

    /// A flag indicating whether to navigate to the next screen.
    @State private var navigateToNext = false

    // MARK: - Body

    var body: some View {
        NavigationStack {
            if navigateToNext {
                // MARK: - Navigation to Login or Create Account View
                LoginOrCreateAccountView()
                    .environmentObject(userManager)
            } else {
                // MARK: - Splash Screen Content
                ZStack {
                    if showCompanyLogo {
                        Image("CompanyLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .transition(.opacity)
                    } else if showAppLogo {
                        Image("AppLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .transition(.opacity)
                    }
                }
                .onAppear {
                    startSplashSequence()
                }
                .background(Color(.systemBackground)) // Ensures the background matches system theme
                .edgesIgnoringSafeArea(.all) // Extends the background to the edges
            }
        }
    }

    // MARK: - Splash Sequence

    /// Starts the splash screen animation sequence.
    private func startSplashSequence() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 1)) {
                showCompanyLogo = false
                showAppLogo = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 1)) {
                    navigateToNext = true
                }
            }
        }
    }
}

// MARK: - Previews

#if DEBUG
struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
            .environmentObject(UserManager()) // Provide the required environment object
    }
}
#endif
