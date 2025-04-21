//
//  EncryptionService.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//

import Foundation
import CryptoKit

struct EncryptionService {
    static func encrypt(data: Data, using key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.seal(data, using: key)
        return sealedBox.combined!
    }

    static func decrypt(data: Data, using key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        return try AES.GCM.open(sealedBox, using: key)
    }
}
