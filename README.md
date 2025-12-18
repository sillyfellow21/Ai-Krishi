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

### 1. Offline Authentication
- **User Registration**: New users can create an account with their name, email, and password. Emails are unique.
- **Secure Login**: Users can log in using their email and password. Passwords are not stored in plain text.
- **Session Persistence**: The app remembers logged-in users. Users are automatically logged in until they explicitly log out.

### 2. Land Management
- **Add & Edit Lands**: Users can add, edit, and delete their land details, including land name, area (in acres), and location.
- **List Lands**: All lands associated with the logged-in user are displayed in a clean list on the "My Lands" screen.

### 3. Crop Management
- **Add & Delete Crops**: For each plot of land, users can add detailed records of the crops they have planted, including crop name, variety, and planting date.
- **List Crops**: View all crops planted on a specific piece of land.

### 4. Profile Management
- **View & Edit Profile**: Users can view their profile information and edit their name, phone number, and address.
- **Logout**: A secure logout option is provided to clear the user's session.

---

## Technical Architecture

This application is built following Clean Architecture principles to ensure it is scalable, testable, and maintainable.

### State Management: Provider
- We use the `provider` package for state management, leveraging `ChangeNotifier` for mutable state.
- **`AuthProvider`**: Manages authentication state (`login`, `register`, `logout`, `currentUser`).
- **`UserProfileProvider`**: Handles fetching and updating user profile data.
- **`LandProvider`**: Manages CRUD operations for lands, scoped to the current user.
- **`CropProvider`**: Manages CRUD for crops, scoped to a specific land.
- `ChangeNotifierProxyProvider` is used to create dependencies between providers (e.g., `LandProvider` depends on `AuthProvider` to get the `userId`).

### Database: SQLite
- The application is **100% offline-first** and uses `sqflite` as its sole database.
- A singleton `DatabaseHelper` class (`lib/core/database/database_helper.dart`) manages all database connections and operations.
- The database file is named `krishibondhu.db`.
- **Tables**:
  - `users`: Stores user credentials and profile information.
  - `lands`: Stores land details, linked to a user via `userId`.
  - `crops`: Stores crop details, linked to a land via `landId`.

### Security
- **Password Hashing**: User passwords are not stored directly. Instead, they are hashed using the `sha256` algorithm from the `crypto` package before being stored in the database.

### Session Management
- **`shared_preferences`** is used to persist the current user's session. On app start, it checks for a stored `userId` to determine whether to show the `HomeScreen` or `AuthScreen`.

---

## Project Structure

The project follows a feature-first folder structure, which keeps related code organized together.

```
lib/
 ├── core/                    # Core utilities, widgets, and services
 │    ├── database/            # DatabaseHelper for SQLite
 │    ├── utils/               # Utility classes (e.g., PasswordHelper)
 │    └── widgets/             # Reusable widgets (e.g., CustomTextField)
 │
 ├── features/                # Contains all the app's features/screens
 │    ├── auth/                # AuthScreen (Login/Register)
 │    ├── crop/                # AddCropScreen
 │    ├── land/                # MyLandsScreen, LandDetailScreen, AddEditLandScreen
 │    ├── profile/             # ProfileScreen, EditProfileScreen
 │    ├── home_screen.dart     # Main screen with BottomNavigationBar
 │    └── splash_screen.dart   # Initial screen for session checking
 │
 ├── models/                  # Data models (User, Land, Crop)
 │    ├── user_model.dart
 │    ├── land_model.dart
 │    └── crop_model.dart
 │
 ├── providers/               # All state management ChangeNotifiers
 │    ├── auth_provider.dart
 │    ├── user_profile_provider.dart
 │    ├── land_provider.dart
 │    └── crop_provider.dart
 │
 └── main.dart                # App entry point, MaterialApp, and Provider setup

pubspec.yaml                  # Project dependencies and configuration
```

---

## Getting Started

To run this project locally:

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
    ```sh
    flutter run
    ```

---

## Dependencies

### Core
- `flutter`
- `provider`
- `sqflite`
- `path_provider`
- `shared_preferences`

### Utilities
- `uuid`
- `crypto`
- `intl`
- `cupertino_icons`
