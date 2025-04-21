//
//  FileVaultViewModel.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//
import Foundation
import Foundation
import CryptoKit

class FileVaultViewModel: ObservableObject {
    @Published var files: [FileModel] = []

    // Symmetric key for encryption (securely initialized)
    let encryptionKey: SymmetricKey

    init() {
        // Generate a symmetric key (in a real app, securely store/retrieve this key)
        encryptionKey = SymmetricKey(size: .bits256)
    }

    func deleteFile(_ file: FileModel) {
        files.removeAll { $0.id == file.id }
    }
}
