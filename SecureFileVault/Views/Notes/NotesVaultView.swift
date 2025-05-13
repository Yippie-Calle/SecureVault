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

    /// A state property to hold the selected note for editing.
    @State private var selectedNote: NoteModel?

    // MARK: - Body

    var body: some View {
        NavigationView {
            // MARK: - Notes List
            List {
                ForEach(viewModel.notes) { note in
                    // MARK: - Navigation Link to Note Details
                    NavigationLink(
                        destination: {
                            if let bindingNote = binding(for: note) {
                                NoteDetailsView(note: bindingNote)
                            }
                        },
                        label: {
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
                    )
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
                NewNoteView()
                    .environmentObject(viewModel)
            }
        }
    }

    // MARK: - Helper Methods

    /// Returns a binding to the given note if it exists in the view model's notes array.
    private func binding(for note: NoteModel) -> Binding<NoteModel>? {
        guard let index = viewModel.notes.firstIndex(where: { $0.id == note.id }) else {
            return nil
        }
        return $viewModel.notes[index]
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
