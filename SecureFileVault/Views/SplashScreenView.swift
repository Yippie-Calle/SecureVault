//
//  SplashScreenView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var showCreatorLogo = true
    @State private var showAppLogo = false
    @State private var navigateToMainView = false

    var body: some View {
        if navigateToMainView {
            MainTabView() // Replace with your main view
        } else {
            ZStack {
                Color.white // Background color
                    .ignoresSafeArea()

                if showCreatorLogo {
                    Image("CompanyLogo.png") // Ensure this is in Assets.xcassets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .transition(.opacity)
                } else if showAppLogo {
                    Text("SecureVault") // Placeholder for app logo
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .transition(.opacity)
                }
            }
            .onAppear {
                startSplashSequence()
            }
        }
    }

    private func startSplashSequence() {
        // Show creator's logo for 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showCreatorLogo = false
                showAppLogo = true
            }

            // Show app's logo for 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showAppLogo = false
                    navigateToMainView = true
                }
            }
        }
    }
}
