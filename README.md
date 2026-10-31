# KMS Merino (Kaizen Management System)

A comprehensive cross-platform mobile application developed with **Flutter** for enterprise safety reporting, continuous workplace improvement (Kaizen), and operational excellence.

---

## 🌟 Key Features

- **Multi-Role Role-Based Access Control (RBAC)**: Tailored dashboards and workflows for **Admin**, **HR**, **Manager**, **Director**, and **Employees / Users**.
- **Kaizen Management**: End-to-end lifecycle tracking for Kaizen ideas — from submission, review, approval, implementation, to final verification.
- **Safety Incident Management**:
  - Accident Reporting & Root-cause tracking
  - Nearmiss Incident reporting
  - Safety Observations with photo/video attachments and video compression
- **Ethics & Complaints Reporting**: Secure grievance reporting with role-segregated management.
- **Push Notifications & Announcements**: Firebase Cloud Messaging (FCM) integration with foreground notifications, rich big-picture broadcast messages, and automated deep-linking directly to incident and Kaizen detail pages.
- **Broadcast System**: Company-wide and department-specific announcements with media attachments.

---

## 📱 Technology Stack

- **Framework**: [Flutter](https://flutter.dev/) (Dart SDK)
- **State Management & Routing**: [GetX](https://pub.dev/packages/get)
- **Push Notifications**:
  - [firebase_messaging](https://pub.dev/packages/firebase_messaging)
  - [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- **Networking**: [http](https://pub.dev/packages/http), [dio](https://pub.dev/packages/dio)
- **Media & Storage**: [image_picker](https://pub.dev/packages/image_picker), [video_compress](https://pub.dev/packages/video_compress), [cached_network_image](https://pub.dev/packages/cached_network_image), [shared_preferences](https://pub.dev/packages/shared_preferences)

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (v3.x or higher)
- Android SDK (API 21+) / Xcode for iOS
- Java Development Kit (JDK 17)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Durgeshbagul29/kms-merino-sample.git
   cd kms-merino-sample
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

---

## 🏢 Architecture & Security

- **Base URL Centralization**: Unified in `lib/services/api/api_config.dart`.
- **Token-Based Authentication**: Secure Bearer token storage in SharedPreferences with automated session headers via `ApiClient`.
- **Dynamic Routing**: Push notification taps auto-resolve user roles and navigate directly to the appropriate screen.

---

## 📄 License

This repository is maintained for internal enterprise operations and authorized personnel.
