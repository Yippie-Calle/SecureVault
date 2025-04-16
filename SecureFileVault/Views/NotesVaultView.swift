//
//  NotesVaultView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//

import SwiftUI

struct NotesVaultView: View {
    @StateObject private var viewModel = NotesVaultViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.notes) { note in
                    VStack(alignment: .leading) {
                        Text(note.title).bold()
                        Text(note.preview)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Secure Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: viewModel.createNewNote) {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
    }
}
