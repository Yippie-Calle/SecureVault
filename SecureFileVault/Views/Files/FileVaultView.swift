//
//  FileVaultView.swift
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//

import SwiftUI

// MARK: - FileVaultView

/// A view for managing and displaying secure files in a vault.
struct FileVaultView: View {
    // MARK: - State Variables

    /// The ViewModel to manage file state.
    @StateObject private var viewModel = FileVaultViewModel()

    /// Controls the display of sort options.
    @State private var showSortOptions = false

    /// Toggles between list and icon views.
    @State private var isListView = true

    /// Tracks the selected file for detail view.
    @State private var selectedFile: FileModel?

    /// Controls the display of the file detail view.
    @State private var showFileDetail = false

    /// Controls the display of the action sheet.
    @State private var showActionSheet = false

    /// Controls the display of the document scanner.
    @State private var showScanner = false

    /// Controls the display of the file picker.
    @State private var showFilePicker = false

    // MARK: - Body

    var body: some View {
        NavigationView {
            Group {
                if isListView {
                    listView // Displays files in a list view.
                } else {
                    iconView // Displays files in a grid view.
                }
            }
            .navigationTitle("Secure Files")
            .toolbar {
                // MARK: - Add File Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showActionSheet = true }) {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add File")
                }

                // MARK: - Sort Button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showSortOptions = true }) {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    .accessibilityLabel("Sort Files")
                }

                // MARK: - Toggle View Button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { isListView.toggle() }) {
                        Image(systemName: isListView ? "square.grid.2x2" : "list.bullet")
                    }
                    .accessibilityLabel("Toggle View")
                }
            }
            .confirmationDialog("Add File", isPresented: $showActionSheet, titleVisibility: .automatic) {
                Button("Upload File") {
                    showFilePicker = true
                }
                Button("Scan Document") {
                    showScanner = true
                }
                Button("Cancel", role: .cancel) { }
            }
            .sheet(isPresented: $showScanner) {
                DocumentScannerView { scannedImages in
                    handleScannedDocuments(scannedImages)
                }
            }
            .sheet(isPresented: $showFilePicker) {
                FilePickerView { urls in
                    handlePickedFiles(urls)
                }
            }
        }
    }

    // MARK: - List View

    /// Displays files in a list format.
    private var listView: some View {
        List {
            ForEach(viewModel.files) { file in
                HStack {
                    Text(file.name)
                    Spacer()
                    Text(file.dateAdded, style: .date)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedFile = file
                }
                .onLongPressGesture {
                    previewFile(file)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        viewModel.deleteFile(file)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
    }

    // MARK: - Icon View

    /// Displays files in a grid format.
    private var iconView: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                ForEach(viewModel.files) { file in
                    VStack {
                        Image(systemName: "doc.text")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text(file.name)
                            .font(.caption)
                            .lineLimit(1)
                    }
                    .onTapGesture {
                        selectedFile = file
                    }
                }
            }
        }
    }

    // MARK: - File Handling Methods

    /// Handles files selected from the file picker.
    private func handlePickedFiles(_ urls: [URL]) {
        for url in urls {
            do {
                let fileData = try Data(contentsOf: url)
                let encryptedData = try EncryptionService.encrypt(data: fileData, using: viewModel.encryptionKey)

                let newFile = FileModel(
                    id: UUID(),
                    name: url.lastPathComponent,
                    encryptedData: encryptedData,
                    dateAdded: Date()
                )
                viewModel.files.append(newFile)
            } catch {
                print("Error encrypting file from URL \(url): \(error.localizedDescription)")
            }
        }
    }

    /// Handles scanned documents.
    private func handleScannedDocuments(_ images: [UIImage]) {
        for (index, image) in images.enumerated() {
            do {
                if let imageData = image.jpegData(compressionQuality: 1.0) {
                    let encryptedData = try EncryptionService.encrypt(data: imageData, using: viewModel.encryptionKey)

                    let newFile = FileModel(
                        id: UUID(),
                        name: "Scanned Document \(index + 1)",
                        encryptedData: encryptedData,
                        dateAdded: Date()
                    )
                    viewModel.files.append(newFile)
                }
            } catch {
                print("Error encrypting scanned document \(index + 1): \(error.localizedDescription)")
            }
        }
    }

    /// Previews the selected file.
    private func previewFile(_ file: FileModel) {
        print("Previewing file: \(file.name)")
    }
}

// MARK: - Previews

#if DEBUG
struct FileVaultView_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = FileVaultViewModel()
        mockViewModel.files = [
            FileModel(id: UUID(), name: "Sample File 1", encryptedData: Data(), dateAdded: Date()),
            FileModel(id: UUID(), name: "Sample File 2", encryptedData: Data(), dateAdded: Date())
        ]
        return FileVaultView()
            .environmentObject(mockViewModel)
    }
}
#endif
