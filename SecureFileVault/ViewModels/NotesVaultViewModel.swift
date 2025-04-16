//
//  NotesVaultViewModel.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//

import Foundation

class NotesVaultViewModel: ObservableObject {
    @Published var notes: [NoteModel] = []

    func createNewNote() {
        // Example implementation for creating a new note
        let newNote = NoteModel(
            id: UUID(),
            title: "New Note",
            content: "This is a new note.",
            dateAdded: Date()
        )
        notes.append(newNote)
    }
}
