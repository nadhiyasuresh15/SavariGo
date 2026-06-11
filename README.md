# 🚖 SavariGo — AI-Based Shared Auto-Rickshaw Pooling System

> **Final Year Project** | Flutter + Dart + Supabase | Chennai, Tamil Nadu

---

## 📌 Overview

**SavariGo** is a real-time AI-based shared auto-rickshaw pooling app for Chennai. Passengers travelling in similar directions share an auto-rickshaw, reducing travel cost by 40–60%, cutting waiting time, and lowering pollution.

**Vanakkam! Share the Ride, Save the City. 🚖🌿**

---

## 🌟 Key Features

| Feature | Description |
|---|---|
| 🤖 AI Pool Matching | Rule-based Dart algorithm — 100-point scoring |
| 👩 Women-Only Mode | Pengal Mattum Mode — female-only safe pooling |
| 🚨 SOS Safety | Emergency alert with trusted contact notification |
| 🌿 Green Points | Reward points for every shared ride |
| 📍 Chennai Routes | 20 Chennai locations with Tamil UI text |
| 💰 Fare Splitting | Auto-calculated shared fare with savings display |
| ✅ Driver Verification | Trust-scored, background-checked drivers |
| 📊 Admin Panel | Full admin dashboard built in Flutter |

---

## 🛠️ Technology Stack

| Layer | Technology |
|---|---|
| Mobile App | **Flutter** (Dart) |
| Database | **Supabase** (PostgreSQL) |
| Authentication | **Supabase Auth** + demo fallback |
| AI Matching | Rule-based Dart algorithm |
| Admin Panel | Flutter screens |
| Maps | Placeholder UI (Google Maps-ready) |

---

## 📁 Project Structure

```
SavariGo_Flutter/
├── assets/images/logo.png        ← Official SavariGo logo
├── lib/
│   ├── main.dart                 ← Entry point
│   ├── app.dart                  ← Routes & theme
│   ├── constants/                ← Colors, routes, text
│   ├── models/                   ← Data models
│   ├── services/                 ← Supabase, AI, fare, safety
│   ├── screens/
│   │   ├── splash/               ← Animated splash screen
│   │   ├── auth/                 ← Login, Register
│   │   ├── passenger/            ← 10 passenger screens
│   │   ├── driver/               ← 4 driver screens
│   │   └── admin/                ← 7 admin screens
│   └── widgets/                  ← Reusable UI components
├── database/
│   ├── supabase_schema.sql       ← Run first in Supabase
│   └── sample_supabase_data.sql  ← Sample data
├── documentation/                ← Full project docs
└── pubspec.yaml
```

---

## 🔑 Sample Login Credentials

| Role | Email | Password |
|---|---|---|
| Passenger | passenger@savarigo.com | 123456 |
| Female Passenger | priya@savarigo.com | 123456 |
| Auto Driver | driver@savarigo.com | 123456 |
| Admin | admin@savarigo.com | admin123 |

> **Demo mode:** App works with these credentials even without Supabase configured!

---

## ⚡ Quick Start

### 1. Install Dependencies
```bash
cd SavariGo_Flutter
flutter pub get
```

### 2. Set Up Supabase (Optional for demo)
Open `lib/services/supabase_service.dart` and paste your credentials:
```dart
static const String supabaseUrl     = 'https://your-project.supabase.co';
static const String supabaseAnonKey = 'your-anon-key';
```

### 3. Run Database SQL
In Supabase SQL Editor, run:
1. `database/supabase_schema.sql`
2. `database/sample_supabase_data.sql`

### 4. Run the App
```bash
flutter run
```

### 5. Build APK
```bash
flutter build apk --release
```
APK location: `build/app/outputs/flutter-apk/app-release.apk`

---

## 📱 Screens List

### Passenger Module (10 screens)
1. Splash Screen — Animated logo
2. Login Screen — Passenger/driver toggle
3. Register Screen — Full registration with gender
4. Passenger Home — Booking card, Chennai locations
5. Book Ride — Location picker, seats, women-only
6. AI Pool Match — Match score, fare split, driver
7. Women-Only Mode — Pengal Mattum Mode
8. Fare Split — Detailed fare breakdown
9. Ride Tracking — Placeholder map with stages
10. Ride History, Profile, Safety/SOS, Feedback

### Driver Module (4 screens)
1. Driver Dashboard — Online toggle, requests
2. Active Ride — Stage progression, OTP
3. Driver Earnings — Daily/weekly breakdown
4. Driver Profile — Trust score, vehicle info

### Admin Module (7 screens)
1. Admin Login, Dashboard, Passengers
2. Drivers, Rides, SOS Alerts, Reports

---

## 🤖 AI Matching Score

| Factor | Points |
|---|---|
| Pickup location similarity | 25 |
| Drop location similarity | 25 |
| Travel time similarity | 20 |
| Gender / Women-Only compat. | 20 |
| Seat availability | 10 |
| **Match threshold** | **≥ 70** |

---

## 🚀 Future Enhancements

- Google Maps live tracking integration
- Tamil Voice Assistant
- UPI / Razorpay payment
- Real-time WebSocket ride matching
- SMS OTP via Twilio/MSG91
- Student discount mode
- Peak-hour dynamic pricing
- Push notifications

---

## 📋 Viva Explanation Points

1. **Why Flutter?** — Single codebase for Android + iOS + Web. Fast development, beautiful UI.
2. **Why Supabase?** — Open-source, PostgreSQL-based, free tier available, built-in Auth.
3. **Why rule-based AI?** — Interpretable, fast, reliable, works with small datasets. Can be upgraded to ML later.
4. **Women-Only Mode** — Gender filter in matching algorithm + extra safety stack.
5. **Green Points** — Gamification to encourage shared rides and reduce pollution.
6. **No real Google Maps** — Placeholder map UI allows demo without API key cost.
7. **Demo fallback** — App works without Supabase using hardcoded demo credentials.

---

*Vanakkam! 🙏 Nandri for choosing SavariGo.*
