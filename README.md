# Encriptify

An **iOS application for encrypted messaging using Shamir’s Secret Sharing**.  
Rather than trusting a single IM provider with your privacy, Encriptify splits each message into multiple “shares” that you send over different platforms. Only when enough shares are collected can the original message be reconstructed.

---

## Features

- **Local Profiles**: Create your own profile and add contacts, each with a name and avatar.  
- **Send Messages**: Type and “send” plaintext messages locally; they’re stored in an encrypted Core Data database.  
- **Generate & Distribute Shares**: On tap of any sent message, Encriptify splits it into _N_ shares (threshold _T_≤_N_) using Shamir’s Secret Sharing (via [SwiftySSS](https://github.com/echoprotocol/SwiftySSS)). Each share is encoded as a custom `encriptify://…` URL and shared via iOS’s share sheet.  
- **Receive & Reassemble**: Tap any share-URL on your device; assign it to a contact, and once you’ve collected ≥_T_ shares, the app automatically reconstructs and displays the original message.  
- **Offline**: No Internet connection or external servers - everything happens on-device.  
- **Data Protection**: Messages and profiles are persisted in Core Data; no plaintext or share data is ever sent to a server.

---

## User Interface
### Generating and Distributing Shares
<img width="814" height="613" alt="SCR-20250803-rpxi" src="https://github.com/user-attachments/assets/ad3e6f4e-5fc2-4bcc-b498-f0073b9860e4" />

### Aggregating and Decrypting Shares
<img width="821" height="618" alt="SCR-20250803-rpyu" src="https://github.com/user-attachments/assets/5002f1f4-5b3b-4149-8d37-fa41359858a5" />

---

## Requirements

- iOS 14.0 or later  
- Xcode 12+  
- Swift 5, SwiftUI framework  

---

## Installation

1. **Clone** this repository
2. **Open** `Encriptify.xcodeproj` in Xcode.
3. **Build & Run** on your simulator or device.

---

## Project Structure

```
Encriptify/
├─ Encriptify.xcodeproj
├─ README.md
├─ Report/                        ← Full project report  
│  └─ encriptify_report.pdf
├─ Sources/
│  ├─ Models/                     ← Core Data stack & data models  
│  ├─ ViewModels/                 ← MVVM “Intent” logic  
│  ├─ Views/                      ← SwiftUI screens (ChatView, MessageShareView, etc.)  
│  └─ Utilities/
│     └─ SecretSharing/           ← SwiftySSS integration  
└─ Resources/                     ← Assets, Info.plist (URL scheme)  
```

---

## URL Scheme

* **Scheme**: `encriptify://share?text=<SHARE>&date=<ISO8601_TIMESTAMP>`
* Registered under **Info.plist** so iOS routes taps on share-URLs to the app.

---

## Configuration

* Default number of shares (*N*) and threshold (*T*) are defined in `Constants.swift`.
* **Future**: these will become user-configurable in Settings (currently hard-coded).

---

## Testing

* **Exploratory & Manual**: All functional requirements (1.1-1.8) have been verified on simulators and devices.
* **Performance**: Average launch time ≈ 0.93 s; UI actions < 3 s.
* **Scalability**: Handles 5 conversations and 100 messages without issue.
* **Security**: Encrypted local storage; secret-sharing is information-theoretic secure.

---

## Acknowledgements

* **Supervisors**: Dr. Mark Manulis & Dr. Daniel Gardham
* **University of Surrey**, Department of Computer Science

---

## License

This project is released under the **MIT License** (see `LICENSE`), and uses third-party [SwiftySSS (MIT)](https://github.com/echoprotocol/SwiftySSS).

---

## Full Report

See [`encriptify_report.pdf`](Report/encriptify_report.pdf) for detailed methodology, design decisions, testing results, and future work.
