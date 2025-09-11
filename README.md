# InspireMe – Daily Motivation App

InspireMe is a clean, modular Flutter app that serves random motivational quotes with animation, theming, favorites, sharing, and optional sound.

## Features

- Random quotes from ZenQuotes API with local fallback (20+ quotes)
- Day/Night theme switcher with persistence
- Favorites with local persistence (SharedPreferences)
- Share quotes (share_plus)
- Subtle animations on quote change (flutter_animate)
- Optional chime sound on "Inspire Me" (audioplayers)
- Hero animation between Home and Favorites
- Provider-based state management
- Clean folder structure

## Folder Structure

```
lib/
  main.dart
  src/
    app.dart
    router/
      app_router.dart
    theme/
      app_theme.dart
    models/
      quote.dart
    services/
      quote_api_service.dart
      local_quotes_service.dart
    repositories/
      quotes_repository.dart
    providers/
      theme_provider.dart
      quotes_provider.dart
      favorites_provider.dart
    ui/
      screens/
        home_screen.dart
        favorites_screen.dart
      widgets/
        quote_card.dart
        inspire_button.dart
```

## Getting Started

1) Install dependencies
```
flutter pub get
```

2) (Optional) Add a chime sound at `assets/sounds/chime.mp3` or remove the play call in `home_screen.dart`.

3) Run
```
flutter run
```

## Configuration

- Assets are declared in `pubspec.yaml` under `assets/`.
- Theme preference is persisted via `SharedPreferences`.
- ZenQuotes endpoints used:
  - `https://zenquotes.io/api/random`
  - `https://zenquotes.io/api/quotes`

## 🔥 Firebase Integration (Cloud Version)

The app now includes full Firebase integration with the following services:

### ✅ Implemented Firebase Features

- **Firebase Authentication**: Email/password sign up and sign in
- **Cloud Firestore**: Store and sync quotes and user favorites across devices
- **Firebase Analytics**: Track user interactions and app usage
- **Firebase Crashlytics**: Monitor app crashes and errors

### 🚀 Firebase Setup

1. **Create Firebase Project**:
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project named "inspireme-flutter"

2. **Add Android App**:
   - Package name: `com.example.inspireme`
   - Download `google-services.json` and place in `android/app/`

3. **Enable Services**:
   - **Firestore Database**: Create database in test mode
   - **Authentication**: Enable Email/Password provider
   - **Analytics**: Already enabled by default
   - **Crashlytics**: Optional, for crash monitoring

4. **Update Android Configuration**:
   ```gradle
   // android/build.gradle
   buildscript {
       dependencies {
           classpath 'com.google.gms:google-services:4.4.0'
           classpath 'com.google.firebase:firebase-crashlytics-gradle:2.9.9'
       }
   }
   
   // android/app/build.gradle
   apply plugin: 'com.google.gms.google-services'
   apply plugin: 'com.google.firebase.crashlytics'
   ```

5. **Run the App**:
   ```bash
   flutter pub get
   flutter run
   ```

### 📊 Analytics Events Tracked

- `quote_generated`: When user taps "Inspire Me"
- `quote_shared`: When user shares a quote
- `theme_changed`: When user changes theme
- `user_signed_in`: When user logs in
- `user_signed_out`: When user logs out
- `favorite_saved_to_cloud`: When favorite is saved to Firestore
- `favorite_removed_from_cloud`: When favorite is removed from Firestore

### 🔐 Firestore Collections

- **quotes**: Global quotes collection
- **users/{userId}/favorites**: User-specific favorites

### 🛡️ Security Rules (Development)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /quotes/{document} {
      allow read, write: if true;
    }
    match /users/{userId}/favorites/{document} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

For detailed setup instructions, see [FIREBASE_SETUP.md](FIREBASE_SETUP.md)

## Notes

- If API calls fail, the app gracefully falls back to the local quotes list.
- If the sound file is missing, the app continues without audio.


