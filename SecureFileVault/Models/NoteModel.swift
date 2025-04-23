//
//  NoteModel.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//
import Foundation

struct NoteModel: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    var tags: [String]
    let dateAdded: Date

    var preview: String {
        if content.isEmpty {
            return ""
        }
        return content.prefix(50) + (content.count > 50 ? "..." : "")
    }
}
