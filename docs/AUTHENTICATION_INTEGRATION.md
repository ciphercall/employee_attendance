# Authentication & Mobile Attendance Integration (employee_attendance ↔ pphl_erp)

Last updated: March 5, 2026

## Summary

The app now uses live backend APIs for:

- JWT login/session
- user profile fetch (`get-my-info`)
- face registration persistence (`face_registration_android`)
- check-in/check-out attendance request submission (`new_attendance_requests`)
- attendance history records (`requested` status only)

## Backend endpoints used

- `POST /api/v1/a/login`
- `GET /api/v1/get-my-info`
- `GET /api/v1/logout?token=...`
- `GET /api/v1/mobile/face-registration`
- `POST /api/v1/mobile/face-registration`
- `GET /api/v1/mobile/attendance-requests?status=requested`
- `POST /api/v1/mobile/attendance-requests`

## App architecture updates

### New files

- `lib/models/face_registration_data.dart`
- `lib/models/attendance_request_record.dart`
- `lib/services/face_registration_api_service.dart`
- `lib/services/attendance_request_service.dart`

### Updated files

- `lib/services/face_recognition_service.dart`
  - face templates are no longer persisted in local storage
  - templates are held in memory and hydrated from backend payloads
- `lib/models/auth_user_profile.dart`
  - now includes `faceRegistration` payload parsing
- `lib/screens/login_screen.dart`
  - hydrates face registration after successful login
- `lib/main.dart`
  - bootstrap loads profile + face registration for existing token sessions
- `lib/screens/profile_screen.dart`
  - profile load hydrates face registration memory
  - logout clears in-memory registration
- `lib/screens/face_registration_screen.dart`
  - completed registration is synced to backend
- `lib/screens/check_in_screen.dart`
  - verified check-in/check-out submits attendance request to backend
- `lib/screens/home_screen.dart`
  - recent attendance records now come from backend
- `lib/screens/attendance_history_screen.dart`
  - dummy attendance records replaced by backend requested records

## Notes

- Dummy data is still used for non-attendance visual placeholders to keep UI consistency.
- App attendance list currently shows only records in `requested` state.
- Backend maps DB `pending` to API `requested` for mobile display.
- Home screen now exposes separate `Check In` and `Check Out` buttons.
  - `Check In` is enabled only when user is not clocked in.
  - `Check Out` is enabled only when user is clocked in.
  - Clocked-in state is derived from today's attendance request first, preventing stale/latest-record conflicts that could disable checkout incorrectly.
