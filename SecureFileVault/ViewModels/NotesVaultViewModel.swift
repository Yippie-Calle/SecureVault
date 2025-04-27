//
//  NotesVaultViewModel.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//

import Foundation

// MARK: - NotesVaultViewModel

/// A view model responsible for managing notes in the secure vault.
class NotesVaultViewModel: ObservableObject {
    // MARK: - Published Properties

    /// The list of notes stored in the vault.
    @Published var notes: [NoteModel] = [] {
        didSet {
            saveNotes()
        }
    }

    /// The set of available tags for notes.
    @Published var availableTags: Set<String> = [] {
        didSet {
            saveTags()
        }
    }

    // MARK: - Initialization

    /// Initializes the `NotesVaultViewModel` and loads saved notes and tags.
    init() {
        loadNotes()
        loadTags()
    }

    // MARK: - Note Management

    /// Creates a new note and adds it to the vault.
    /// - Parameters:
    ///   - title: The title of the note.
    ///   - content: The content of the note.
    ///   - tags: The tags associated with the note.
    func createNewNote(title: String, content: String, tags: [String]) {
        let newNote = NoteModel(id: UUID(), title: title, content: content, tags: tags, dateAdded: Date())
        notes.append(newNote)
        availableTags.formUnion(tags)
    }

    /// Deletes a note at the specified offsets.
    /// - Parameter offsets: The index set of notes to delete.
    func deleteNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }

    // MARK: - Persistence Keys

    /// The key used to store notes in `UserDefaults`.
    private let notesKey = "secureNotes"

    /// The key used to store tags in `UserDefaults`.
    private let tagsKey = "availableTags"

    // MARK: - Persistence

    /// Saves the notes to `UserDefaults`.
    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: notesKey)
        }
    }

    /// Loads the notes from `UserDefaults`.
    private func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: notesKey),
           let decoded = try? JSONDecoder().decode([NoteModel].self, from: data) {
            notes = decoded
        }
    }

    /// Saves the tags to `UserDefaults`.
    private func saveTags() {
        if let encoded = try? JSONEncoder().encode(Array(availableTags)) {
            UserDefaults.standard.set(encoded, forKey: tagsKey)
        }
    }

    /// Loads the tags from `UserDefaults`.
    private func loadTags() {
        if let data = UserDefaults.standard.data(forKey: tagsKey),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            availableTags = Set(decoded)
        }
    }
}
