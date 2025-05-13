//
//  FileManager.swift
//  SecureVault
//
//  Created by Bryan Calle on 5/9/25.
//

import Foundation

class FileManagerService {
    static let shared = FileManagerService()
    private let fileManager = FileManager.default
    private let documentsDirectory: URL

    private init() {
        // Get the app's document directory
        documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    /// Saves data to a file in the document directory.
    /// - Parameters:
    ///   - fileName: The name of the file.
    ///   - data: The data to save.
    /// - Returns: A Boolean indicating success or failure.
    func saveFile(fileName: String, data: Data) -> Bool {
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL)
            return true
        } catch {
            print("Error saving file: \(error.localizedDescription)")
            return false
        }
    }

    /// Reads data from a file in the document directory.
    /// - Parameter fileName: The name of the file.
    /// - Returns: The data read from the file, or nil if an error occurs.
    func readFile(fileName: String) -> Data? {
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        do {
            return try Data(contentsOf: fileURL)
        } catch {
            print("Error reading file: \(error.localizedDescription)")
            return nil
        }
    }

    /// Deletes a file in the document directory.
    /// - Parameter fileName: The name of the file.
    /// - Returns: A Boolean indicating success or failure.
    func deleteFile(fileName: String) -> Bool {
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        do {
            try fileManager.removeItem(at: fileURL)
            return true
        } catch {
            print("Error deleting file: \(error.localizedDescription)")
            return false
        }
    }

    /// Lists all files in the document directory.
    /// - Returns: An array of file names, or nil if an error occurs.
    func listFiles() -> [String]? {
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            return fileURLs.map { $0.lastPathComponent }
        } catch {
            print("Error listing files: \(error.localizedDescription)")
            return nil
        }
    }
}
