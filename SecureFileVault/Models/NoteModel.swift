//
//  NoteModel.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//
import Foundation

// MARK: - NoteModel

/// A model representing a note stored in the secure vault.
struct NoteModel: Identifiable, Codable {
    /// Unique identifier for the note.
    let id: UUID

    /// Title of the note.
    var title: String

    /// Content of the note.
    var content: String

    /// Tags associated with the note.
    var tags: [String]

    /// Date when the note was added to the vault.
    let dateAdded: Date

    // MARK: - Computed Properties

    /// A preview of the note's content, limited to 50 characters.
    var preview: String {
        if content.isEmpty {
            return ""
        }
        return content.prefix(50) + (content.count > 50 ? "..." : "")
    }
}
