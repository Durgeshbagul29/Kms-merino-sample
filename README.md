# KMS Merino (Kaizen Management System)

A comprehensive enterprise mobile application built with **Flutter** designed for continuous workplace improvement (Kaizen), multi-tier incident reporting, occupational safety management, and grievance handling.

---

## 📑 Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
  - [Kaizen Continuous Improvement](#1-kaizen-continuous-improvement)
  - [Safety Incident Management](#2-safety-incident-management)
  - [Ethics & Grievance Reporting](#3-ethics--grievance-reporting)
  - [Company Broadcasts & Announcements](#4-company-broadcasts--announcements)
  - [Push Notifications & Smart Deep-Linking](#5-push-notifications--smart-deep-linking)
- [Role-Based Access Control (RBAC)](#-role-based-access-control-rbac)
- [Technology Stack](#-technology-stack)
- [Architecture & Networking](#-architecture--networking)
  - [API Configuration (`ApiConfig`)](#api-configuration-apiconfig)
  - [Centralized API Client (`ApiClient`)](#centralized-api-client-apiclient)
  - [API Endpoints Overview](#api-endpoints-overview)
- [Project Directory Layout](#-project-directory-layout)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Setup & Installation](#setup--installation)
  - [Running the App](#running-the-app)
  - [Building for Production](#building-for-production)
- [Native Permissions](#-native-permissions)
- [Security & Best Practices](#-security--best-practices)
- [License](#-license)

---

## 🌟 Overview

**KMS Merino** streamlines company-wide operational excellence by providing a unified platform where workers can propose Kaizens, log near-misses and safety observations, report accidents, and register confidential ethical complaints. Tailored dashboards for **Admins**, **Managers**, **Directors**, and **HR** enable real-time workflow approvals, root-cause analyses, report exports, and team analytics.

---

## 🚀 Key Features

### 1. Kaizen Continuous Improvement
- **Idea Submission**: Submit workplace enhancement proposals with titles, problem descriptions, proposed solutions, expected benefits, and cost estimations.
- **Rich Media Evidence**: Upload "before" and "after" photos and compressed videos documenting the workplace before and after implementation.
- **Workflow Lifecycle**: Track statuses across *Submitted*, *Under Review*, *Approved*, *Implemented*, and *Rejected*.
- **PDF Exporting**: Download branded PDF summaries for individual Kaizens for physical plant postings and audit compliance.

### 2. Safety Incident Management
- **Accident Reporting**: Detailed incident reports with time, exact plant/site location, injury type, root cause assessment, and attached documentation.
- **Near-Miss Logging**: Report potential hazards and close calls before they manifest into injuries.
- **Safety Observations**: Proactively highlight unsafe conditions or commendable safety practices with photo/video attachments and video compression.
- **Excel & Archive Exports**: Generate and download Excel reports for audits and safety KPIs.

### 3. Ethics & Grievance Reporting
- **Confidential Grievance Portal**: Secure channel for employees to submit workplace complaints, whistleblower disclosures, and ethical concerns.
- **Role-Restricted Review**: Complaints are reviewed under strict confidentiality workflows by authorized personnel.

### 4. Company Broadcasts & Announcements
- **Rich Broadcast Messages**: Company-wide and department-specific announcements with image banners and rich text.
- **Read Receipts**: Track view and read metrics for critical safety memos.

### 5. Push Notifications & Smart Deep-Linking
- **Firebase Cloud Messaging (FCM)**: Real-time foreground and background push alerts.
- **Role-Aware Deep Linking**: Tapping on push notifications automatically determines user credentials and opens the corresponding detail screen (Kaizen, Accident, Nearmiss, Observation, or Broadcast).

---

## 👥 Role-Based Access Control (RBAC)

| Role | Core Capabilities |
| :--- | :--- |
| **Employee / User** | Submit Kaizens, log accidents/near-misses/observations, submit grievances, view personal notifications and company broadcasts. |
| **Manager** | Departmental dashboard, review and approve Kaizens, inspect safety observations, review complaints, generate team reports and Excel exports. |
| **Director** | Executive level visibility across all plants/departments, high-level KPI reports, review escalated complaints, inspect safety trends. |
| **Admin** | Full system oversight, review/edit/archive incidents, manage broadcast distributions, export global analytics. |
| **HR** | User & administrator account provisioning, department creation, role assignment, password management. |

---

## 📱 Technology Stack

- **Core Framework**: [Flutter](https://flutter.dev/) (Dart SDK 3.x)
- **State Management & Navigation**: [GetX](https://pub.dev/packages/get)
- **Networking**: [http](https://pub.dev/packages/http), [dio](https://pub.dev/packages/dio)
- **Cloud Messaging & Push Notifications**:
  - [firebase_core](https://pub.dev/packages/firebase_core)
  - [firebase_messaging](https://pub.dev/packages/firebase_messaging)
  - [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- **Media & Storage**:
  - [image_picker](https://pub.dev/packages/image_picker)
  - [video_compress](https://pub.dev/packages/video_compress)
  - [cached_network_image](https://pub.dev/packages/cached_network_image)
  - [shared_preferences](https://pub.dev/packages/shared_preferences)
  - [open_file](https://pub.dev/packages/open_file) & [path_provider](https://pub.dev/packages/path_provider)

---

## 🌐 Architecture & Networking

### API Configuration (`ApiConfig`)
All backend routes and service URLs are centralized in [`lib/services/api/api_config.dart`](file:///d:/Durgesh/Flutter_Projects/KMSMerino/lib/services/api/api_config.dart).

```dart
// Change base URL in one single location:
static const String baseUrl = 'https://kmsmerino.abraca-dabra.com';

// Access endpoint paths or full URLs:
String loginUrl = ApiConfig.loginUrl;
String userKaizensUrl = ApiConfig.viewUserKaizensUrl('pending');
String adminKaizenReport = ApiConfig.adminKaizenReportUrl;
```

### Centralized API Client (`ApiClient`)
Located in [`lib/services/api/api_client.dart`](file:///d:/Durgesh/Flutter_Projects/KMSMerino/lib/services/api/api_client.dart), `ApiClient` wraps standard HTTP methods (`GET`, `POST`, `PUT`, `DELETE`, and multipart uploads):
- Automated `Bearer <token>` authentication header injection.
- Centralized timeout handling and offline state detection.
- Structured response mapping (`GetX` `Response`).

### API Endpoints Overview

The endpoints configured in `ApiConfig` are organized into modular groups:

1. **Authentication & Profile**
   - `loginEndpoint` (`/api/login`)
   - `logoutEndpoint` (`/api/logout`)
   - `registerDeviceTokenEndpoint` (`/api/register_device_token`)
   - `getProfileEndpoint` (`/api/get_profile`)
   - `changePasswordEndpoint` (`/api/change_password`)

2. **User Services**
   - **Dashboard**: `/api/user_dashboard`
   - **Kaizens**: `/api/add_kaizen_record`, `/api/view_user_approvedkaizens`, `/api/view_user_submittedkaizens`, `/api/view_user_kaizens/{type}`, `/api/view_user_kaizens_details/{id}`, `/api/update_approved_kaizen`, `/api/update_pending_kaizen`, `/api/delete_user_kaizen`, `/api/download_kaizen_pdf/{id}`
   - **Accidents**: `/api/add_accident_record`, `/api/view_user_accidents`, `/api/view_user_accident_details/{id}`, `/api/download_accident_file`
   - **Near-Misses**: `/api/add_nearmiss_record`, `/api/view_user_nearmiss`, `/api/view_user_nearmiss_details/{id}`, `/api/download_nearmiss_file`
   - **Observations**: `/api/add_observation_record`, `/api/view_user_observation`, `/api/view_user_obs_details/{id}`
   - **Ethics**: `/api/add_user_complaint`, `/api/view_user_complaints`
   - **Broadcasts & Notifications**: `/api/view_user_broadcast`, `/api/view_user_notifications`, `/api/delete_user_notf`, `/api/seen_user_broadcast_notf/{userId}/{id}`, `/api/review_user_section_notf/{userId}/{id}`, `/api/view_user_section_notf/{userId}/{id}`

3. **Admin Services**
   - Dashboard & Team: `/api/admin_dashboard`, `/api/admin_my_team`
   - Kaizens: `/api/view_admin_allkaizens`, `/api/view_admin_kaizentype/{type}`, `/api/view_admin_kaizen_details/{id}`, `/api/admin_kaizen_kpi`, `/api/admin_kaizen_report`, `/api/admin_kaizen_excel`, `/api/admin_downloadurl_kaizenexcel`, `/api/kaizen_archive_files`, `/api/view_admin_kaizen_notf`, `/api/review_admin_kaizen_notf/{adminId}/{dataId}`
   - Accidents: `/api/view_admin_accident`, `/api/view_admin_accident_details/{id}`, `/api/admin_accident_report`, `/api/admin_accident_excel`, `/api/admin_downloadurl_accidentexcel`, `/api/accident_archive_files`
   - Nearmiss & Observations: `/api/view_admin_nearmiss`, `/api/admin_nearmiss_report`, `/api/view_admin_observation`, `/api/admin_obs_report`, Excel & archive download endpoints
   - Ethics: `/api/view_admin_ethics`, `/api/review_admin_complaint/{adminId}/{dataId}`, `/api/admin_ethics_table`, `/api/admin_ethics_excel`, `/api/ethics_archive_files`
   - Broadcasts: `/api/view_admin_broadcast`, `/api/view_admin_broadcast_details/{id}`, `/api/add_broadcast`, `/api/delete_admin_broadcast`

4. **Manager Services**
   - Matching dashboard, team view, Kaizen review/KPI, accident/near-miss/observation workflows, complaint handling, and broadcast management prefix-routed via `/api/manager_*` and `/api/view_manager_*`.

5. **Director Services**
   - Executive dashboards, organization-wide incident tables, KPI aggregations, and complaint reviews routed via `/api/director_*` and `/api/view_director_*`.

6. **HR & User Administration**
   - `/api/hr_dashboard`
   - Account listing: `/api/get_all_admins`, `/api/get_all_users`, `/api/get_all_managers`, `/api/get_all_directors`
   - Department management: `/api/get_depts`, `/api/get_all_departments`, `/api/assign_manager_departments`, `/api/get_manager_departments`
   - Account creation: `/api/add_new_useroradmin`, `/api/update_useroradmin`, `/api/add_director`

7. **Shared Status Updates**
   - `/api/update_admin_accident`
   - `/api/update_admin_kaizen`
   - `/api/update_admin_nearmiss`
   - `/api/update_admin_observation`

---

## 📂 Project Directory Layout

```
lib/
├── controller/         # GetX controllers (Auth, state, session management)
├── helper/             # Dependency injection, PDF download helpers, dialog utilities
├── models/             # Data models (Kaizen, Accident, Nearmiss, Observation, Complaints, User)
├── services/
│   ├── api/
│   │   ├── api_client.dart     # HTTP client wrapper with auth headers & error handling
│   │   └── api_config.dart     # Centralized base URL and endpoint configurations
│   ├── network_manager.dart    # Network connectivity listener
│   └── notification_service.dart# FCM configuration, channels & deep-link routing
├── utils/              # App themes, constants, asset paths, typography
└── views/
    ├── common/         # Shared incident/Kaizen detail views and profile screens
    └── screens/
        ├── admin/      # Admin dashboard, approval flows, archive & report screens
        ├── director/   # Director overview, KPI boards, reviews
        ├── hr/         # HR dashboard, user/admin registration, department mapping
        ├── manager/    # Manager workflows, departmental Kaizens & safety logs
        └── user/       # Employee dashboards, Kaizen submission, safety reporting
```

---

## 🛠️ Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.10 or higher recommended)
- [Android Studio](https://developer.android.com/studio) / VS Code with Flutter & Dart extensions
- Android SDK (API 21+) and JDK 17
- Xcode 14+ (if targeting iOS / macOS)

### Setup & Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Durgeshbagul29/kms-merino-sample.git
   cd kms-merino-sample
   ```

2. **Install Flutter packages:**
   ```bash
   flutter pub get
   ```

3. **Verify environment readiness:**
   ```bash
   flutter doctor
   ```

### Running the App

- **Run on a connected Android device / emulator:**
  ```bash
  flutter run
  ```

- **Run in release mode:**
  ```bash
  flutter run --release
  ```

### Building for Production

- **Android APK:**
  ```bash
  flutter build apk --release
  ```

- **Android App Bundle (for Google Play):**
  ```bash
  flutter build appbundle --release
  ```

- **iOS Archive (macOS only):**
  ```bash
  flutter build ipa --release
  ```

---

## 🔒 Native Permissions

The application requires the following permissions for media attachments, camera reporting, and push notifications:

### Android (`android/app/src/main/AndroidManifest.xml`)
- `android.permission.CAMERA`: Capture photos/videos of incidents and Kaizens.
- `android.permission.READ_EXTERNAL_STORAGE` / `READ_MEDIA_IMAGES` / `READ_MEDIA_VIDEO`: Pick gallery media.
- `android.permission.WRITE_EXTERNAL_STORAGE`: Download and export PDFs and Excel reports.
- `android.permission.INTERNET`: Backend API connectivity.
- `android.permission.POST_NOTIFICATIONS`: Receive real-time push announcements on Android 13+.

### iOS (`ios/Runner/Info.plist`)
- `NSCameraUsageDescription`: Access camera to capture Kaizen and incident photos/videos.
- `NSPhotoLibraryUsageDescription`: Access photo library to attach evidence.
- `NSMicrophoneUsageDescription`: Record video audio during safety observation capture.

---

## 🔐 Security & Best Practices

- **Bearer Token Auth**: Tokens stored securely in SharedPreferences and passed in `Authorization` headers.
- **Centralized Endpoint Registry**: Eliminates hardcoded URLs spread across UI widgets.
- **Video Compression**: Compresses uploaded videos before transfer to minimize bandwidth consumption.
- **Role Isolation**: Prevents unauthorized privilege escalation through backend validation paired with client-side role guards.

---

## 📄 License

This repository is maintained for internal enterprise operations and authorized personnel. All rights reserved.
