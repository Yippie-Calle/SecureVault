//
//  NewNoteView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/22/25.
//

import SwiftUI

// MARK: - NewNoteView

/// A view for creating a new note with a title, content, and tags.
struct NewNoteView: View {
    // MARK: - Observed Objects

    /// The view model for managing notes in the vault.
    @ObservedObject var viewModel: NotesVaultViewModel

    // MARK: - Binding Properties

    /// A binding to control the presentation state of the view.
    @Binding var isPresented: Bool

    // MARK: - State Properties

    /// The title of the note.
    @State private var title = ""

    /// The content of the note.
    @State private var content = ""

    /// The tags associated with the note.
    @State private var tags = ""

    // MARK: - Body

    var body: some View {
        NavigationView {
            Form {
                // MARK: - Title Section
                Section(header: Text("Title")) {
                    TextField("Enter title", text: $title)
                }

                // MARK: - Content Section
                Section(header: Text("Content")) {
                    TextEditor(text: $content)
                        .frame(minHeight: 200)
                }

                // MARK: - Tags Section
                Section(header: Text("Tags")) {
                    TextField("Add tags (e.g., #work, #personal)", text: $tags)
                }
            }
            .navigationTitle("New Note")
            .toolbar {
                // MARK: - Cancel Button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }

                // MARK: - Save Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let tagList = tags.split(separator: " ").map { String($0) }
                        viewModel.createNewNote(title: title, content: content, tags: tagList)
                        isPresented = false
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
        }
    }
}

// MARK: - Previews

#if DEBUG
struct NewNoteView_Previews: PreviewProvider {
    static var previews: some View {
        NewNoteView(viewModel: NotesVaultViewModel(), isPresented: .constant(true))
    }
}
#endif
