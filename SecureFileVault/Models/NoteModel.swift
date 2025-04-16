//
//  NoteModel.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//
import Foundation

struct NoteModel: Identifiable {
    let id: UUID
    let title: String
    let content: String
    let dateAdded: Date

    // Computed property for preview
    var preview: String {
        content.prefix(50) + (content.count > 50 ? "..." : "")
    }
}
