==================================================
               HABITER - HABIT TRACKER
==================================================

📝 ABOUT THE APP
-----------------
Habiter is a minimalist and efficient habit tracking application built using Flutter. 
It allows users to create, update, track, and visualize daily habits using a simple UI 
and features like a heatmap, habit lists, and completion tracking.

This app is optimized for performance, follows clean architecture, and uses Hive for 
local data storage. Users can track progress, edit or delete habits, and see visual 
history of their consistency.

📦 TECHNOLOGIES USED
---------------------
- Flutter (UI framework)
- Hive (lightweight local NoSQL database)
- Provider (state management)
- flutter_launcher_icons (custom app icon)
- flutter_native_splash (custom splash screen)
- Dart (programming language)

📁 PROJECT STRUCTURE
---------------------
- lib/
  ├── components/        - Reusable widgets (tiles, heatmap)
  ├── database/          - Hive database setup & logic
  ├── dialogs/           - Custom alert dialogs (edit, delete, create)
  ├── models/            - Habit model
  ├── theme/             - Theme settings and provider
  ├── utils/             - Helper methods (date formatting, heatmap logic)
  ├── main.dart          - App entry point

📌 FEATURES
------------
- Add, edit, delete habits
- Mark habit as completed for the day
- Visualize habit consistency via a heatmap
- Responsive and clean UI
- Light/dark theme toggle
- Custom splash screen and app icon
- Local data storage with Hive (no internet needed)

🔐 PERMISSIONS
---------------
No runtime permissions required, as Hive handles local storage.

🚀 APP CONFIGURATION
---------------------
1. ✅ **App Name**: Defined in `AndroidManifest.xml` and `Info.plist`
2. ✅ **App Icon**: Set using `flutter_launcher_icons`
3. ✅ **Splash Screen**: Configured using `flutter_native_splash`
4. ✅ **Package Name**: Changed from `com.example.habiter` to your custom ID
5. ✅ **App Versioning**:
    - `version: 1.0.0+1` in `pubspec.yaml`

🔑 ANDROID KEYSTORE (for Play Store Release)
--------------------------------------------
If you're building an Android release (AAB/APK):

1. Generate Keystore:
