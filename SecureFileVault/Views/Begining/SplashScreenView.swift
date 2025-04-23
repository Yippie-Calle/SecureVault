//
//  SplashScreenView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//

import SwiftUI

import SwiftUI

struct SplashScreenView: View {
    @StateObject private var authManager = AuthManager()
    @State private var showCompanyLogo = true
    @State private var showAppLogo = false
    @State private var navigateToNext = false

    var body: some View {
        NavigationStack {
            if navigateToNext {
                if authManager.isSignedIn {
                    WelcomeView(username: authManager.currentUsername ?? "Guest")
                } else {
                    LoginOrCreateAccountView()
                        .environmentObject(authManager)
                }
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

    private func startSplashSequence() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showCompanyLogo = false
                showAppLogo = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showAppLogo = false
                    navigateToNext = true
                }
            }
        }
    }
}
#if DEBUG
struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
            .environmentObject(AuthManager()) // Provide the required environment object
    }
}
#endif
