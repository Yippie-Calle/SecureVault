//
//  NewNoteView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/22/25.
//

import SwiftUI

// MARK: - NewNoteView

/// A view for creating a new note with a title and content.
struct NewNoteView: View {
    // MARK: - Environment Objects

    /// The notes manager for handling note creation and storage.
    @EnvironmentObject var notesManager: NotesManager

    // MARK: - State Properties

    /// The title of the new note.
    @State private var title: String = ""

    /// The content of the new note.
    @State private var content: String = ""

    /// Tracks whether the note is being saved.
    @State private var isSaving: Bool = false

    /// Tracks whether the save button is disabled.
    private var isSaveDisabled: Bool {
        title.isEmpty || content.isEmpty
    }

    // MARK: - Body

    var body: some View {
        NavigationView {
            Form {
                // MARK: - Title Section
                Section(header: Text("Title").font(.headline)) {
                    TextField("Enter note title", text: $title)
                        .textContentType(.none)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                        .accessibilityLabel("Note Title")
                }

                // MARK: - Content Section
                Section(header: Text("Content").font(.headline)) {
                    TextEditor(text: $content)
                        .frame(minHeight: 200)
                        .accessibilityLabel("Note Content")
                }

                // MARK: - Save Button
                Section {
                    Button(action: saveNote) {
                        HStack {
                            Spacer()
                            if isSaving {
                                ProgressView()
                            } else {
                                Text("Save Note")
                                    .fontWeight(.bold)
                            }
                            Spacer()
                        }
                    }
                    .disabled(isSaveDisabled)
                    .foregroundColor(isSaveDisabled ? .gray : .blue)
                    .accessibilityLabel("Save Note Button")
                }
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // MARK: - Cancel Button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismissView()
                    }
                    .accessibilityLabel("Cancel Button")
                }
            }
        }
    }

    // MARK: - Actions

    /// Saves the new note and dismisses the view.
    private func saveNote() {
        guard !isSaveDisabled else { return }
        isSaving = true
        notesManager.addNote(title: title, content: content)
        isSaving = false
        dismissView()
    }

    /// Dismisses the current view.
    private func dismissView() {
        // Add logic to dismiss the view, e.g., using a presentation mode binding.
    }
}

// MARK: - Previews

#if DEBUG
struct NewNoteView_Previews: PreviewProvider {
    static var previews: some View {
        NewNoteView()
            .environmentObject(NotesManager())
    }
}
#endif
