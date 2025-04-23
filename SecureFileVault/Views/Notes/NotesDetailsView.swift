//
//  NotesDetailsView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/22/25.
//

import SwiftUI

struct NoteDetailsView: View {
    @Binding var note: NoteModel

    var body: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Enter title", text: $note.title)
            }
            Section(header: Text("Content")) {
                TextEditor(text: $note.content)
                    .frame(minHeight: 200)
            }
        }
        .navigationTitle("Note Details")
    }
}

#if DEBUG
struct NoteDetailsView_Previews: PreviewProvider {
    @State static var sampleNote = NoteModel(
        id: UUID(),
        title: "Sample Note",
        content: "This is a sample note for preview purposes.", tags: ["Sample", "Preview"],
        dateAdded: Date()
    )

    static var previews: some View {
        NoteDetailsView(note: $sampleNote)
    }
}
#endif
