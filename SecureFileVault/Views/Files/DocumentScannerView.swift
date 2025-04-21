//
//  DocumentScannerView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/16/25.
//

import SwiftUI
import VisionKit

// A SwiftUI wrapper for VNDocumentCameraViewController to enable document scanning
struct DocumentScannerView: UIViewControllerRepresentable {
    // Callback to return scanned images to the parent view
    var onScanComplete: ([UIImage]) -> Void

    // Creates and configures the VNDocumentCameraViewController
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scanner = VNDocumentCameraViewController() // Initialize the document scanner
        scanner.delegate = context.coordinator // Set the delegate to handle scanner events
        return scanner
    }

    // Updates the scanner view controller (not used in this implementation)
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    // Creates the coordinator to handle delegate methods
    func makeCoordinator() -> Coordinator {
        Coordinator(onScanComplete: onScanComplete) // Pass the callback to the coordinator
    }

    // Coordinator class to handle VNDocumentCameraViewControllerDelegate methods
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        // Callback to return scanned images
        var onScanComplete: ([UIImage]) -> Void

        // Initialize the coordinator with the callback
        init(onScanComplete: @escaping ([UIImage]) -> Void) {
            self.onScanComplete = onScanComplete
        }

        // Called when the scanning is completed successfully
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            var scannedImages = [UIImage]() // Array to store scanned images
            for pageIndex in 0..<scan.pageCount {
                scannedImages.append(scan.imageOfPage(at: pageIndex)) // Add each scanned page as an image
            }
            onScanComplete(scannedImages) // Pass the scanned images to the callback
            controller.dismiss(animated: true) // Dismiss the scanner view
        }

        // Called when the user cancels the scanning process
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true) // Dismiss the scanner view
        }

        // Called when the scanning process fails
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Scanning failed: \(error.localizedDescription)") // Log the error
            controller.dismiss(animated: true) // Dismiss the scanner view
        }
    }
}
