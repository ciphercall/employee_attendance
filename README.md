# employee_attendance

Flutter Android app for PPHL attendance.

## Current integration scope

- Login/auth session: backend JWT (`pphl_erp`)
- Face registration: persisted to backend table `face_registration_android`
- Check-in/check-out: submitted as attendance requests to backend table `new_attendance_requests`
- Home screen attendance actions: separate `Check In` and `Check Out` buttons with enable/disable rules
- Attendance records shown in app: real backend records with `requested` status only
- Dummy UI data retained for visual consistency (stats/other placeholders)

## Backend auth integration

This app authenticates against `pphl_erp` JWT endpoints:

- `POST /api/v1/a/login`
- `GET /api/v1/get-my-info`
- `GET /api/v1/logout?token=...`
- `GET /api/v1/mobile/face-registration`
- `POST /api/v1/mobile/face-registration`
- `GET /api/v1/mobile/attendance-requests?status=requested`
- `POST /api/v1/mobile/attendance-requests`

The app stores JWT token locally, loads profile + face registration from backend, keeps face data in memory for matching, and invalidates session on logout.

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
