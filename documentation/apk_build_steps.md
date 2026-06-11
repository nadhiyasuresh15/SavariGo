# 📱 SavariGo Flutter — APK Build Steps

## Prerequisites
Make sure these are installed before starting:
- Flutter SDK (3.0 or higher) → https://flutter.dev/docs/get-started/install
- Android Studio (with Android SDK)
- Java JDK 11 or higher
- VS Code with Flutter extension
- USB cable (to connect Android phone)

---

## Step 1: Open the Project in VS Code

```bash
# Open VS Code and navigate to the project folder
cd SavariGo_Flutter

# Or open VS Code from terminal
code .
```

---

## Step 2: Run Flutter Doctor

Always check Flutter setup first:

```bash
flutter doctor
```

You should see all green checkmarks:
```
✅ Flutter (Channel stable, 3.x.x)
✅ Android toolchain
✅ VS Code
✅ Connected device
```

If you see issues, fix them before proceeding.

---

## Step 3: Install Dependencies

```bash
flutter pub get
```

This downloads all packages listed in `pubspec.yaml`:
- supabase_flutter
- google_fonts
- shared_preferences
- intl

---

## Step 4: Connect Android Phone

1. On your Android phone, go to **Settings → About Phone**
2. Tap **Build Number** 7 times to enable Developer Options
3. Go to **Settings → Developer Options**
4. Enable **USB Debugging**
5. Connect phone via USB cable
6. Accept the "Allow USB Debugging" popup on your phone

Verify connection:
```bash
flutter devices
```

You should see your phone listed.

---

## Step 5: Run the App (Debug Mode)

```bash
flutter run
```

The app will be installed and launched on your phone automatically.

> **For Android Emulator:** Open Android Studio → AVD Manager → Start an emulator, then run `flutter run`

---

## Step 6: Build Release APK

```bash
# Clean previous builds first
flutter clean
flutter pub get

# Build the release APK
flutter build apk --release
```

This takes 2–5 minutes. When done you'll see:
```
✅  Built build/app/outputs/flutter-apk/app-release.apk (XX.XMB)
```

---

## Step 7: Find Your APK

The APK file is created at:
```
SavariGo_Flutter/
└── build/
    └── app/
        └── outputs/
            └── flutter-apk/
                └── app-release.apk   ← YOUR APK FILE HERE
```

---

## Step 8: Install APK on Phone

**Option A — Direct USB install:**
```bash
flutter install
```

**Option B — Copy APK to phone:**
1. Copy `app-release.apk` to your phone via USB
2. On phone, open **File Manager** → find the APK
3. Tap it → allow installation from unknown sources
4. Tap **Install**

**Option C — Share via WhatsApp/Drive:**
- Send the APK to yourself via WhatsApp or Google Drive
- Download and install on phone

---

## Build Split APKs (Smaller Size)

For a smaller APK, build split by ABI:
```bash
flutter build apk --split-per-abi
```

This creates 3 APKs:
- `app-armeabi-v7a-release.apk`  → For older Android phones
- `app-arm64-v8a-release.apk`    → For modern Android phones ✅ (use this)
- `app-x86_64-release.apk`       → For emulators

---

## Build App Bundle (for Google Play Store)

```bash
flutter build appbundle
```

Output: `build/app/outputs/bundle/release/app-release.aab`

---

## Common Errors and Fixes

| Error | Fix |
|---|---|
| `flutter: command not found` | Add Flutter to PATH. See flutter.dev |
| `No connected devices` | Enable USB debugging on phone |
| `Gradle build failed` | Run `flutter clean` then `flutter build apk` again |
| `minSdkVersion` error | Open `android/app/build.gradle`, set `minSdkVersion 21` |
| `JAVA_HOME not set` | Install JDK 11 and set JAVA_HOME environment variable |
| `Supabase connection error` | Check your Supabase URL and anon key in `lib/services/supabase_service.dart` |

---

## Quick Command Reference

```bash
flutter doctor          # Check Flutter setup
flutter pub get         # Install packages
flutter run             # Run on connected device
flutter run --release   # Run release build on device
flutter build apk       # Build debug APK
flutter build apk --release   # Build release APK ✅
flutter build apk --split-per-abi   # Build smaller split APKs
flutter install         # Install APK on connected phone
flutter clean           # Clean build cache
flutter devices         # List connected devices
```

---

## APK Location Summary

```
build/app/outputs/flutter-apk/app-release.apk
```

This is the final APK you submit or demo for your final year project! 🎉
