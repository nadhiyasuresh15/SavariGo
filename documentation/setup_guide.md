# 🔧 SavariGo Flutter — Complete Setup Guide

## Prerequisites

| Tool | Version | Download |
|---|---|---|
| Flutter SDK | 3.0+ | https://flutter.dev/docs/get-started/install |
| Android Studio | Latest | https://developer.android.com/studio |
| Java JDK | 11+ | https://adoptium.net |
| VS Code | Latest | https://code.visualstudio.com |
| Git | Latest | https://git-scm.com |

---

## Step 1: Install Flutter SDK

### Windows
1. Download Flutter SDK from https://flutter.dev/docs/get-started/install/windows
2. Extract to `C:\flutter`
3. Add `C:\flutter\bin` to your **PATH** environment variable
4. Open new terminal and run: `flutter doctor`

### macOS
```bash
brew install flutter
# OR download from flutter.dev and add to PATH
```

### Linux
```bash
sudo snap install flutter --classic
flutter doctor
```

---

## Step 2: Install Android Studio

1. Download from https://developer.android.com/studio
2. Install with default settings
3. Open Android Studio → **More Actions → SDK Manager**
4. Install **Android SDK** (API level 33 or 34)
5. Accept all licenses

---

## Step 3: Check Flutter Doctor

Open terminal and run:
```bash
flutter doctor
```

Fix any issues shown. Common fixes:
- **Android SDK not found:** Open Android Studio → SDK Manager → install SDK
- **Java not found:** Install JDK from https://adoptium.net
- **VS Code extension missing:** Install "Flutter" extension in VS Code

---

## Step 4: Open Project in VS Code

```bash
cd SavariGo_Flutter
code .
```

VS Code will detect it's a Flutter project. Install extensions if prompted:
- **Flutter** (by Dart Code)
- **Dart** (by Dart Code)

---

## Step 5: Install Flutter Packages

In VS Code terminal (Ctrl+`):
```bash
flutter pub get
```

---

## Step 6: Create Supabase Project

1. Go to https://supabase.com → Sign up free
2. Click **New Project**
3. Set:
   - Name: `SavariGo`
   - Database Password: (choose strong password)
   - Region: **Southeast Asia (Singapore)** — closest to Chennai
4. Wait ~2 minutes for project to be ready

---

## Step 7: Get Supabase Credentials

1. In your Supabase project → click **Settings** (gear icon) → **API**
2. Copy:
   - **Project URL** → looks like `https://abcdef.supabase.co`
   - **anon / public key** → long string starting with `eyJ...`

---

## Step 8: Paste Credentials in Flutter App

Open: `lib/services/supabase_service.dart`

Replace the placeholder values:
```dart
// BEFORE:
static const String supabaseUrl     = 'YOUR_SUPABASE_PROJECT_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

// AFTER:
static const String supabaseUrl     = 'https://abcdefgh.supabase.co';
static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

Save the file.

---

## Step 9: Run Database Schema in Supabase

1. In your Supabase project → click **SQL Editor** (left sidebar)
2. Click **New Query**
3. Open `database/supabase_schema.sql` from this project
4. Copy all contents → paste into SQL Editor → click **Run**
5. You'll see "Success. No rows returned" — all 8 tables are created ✅

---

## Step 10: Insert Sample Data

1. In Supabase SQL Editor → click **New Query** again
2. Open `database/sample_supabase_data.sql`
3. Copy all contents → paste → click **Run**
4. Sample passengers, drivers, and rides are now in the database ✅

---

## Step 11: Connect Android Phone

1. Enable **Developer Options** on your phone (tap Build Number 7 times)
2. Enable **USB Debugging**
3. Connect via USB
4. Run:
```bash
flutter devices
```
You should see your phone listed.

---

## Step 12: Run the App

```bash
flutter run
```

App will install and launch on your phone!

**Demo login (no Supabase needed):**
- Passenger: `passenger@savarigo.com` / `123456`
- Driver:    `driver@savarigo.com` / `123456`
- Admin:     `admin@savarigo.com` / `admin123`

---

## Step 13: Build Release APK

```bash
flutter clean
flutter pub get
flutter build apk --release
```

APK will be at:
```
build/app/outputs/flutter-apk/app-release.apk
```

---

## Note: App Works Without Supabase

If you haven't set up Supabase yet, the app **still works** using demo login and sample data. This is useful for:
- College demo
- Testing the UI
- Viva presentation

The app detects if Supabase is configured and falls back to demo mode automatically.
