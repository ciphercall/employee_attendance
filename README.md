# employee_attendance

Flutter Android app for PPHL attendance.

## Backend auth integration

This app authenticates against `pphl_erp` JWT endpoints:

- `POST /api/v1/a/login`
- `GET /api/v1/get-my-info`
- `GET /api/v1/logout?token=...`

The app stores JWT token locally, loads profile from backend, and invalidates session on logout.

## Run backend for local network

From `pphl_erp`, run Laravel so phones on the same Wi-Fi can reach it:

- `php artisan serve --host=0.0.0.0 --port=8000`

Use your laptop LAN IP (example: `192.168.10.79`) for Android physical devices.

## Flutter build with local backend URL

From `employee_attendance`:

- `flutter pub get`
- `flutter build apk --release --dart-define=API_BASE_URL=http://192.168.10.79:8000 --dart-define=API_BASE_URLS=http://10.0.2.2:8000,http://192.168.10.79:8000`

`API_BASE_URL` is primary.
`API_BASE_URLS` is optional comma-separated fallback list.

Default (when no `dart-define` is passed): `http://10.0.2.2:8000`.
