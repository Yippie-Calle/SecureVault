//
//  README.md
//  SecureVault
//
//  Created by Bryan Calle on 4/15/25.
//

# 🔐 SecureVaultApp

A SwiftUI-based iOS application that allows users to securely store encrypted **files** and **notes** locally and (optionally) in the cloud via **Azure Blob Storage**. Designed for learning app security fundamentals, Swift programming, and real-world encryption workflows.

---

## 🚀 Features

### ✅ Core Functionality
- 📁 **Secure File Vault**: Import and encrypt files using AES-GCM (e.g., PDFs, images)
- 📝 **Secure Notes Vault**: Create and encrypt text notes within the app
- 🔑 **Key Management**: Secure key storage via iOS Keychain
- ☁️ **Azure Integration (In Progress)**: Upload/download encrypted files to Azure Blob Storage
- 🔓 **Authentication**: Basic login and account creation functionality implemented

### 🛡 Security
- AES-GCM encryption using `CryptoKit`
- Local key protection via `Keychain`
- Planned: Face ID / Touch ID authentication
- Planned: Passcode and session timeout support

### 🧩 Modular Design
- Clean architecture with separate models, view models, and services
- Easy to extend and integrate into larger apps (e.g., productivity or ministry apps)

---

## 🛠 Tech Stack

| Layer        | Tools Used                        |
|--------------|-----------------------------------|
| Language     | Swift 5, SwiftUI                  |
| Encryption   | CryptoKit (AES-GCM)               |
| Cloud        | Azure Blob Storage (REST/SDK)     |
| Security     | Keychain, Face ID (planned)       |
| UI/UX        | SwiftUI, TabView, NavigationStack |

---

## 📦 Project Structure


```├── Models/ ├── Views/ ├── ViewModels/ ├── Services/ ├── Resources/ └── SecureVaultApp.swift

___


## 📸 Screenshots (Coming Soon)

Add demo images/gifs once features are complete.

---

## 🧠 Future Roadmap

- [x] Enable biometric authentication (Face ID / Touch ID)
- [ ] Add passcode lock and auto-timeout
- [ ] Enable full Azure Blob Storage integration
- [ ] Add search and sort features to vaults
- [ ] Implement document scanner for note/image input
- [ ] Export/import encrypted files
- [ ] Merge features into a larger ministry productivity app

---

## 👨‍💻 Author

**Bryan Calle**  
Cloud & Security Enthusiast | Swift Developer | [Your LinkedIn or GitHub]

---

## 🛡 Disclaimer

This project is built for educational and prototyping purposes. Not intended for storing actual sensitive or legally protected information without further security review.
