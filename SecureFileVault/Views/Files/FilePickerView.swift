//
//  FilePickerView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/17/25.
//

import SwiftUI
import UniformTypeIdentifiers

// MARK: - FilePickerView

/// A view that allows users to pick files using the system document picker.
struct FilePickerView: UIViewControllerRepresentable {
    // MARK: - Properties

    /// A closure that is called with the selected file URLs.
    var onPickedFiles: ([URL]) -> Void

    // MARK: - UIViewControllerRepresentable Methods

    /// Creates the `UIDocumentPickerViewController` instance.
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.data])
        documentPicker.allowsMultipleSelection = true
        documentPicker.delegate = context.coordinator
        return documentPicker
    }

    /// Updates the `UIDocumentPickerViewController` instance.
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    /// Creates the coordinator for handling document picker events.
    func makeCoordinator() -> Coordinator {
        Coordinator(onPickedFiles: onPickedFiles)
    }

    // MARK: - Coordinator

    /// A coordinator class to handle `UIDocumentPickerViewController` delegate methods.
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        // MARK: - Properties

        /// A closure that is called with the selected file URLs.
        var onPickedFiles: ([URL]) -> Void

        // MARK: - Initializer

        /// Initializes the coordinator with the file selection closure.
        init(onPickedFiles: @escaping ([URL]) -> Void) {
            self.onPickedFiles = onPickedFiles
        }

        // MARK: - UIDocumentPickerDelegate Methods

        /// Called when the user selects files.
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            onPickedFiles(urls)
        }

        /// Called when the user cancels the document picker.
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            onPickedFiles([])
        }
    }
}
