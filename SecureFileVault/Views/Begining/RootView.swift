//
//  RootView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/29/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var userManager: UserManager

    var body: some View {
        if userManager.isSignedIn {
            MainTabView()
        } else {
            LoginOrCreateAccountView()
        }
    }
}
