//
//  FileVaultViewModel.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//

import Foundation

class FileVaultViewModel: ObservableObject {
    @Published var files: [FileModel] = []

    func importFile() {
        // Example implementation for importing a file
        let newFile = FileModel(
            id: UUID(),
            name: "New File",
            encryptedData: Data(),
            dateAdded: Date()
        )
        files.append(newFile)
    }
}
