//
//  FileModel.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//

import Foundation

struct FileModel: Identifiable {
    let id: UUID
    let name: String
    let encryptedData: Data
    let dateAdded: Date
    let isScanned: Bool = false // Default value for isScanned
}
