//
//  NotesManager.swift
//  SecureVault
//
//  Created by Bryan Calle on 5/13/25.
//

import Foundation

// MARK: - Note Model

/// A model representing a single note.
struct Note: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    var dateCreated: Date
}

// MARK: - NotesManager

/// A class for managing notes, including creation, deletion, and persistence.
class NotesManager: ObservableObject {
    // MARK: - Published Properties

    /// The list of notes.
    @Published var notes: [Note] = []

    // MARK: - Initialization

    init() {
        loadNotes()
    }

    // MARK: - Methods

    /// Adds a new note to the list and saves it.
    /// - Parameters:
    ///   - title: The title of the note.
    ///   - content: The content of the note.
    func addNote(title: String, content: String) {
        let newNote = Note(id: UUID(), title: title, content: content, dateCreated: Date())
        notes.append(newNote)
        saveNotes()
    }

    /// Deletes a note from the list and saves the changes.
    /// - Parameter note: The note to delete.
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
    }

    /// Loads notes from persistent storage.
    private func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: "notes"),
           let savedNotes = try? JSONDecoder().decode([Note].self, from: data) {
            notes = savedNotes
        }
    }

    /// Saves the current list of notes to persistent storage.
    private func saveNotes() {
        if let data = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(data, forKey: "notes")
        }
    }
}
