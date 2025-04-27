//
//  EncryptionService.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//

import Foundation
import CryptoKit

// MARK: - EncryptionService

/// A service for encrypting and decrypting data using symmetric encryption.
struct EncryptionService {
    // MARK: - Encryption

    /// Encrypts the given data using the provided symmetric key.
    /// - Parameters:
    ///   - data: The data to encrypt.
    ///   - key: The symmetric key to use for encryption.
    /// - Returns: The encrypted data.
    /// - Throws: An error if encryption fails.
    static func encrypt(data: Data, using key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.seal(data, using: key)
        return sealedBox.combined!
    }

    // MARK: - Decryption

    /// Decrypts the given data using the provided symmetric key.
    /// - Parameters:
    ///   - data: The encrypted data to decrypt.
    ///   - key: The symmetric key to use for decryption.
    /// - Returns: The decrypted data.
    /// - Throws: An error if decryption fails.
    static func decrypt(data: Data, using key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        return try AES.GCM.open(sealedBox, using: key)
    }
}
