//
//  NotesVaultView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//

import SwiftUI

// MARK: - NotesVaultView

/// A view that displays a list of secure notes and allows users to create, view, and delete notes.
struct NotesVaultView: View {
    // MARK: - State Objects

    /// The view model for managing notes in the vault.
    @StateObject private var viewModel = NotesVaultViewModel()

    // MARK: - State Properties

    /// A flag to control the presentation of the new note view.
    @State private var isPresentingNewNoteView = false

    // MARK: - Body

    var body: some View {
        NavigationView {
            // MARK: - Notes List
            List {
                ForEach(viewModel.notes, id: \.id) { note in
                    // MARK: - Navigation Link to Note Details
                    NavigationLink(destination: NoteDetailsView(note: Binding(
                        get: { viewModel.notes.first(where: { $0.id == note.id }) ?? note },
                        set: { updatedNote in
                            if let index = viewModel.notes.firstIndex(where: { $0.id == note.id }) {
                                viewModel.notes[index] = updatedNote
                            }
                        }
                    ))) {
                        VStack(alignment: .leading) {
                            // MARK: - Note Title
                            Text(note.title).bold()

                            // MARK: - Note Preview
                            Text(note.preview)
                                .font(.caption)
                                .foregroundColor(.gray)

                            // MARK: - Note Tags
                            if !note.tags.isEmpty {
                                Text(note.tags.joined(separator: ", "))
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteNote) // MARK: - Delete Note
            }
            .navigationTitle("Secure Notes") // MARK: - Navigation Title
            .toolbar {
                // MARK: - Add Note Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isPresentingNewNoteView = true }) {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .sheet(isPresented: $isPresentingNewNoteView) {
                // MARK: - New Note View
                NewNoteView(viewModel: viewModel, isPresented: $isPresentingNewNoteView)
            }
        }
    }
}

// MARK: - Previews

#if DEBUG
struct NotesVaultView_Previews: PreviewProvider {
    static var previews: some View {
        NotesVaultView()
    }
}
#endif
