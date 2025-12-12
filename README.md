# 💬 Flutter Chat App

A real-time chat application built using **Flutter** and powered by multiple Firebase services including Authentication, Firestore, Storage, and Cloud Messaging. This app supports secure email/password authentication, real-time messaging between users, profile image upload, and both push + local notifications. State management is handled using **Riverpod**, ensuring clean code and smooth performance.

---

## ✨ Features

### 🔐 Firebase Authentication
- Email/password signup and login
- Email pattern recognition for validation
- Secure account creation & login flow
- Error handling for invalid credentials

### 💬 Real-Time Messaging
- One-to-one messaging similar to modern chat apps
- Messages instantly synced across devices using Cloud Firestore
- Timestamped messages with sender/receiver metadata
- Chat bubbles UI for seamless conversation experience

### 📸 Media Support
- Profile image upload using Firebase Storage
- Images stored securely & fetched efficiently

### 🔔 Notifications
- **Push notifications** using Firebase Cloud Messaging (FCM)
- **Local notifications** triggered when another user sends a message
- Notifications work even when app is in background (if FCM is enabled)
- Custom notification handling on iOS & Android

### 🧩 State Management with Riverpod
- Clean architecture
- Efficient state updates
- Maintainable and testable codebase

---

## 🛠️ Tech Stack

- **Flutter** (Dart)
- **Riverpod**
- **Firebase Authentication**
- **Cloud Firestore**
- **Firebase Storage**
- **Firebase Cloud Messaging (FCM)**
- **flutter_local_notifications**
- Responsive UI design

---


A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
