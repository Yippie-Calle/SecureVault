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
                LoginOrCreateAccountView()
                    .environmentObject(userManager)
            } else {
                ZStack {
                    if showCompanyLogo {
                        Image("CompanyLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    } else if showAppLogo {
                        Image("AppLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    }
                }
                .onAppear {
                    startSplashSequence()
                }
            }
        }
    }

    // MARK: - Splash Sequence

    /// Starts the splash screen animation sequence.
    private func startSplashSequence() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showCompanyLogo = false
                showAppLogo = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
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
