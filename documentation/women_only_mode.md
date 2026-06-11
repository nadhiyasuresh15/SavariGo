# 👩 SavariGo Flutter — Women-Only Mode (Pengal Mattum Mode)

## Purpose
Provides a safe, female-exclusive pooling environment for women passengers in Chennai.

## Activation
Passengers go to the Women-Only Mode screen and toggle **Pengal Mattum Mode ON**.

## Screen Location
```
lib/screens/passenger/women_only_mode_screen.dart
```

## Matching Rules (in ai_matching_service.dart)
```dart
static int _scoreGender(bool ride1WomenOnly, String gender1,
                         bool ride2WomenOnly, String gender2) {
  if (ride1WomenOnly || ride2WomenOnly) {
    return (gender1 == 'female' && gender2 == 'female') ? 20 : 0;
  }
  return 20;
}
```
- If **either** passenger has `womenOnly = true`, **both must be female** → 20 pts
- Otherwise returns 0 → they are **never matched**

## Safety Features Activated
| Feature | Description |
|---|---|
| 👩 Female-only matching | Only matched with other female passengers |
| ✅ Verified drivers only | trust_score ≥ 80 required |
| 🔐 OTP Verification | Driver must enter OTP before starting |
| 👁️ Guardian Mode | Live ride shared with trusted contact |
| 🚨 SOS always visible | One-tap emergency button throughout ride |
| 📞 Auto-notify contact | Emergency contact alerted when ride starts |

## Database Fields Used
```sql
passengers.women_only_enabled BOOLEAN  -- user preference
rides.women_only              BOOLEAN  -- applied to this ride
```

## Tamil UI Labels
- "Pengal Mattum Mode" — Women Only Mode
- "Paathukaapu" — Safety/Protection  
- "பெண்கள் மட்டும் பயணம்" — Women-only travel
