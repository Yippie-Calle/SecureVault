//
//  FileModel.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//


import Foundation

// MARK: - FileModel

/// A model representing a file stored in the secure vault.
struct FileModel: Identifiable {
    /// Unique identifier for the file.
    let id: UUID
    
    /// Name of the file.
    let name: String
    
    /// Encrypted data of the file.
    let encryptedData: Data
    
    /// Date when the file was added to the vault.
    let dateAdded: Date
    
    /// Indicates whether the file has been scanned.
    let isScanned: Bool = false
}
