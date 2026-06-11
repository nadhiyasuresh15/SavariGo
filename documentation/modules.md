# 📦 SavariGo Flutter — Modules Documentation

## Module 1: Passenger Module
**Screens:** `lib/screens/passenger/`
- `passenger_home_screen.dart` — Home with booking card, Chennai locations, feature grid
- `book_ride_screen.dart` — Location picker, seat selection, women-only toggle
- `ai_pool_match_screen.dart` — AI matching result with score, fare, driver details
- `women_only_mode_screen.dart` — Pengal Mattum Mode with safety toggles
- `fare_split_screen.dart` — Detailed fare breakdown and savings
- `ride_tracking_screen.dart` — Live ride stages with placeholder map
- `ride_history_screen.dart` — Past rides list
- `profile_screen.dart` — User profile, stats, green points
- `safety_screen.dart` — SOS button, helplines, safety features
- `feedback_screen.dart` — Star rating and complaint submission

## Module 2: Driver Module
**Screens:** `lib/screens/driver/`
- `driver_dashboard_screen.dart` — Online/offline toggle, earnings, ride requests
- `active_ride_screen.dart` — Placeholder map, passenger details, stage progression
- `driver_earnings_screen.dart` — Daily/weekly earnings, eco impact
- `driver_profile_screen.dart` — Driver info, vehicle, trust score, logout

## Module 3: Admin Module
**Screens:** `lib/screens/admin/`
- `admin_login_screen.dart` — Secure admin login
- `admin_dashboard_screen.dart` — Stats cards, Chennai zones, sidebar navigation
- `manage_users_screen.dart` — Passenger list with gender and green points
- `manage_drivers_screen.dart` — Driver list with verification and trust score
- `manage_rides_screen.dart` — All rides with status and women-only filter
- `sos_alerts_screen.dart` — SOS alert monitoring with active alert banner
- `reports_screen.dart` — Monthly bar charts, revenue, zone breakdown

## Module 4: AI Matching Module
**File:** `lib/services/ai_matching_service.dart`
- 100-point rule-based Dart algorithm
- Haversine GPS distance calculation
- Women-only gender compatibility filter
- Returns `MatchResult` with score, fare, savings

## Module 5: Safety Module
**Files:** `lib/services/safety_service.dart`, `lib/screens/passenger/safety_screen.dart`
- SOS alert creation in Supabase
- Emergency contact notification (SMS in production)
- Guardian Mode placeholder
- OTP verification UI

## Module 6: Fare Module
**File:** `lib/services/fare_service.dart`
- Base fare: ₹30 for 1.5 km
- Per km rate: ₹15
- Peak hour 20% surge (weekdays 8–10 AM, 5–8 PM)
- Returns `FareResult` with split, savings, percentage

## Shared Widgets
**Folder:** `lib/widgets/`
- `custom_button.dart` — Branded yellow button
- `custom_text_field.dart` — Labelled input with validation
- `ride_card.dart` — Ride history card with status badge
- `match_score_card.dart` — AI match score display
- `dashboard_card.dart` — Admin stat card with color accent
- `safety_button.dart` — Red SOS circular button
- `app_drawer.dart` — Side navigation drawer
