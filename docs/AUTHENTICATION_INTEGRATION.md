# Authentication Integration (employee_attendance ↔ pphl_erp)

Last updated: March 4, 2026

## Summary

The Android app authentication is now integrated with the real backend API from `pphl_erp`.

- Previous behavior: dummy login with 2-second delay and unconditional success
- Current behavior: real API authentication against Laravel JWT endpoint

## Backend Endpoint Used

- Method: `POST`
- URL: `${API_BASE_URL}/api/v1/a/login`
- Request body:

```json
{
  "email": "user@domain.com",
  "password": "your-password"
}
```

- Success response (expected):

```json
{
  "success": true,
  "message": "Login successful",
  "token": "<jwt-token>",
  "token_type": "bearer"
}
```

## App Changes

### New Files

- `lib/config/app_config.dart`
  - Holds `API_BASE_URL` via `--dart-define`
  - Default: `http://10.0.2.2:8000`

- `lib/services/auth_service.dart`
  - Performs login HTTP request
  - Persists token/session using `shared_preferences`
  - Provides `isLoggedIn`, `getToken`, and `logout`

### Updated Files

- `lib/screens/login_screen.dart`
  - Replaced dummy auth with real API login
  - Shows backend validation/error messages
  - Loads remembered email state

- `lib/main.dart`
  - Added bootstrap auth check on app start
  - Navigates to `MainShell` if token exists, otherwise `LoginScreen`

- `lib/screens/profile_screen.dart`
  - Sign out now clears stored auth session before navigation

- `android/app/src/main/AndroidManifest.xml`
  - Added `android:usesCleartextTraffic="true"` for local HTTP backend in development

- `pubspec.yaml`
  - Added dependency: `http`

## Running with Backend

From project root (`employee_attendance`):

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

For physical Android device, use your PC LAN IP (example):

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.50:8000
```

## Build APK

```bash
flutter build apk --release --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

Generated APK:

- `build/app/outputs/flutter-apk/app-release.apk`

## Validation Performed

- Dependency fetch completed (`flutter pub get`)
- Flutter diagnostics for changed files reported no code errors
- Release APK rebuilt successfully with updated timestamp
