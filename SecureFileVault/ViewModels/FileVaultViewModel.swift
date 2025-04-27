//
//  FileVaultViewModel.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//
import Foundation
import CryptoKit

// MARK: - FileVaultViewModel

/// A view model responsible for managing files in the secure vault.
class FileVaultViewModel: ObservableObject {
    // MARK: - Published Properties

    /// The list of files stored in the vault.
    @Published var files: [FileModel] = []

    // MARK: - Encryption Key

    /// Symmetric key for encryption (securely initialized).
    let encryptionKey: SymmetricKey

    // MARK: - Initialization

    /// Initializes the `FileVaultViewModel` with a securely generated symmetric key.
    init() {
        // Generate a symmetric key (in a real app, securely store/retrieve this key).
        encryptionKey = SymmetricKey(size: .bits256)
    }

    // MARK: - File Management

    /// Deletes a file from the vault.
    /// - Parameter file: The file to delete.
    func deleteFile(_ file: FileModel) {
        files.removeAll { $0.id == file.id }
    }
}
