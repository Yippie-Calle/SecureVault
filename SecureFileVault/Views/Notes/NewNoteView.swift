//
//  NewNoteView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/22/25.
//

import SwiftUI

struct NewNoteView: View {
    @ObservedObject var viewModel: NotesVaultViewModel
    @Binding var isPresented: Bool

    @State private var title = ""
    @State private var content = ""
    @State private var tags = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter title", text: $title)
                }
                Section(header: Text("Content")) {
                    TextEditor(text: $content)
                        .frame(minHeight: 200)
                }
                Section(header: Text("Tags")) {
                    TextField("Add tags (e.g., #work, #personal)", text: $tags)
                }
            }
            .navigationTitle("New Note")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
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
