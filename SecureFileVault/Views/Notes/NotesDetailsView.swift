//
//  NotesDetailsView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/22/25.
//

import SwiftUI

// MARK: - NoteDetailsView

/// A view for displaying and editing the details of a note.
struct NoteDetailsView: View {
    // MARK: - Binding Properties

    /// A binding to the note being displayed or edited.
    @Binding var note: NoteModel

    // MARK: - Body

    var body: some View {
        Form {
            // MARK: - Title Section
            Section(header: Text("Title")) {
                TextField("Enter title", text: $note.title)
            }

            // MARK: - Content Section
            Section(header: Text("Content")) {
                TextEditor(text: $note.content)
                    .frame(minHeight: 200)
            }
        }
        .navigationTitle("Note Details")
    }
}

// MARK: - Previews

#if DEBUG
struct NoteDetailsView_Previews: PreviewProvider {
    // MARK: - Sample Data

    /// A sample note for preview purposes.
    @State static var sampleNote = NoteModel(
        id: UUID(),
        title: "Sample Note",
        content: "This is a sample note for preview purposes.",
        tags: ["Sample", "Preview"],
        dateAdded: Date()
    )

    static var previews: some View {
        NoteDetailsView(note: $sampleNote)
    }
}
#endif
