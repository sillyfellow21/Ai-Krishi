# Krishibondhu (কৃষিবন্ধু) — Offline Farming Companion

Krishibondhu is a 100% offline-first Flutter application designed to be a reliable companion for farmers. It allows users to manage their lands and crops without needing an internet connection, storing all data securely on the device.

## Table of Contents

- [Core Features](#core-features)
- [Technical Architecture](#technical-architecture)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Dependencies](#dependencies)

---

## Core Features

### 1. Flexible Authentication
- **Register with Email or Phone**: Users can sign up using their email and an optional phone number.
- **Login with Email or Phone**: Login is supported using either the registered email or phone number.
- **Secure & Offline**: All user credentials are saved securely on the device for 100% offline access.

### 2. Land Management
- **Manage Lands**: Add, edit, and delete land details.
- **Flexible Area Units**: Input land area in **Acres, Bighas, or Hectares**. The app handles all conversions automatically, storing data in a consistent format.

### 3. Advanced Crop Management
- **Crop Tracking**: Monitor the entire lifecycle of a crop from "Planting" to "Growing" to "Harvested".
- **Detailed Crop Logs**: Keep a running record of all activities for a specific crop. Log activities like **Watering, Fertilizing, Pest Control, and Weeding**, and add custom notes for each entry.
- **Harvest Details**: Mark a crop as harvested and record the harvest date.

### 4. Profile Management
- **View & Edit Profile**: Users can view and update their name, phone number, and address.

---

## Technical Architecture

This application is built following Clean Architecture principles to ensure it is scalable, testable, and maintainable.

### State Management: Provider
- We use the `provider` package for state management, leveraging `ChangeNotifier` for mutable state.
- **`AuthProvider`**: Manages authentication state.
- **`UserProfileProvider`**: Handles fetching and updating user profile data.
- **`LandProvider`**: Manages CRUD operations for lands.
- **`CropProvider`**: Manages CRUD for both crops and their associated activity logs.

### Database: SQLite
- The application is **100% offline-first** and uses `sqflite` as its sole database.
- A singleton `DatabaseHelper` class (`lib/core/database/database_helper.dart`) manages all database connections and schema migrations.
- **Cascading Deletes**: The database is structured with foreign keys to ensure data integrity. When you delete a user, all their lands and crops are removed. When you delete a land, all its crops are removed. When you delete a crop, all its logs are removed.

---

## Project Structure

```
lib/
 ├── core/                    
 │    ├── database/            
 │    ├── utils/               
 │    └── widgets/             
 ├── features/                
 │    ├── auth/                
 │    ├── crop/                
 │    ├── land/                
 │    ├── profile/             
 │    ├── home_screen.dart     
 │    └── splash_screen.dart   
 ├── models/                  
 │    ├── user_model.dart
 │    ├── land_model.dart
 │    ├── crop_model.dart
 │    └── crop_log_model.dart
 ├── providers/               
 │    ├── auth_provider.dart
 │    ├── user_profile_provider.dart
 │    ├── land_provider.dart
 │    └── crop_provider.dart
 └── main.dart                

pubspec.yaml                  
```

---

## Getting Started

1.  **Clone the repository**:
    ```sh
    git clone https://github.com/sillyfellow21/Ai-Krishi.git
    cd Ai-Krishi
    ```

2.  **Get dependencies**:
    ```sh
    flutter pub get
    ```

3.  **Run the app**:
    **IMPORTANT**: If you have run a previous version, you **MUST UNINSTALL** the app from your device before running it again due to database upgrades.
    ```sh
    flutter run
    ```

---

## Dependencies

- `flutter`
- `provider`
- `sqflite`
- `path_provider`
- `shared_preferences`
- `uuid`
- `crypto`
- `intl`
