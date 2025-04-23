//
//  NotesVaultView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//

import SwiftUI

struct NotesVaultView: View {
    @StateObject private var viewModel = NotesVaultViewModel()
    @State private var isPresentingNewNoteView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.notes, id: \.id) { note in
                    NavigationLink(destination: NoteDetailsView(note: Binding(
                        get: { viewModel.notes.first(where: { $0.id == note.id }) ?? note },
                        set: { updatedNote in
                            if let index = viewModel.notes.firstIndex(where: { $0.id == note.id }) {
                                viewModel.notes[index] = updatedNote
                            }
                        }
                    ))) {
                        VStack(alignment: .leading) {
                            Text(note.title).bold()
                            Text(note.preview)
                                .font(.caption)
                                .foregroundColor(.gray)
                            if !note.tags.isEmpty {
                                Text(note.tags.joined(separator: ", "))
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteNote)
            }
            .navigationTitle("Secure Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isPresentingNewNoteView = true }) {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .sheet(isPresented: $isPresentingNewNoteView) {
                NewNoteView(viewModel: viewModel, isPresented: $isPresentingNewNoteView)
            }
        }
    }
}
#if DEBUG
struct NotesVaultView_Previews: PreviewProvider {
    static var previews: some View {
        NotesVaultView()
    }
}
#endif
