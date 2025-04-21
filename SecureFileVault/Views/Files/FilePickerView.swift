//
//  FilePickerView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/17/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct FilePickerView: UIViewControllerRepresentable {
    var onPickedFiles: ([URL]) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.data])
        documentPicker.allowsMultipleSelection = true
        documentPicker.delegate = context.coordinator
        return documentPicker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onPickedFiles: onPickedFiles)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var onPickedFiles: ([URL]) -> Void

        init(onPickedFiles: @escaping ([URL]) -> Void) {
            self.onPickedFiles = onPickedFiles
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            onPickedFiles(urls)
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            onPickedFiles([])
        }
    }
}
