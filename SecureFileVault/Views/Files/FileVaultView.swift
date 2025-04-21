//
//  FileVaultView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//

import SwiftUI

// MARK: - Main View
struct FileVaultView: View {
    // MARK: - State Variables
    @StateObject private var viewModel = FileVaultViewModel() // ViewModel to manage file state
    @State private var showSortOptions = false // Controls sort options display
    @State private var isListView = true // Toggles between list and icon views
    @State private var selectedFile: FileModel? // Tracks the selected file
    @State private var showFileDetail = false // Controls file detail view display
    @State private var showActionSheet = false // Controls action sheet display
    @State private var showScanner = false // Controls document scanner display
    @State private var showFilePicker = false // Controls file picker display

    // MARK: - Body
    var body: some View {
        NavigationView {
            Group {
                if isListView {
                    listView // List view for files
                } else {
                    iconView // Icon grid view for files
                }
            }
            .navigationTitle("Secure Files") // Title of the navigation bar
            .toolbar {
                // "+" button for adding files
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showActionSheet = true }) {
                        Image(systemName: "plus") // "+" icon
                    }
                }
                // Sort button for sorting files
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showSortOptions = true }) {
                        Image(systemName: "arrow.up.arrow.down") // Sort icon
                    }
                }
                // Toggle view button for switching between list and icon views
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { isListView.toggle() }) {
                        Image(systemName: isListView ? "square.grid.2x2" : "list.bullet") // Toggle view icon
                    }
                }
            }
            // Action sheet for adding files
            .confirmationDialog("Add File", isPresented: $showActionSheet, titleVisibility: .automatic) {
                Button("Upload File") {
                    showFilePicker = true // Show the file picker
                }
                Button("Scan Document") {
                    showScanner = true // Show the document scanner
                }
                Button("Cancel", role: .cancel) { }
            }
            // Sheet for document scanner
            .sheet(isPresented: $showScanner) {
                DocumentScannerView { scannedImages in
                    handleScannedDocuments(scannedImages) // Handle scanned documents
                }
            }
            // Sheet for file picker
            .sheet(isPresented: $showFilePicker) {
                FilePickerView { urls in
                    handlePickedFiles(urls) // Handle picked files
                }
            }
        }
    }

    // MARK: - List View
    private var listView: some View {
        List {
            ForEach(viewModel.files) { file in
                HStack {
                    Text(file.name) // File name
                    Spacer()
                    Text(file.dateAdded, style: .date) // File date
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedFile = file // Open file detail
                }
                .onLongPressGesture {
                    previewFile(file) // Preview file
                }
                .swipeActions {
                    Button(role: .destructive) {
                        viewModel.deleteFile(file) // Delete file
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
    }

    // MARK: - Icon View
    private var iconView: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                ForEach(viewModel.files) { file in
                    VStack {
                        Image(systemName: "doc.text") // Placeholder icon
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text(file.name)
                            .font(.caption)
                            .lineLimit(1)
                    }
                    .onTapGesture {
                        if viewModel.files.count == 1 {
                            selectedFile = file // Show single file in a sheet
                        } else {
                            showStackedSheets(for: viewModel.files) // Show stacked sheets
                        }
                    }
                }
            }
        }
    }

    // MARK: - File Handling Methods
    private func handlePickedFiles(_ urls: [URL]) {
        for url in urls {
            do {
                let fileData = try Data(contentsOf: url) // Read file data
                let encryptedData = try EncryptionService.encrypt(data: fileData, using: viewModel.encryptionKey) // Encrypt data

                let newFile = FileModel(
                    id: UUID(),
                    name: url.lastPathComponent,
                    encryptedData: encryptedData, // Store encrypted data
                    dateAdded: Date()
                )
                viewModel.files.append(newFile) // Add file to ViewModel
            } catch {
                print("Error encrypting file from URL \(url): \(error.localizedDescription)")
            }
        }
    }

    private func handleScannedDocuments(_ images: [UIImage]) {
        guard !images.isEmpty else {
            print("No documents scanned.") // Log if no documents were scanned
            return
        }
        for (index, image) in images.enumerated() {
            do {
                if let imageData = image.jpegData(compressionQuality: 1.0) {
                    let encryptedData = try EncryptionService.encrypt(data: imageData, using: viewModel.encryptionKey) // Encrypt data

                    let newFile = FileModel(
                        id: UUID(),
                        name: "Scanned Document \(index + 1)",
                        encryptedData: encryptedData, // Store encrypted data
                        dateAdded: Date()
                    )
                    viewModel.files.append(newFile) // Add file to ViewModel
                }
            } catch {
                print("Error encrypting scanned document \(index + 1): \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Utility Methods
    private func previewFile(_ file: FileModel) {
        // Implement file preview logic here
        print("Previewing file: \(file.name)")
    }

    private func showStackedSheets(for files: [FileModel]) {
        // Implement stacked sheets logic here
        print("Showing stacked sheets for \(files.count) files")
    }
}

// Preview provider for SwiftUI previews
#if DEBUG
struct FileVaultView_Previews: PreviewProvider {
    static var previews: some View {
        // Mock ViewModel with sample data for preview
        let mockViewModel = FileVaultViewModel()
        mockViewModel.files = [
            FileModel(
                id: UUID(),
                name: "Sample File 1",
                encryptedData: Data(),
                dateAdded: Date()
            ),
            FileModel(
                id: UUID(),
                name: "Sample File 2",
                encryptedData: Data(),
                dateAdded: Date()
            )
        ]
        return FileVaultView()
            .environmentObject(mockViewModel) // Inject the mock ViewModel
    }
}
#endif
