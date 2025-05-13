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
            Section(header: Text("Title").font(.headline)) {
                TextField("Enter title", text: $note.title)
                    .textContentType(.none)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .accessibilityLabel("Note Title")
            }

            // MARK: - Content Section
            Section(header: Text("Content").font(.headline)) {
                TextEditor(text: $note.content)
                    .frame(minHeight: 200)
                    .accessibilityLabel("Note Content")
            }

            // MARK: - Tags Section
            if !note.tags.isEmpty {
                Section(header: Text("Tags").font(.headline)) {
                    Text(note.tags.joined(separator: ", "))
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .accessibilityLabel("Note Tags")
                }
            }
        }
        .navigationTitle("Note Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // MARK: - Save Button
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveNote()
                }
                .accessibilityLabel("Save Note Button")
            }
        }
    }

    // MARK: - Actions

    /// Saves the note. Add your save logic here.
    private func saveNote() {
        // Implement save functionality if needed.
        print("Note saved: \(note.title)")
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
        NavigationView {
            NoteDetailsView(note: $sampleNote)
        }
    }
}
#endif
