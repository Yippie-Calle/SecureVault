//
//  FileVaultView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//

import SwiftUI

struct FileVaultView: View {
    @StateObject private var viewModel = FileVaultViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.files) { file in
                    Text(file.name) // Corrected property name
                }
            }
            .navigationTitle("Secure Files")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: viewModel.importFile) { // Ensure this method exists
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}
