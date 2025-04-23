//
//  NotesVaultViewModel.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//

import Foundation

class NotesVaultViewModel: ObservableObject {
    @Published var notes: [NoteModel] = [] {
        didSet {
            saveNotes()
        }
    }
    @Published var availableTags: Set<String> = [] {
        didSet {
            saveTags()
        }
    }

    init() {
        loadNotes()
        loadTags()
    }

    func createNewNote(title: String, content: String, tags: [String]) {
        let newNote = NoteModel(id: UUID(), title: title, content: content, tags: tags, dateAdded: Date())
        notes.append(newNote)
        availableTags.formUnion(tags)
    }

    func deleteNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }

    private let notesKey = "secureNotes"
    private let tagsKey = "availableTags"

    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: notesKey)
        }
    }

    private func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: notesKey),
           let decoded = try? JSONDecoder().decode([NoteModel].self, from: data) {
            notes = decoded
        }
    }

    private func saveTags() {
        if let encoded = try? JSONEncoder().encode(Array(availableTags)) {
            UserDefaults.standard.set(encoded, forKey: tagsKey)
        }
    }

    private func loadTags() {
        if let data = UserDefaults.standard.data(forKey: tagsKey),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            availableTags = Set(decoded)
        }
    }
}
