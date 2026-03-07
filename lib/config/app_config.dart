class AppConfig {
  AppConfig._();

  static const String _defaultLanBaseUrl = 'http://10.35.15.107:8080';
  static const String _defaultFallbackBaseUrls =
      'http://10.0.2.2:8080,http://127.0.0.1:8080,http://192.168.10.79:8080';

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: _defaultLanBaseUrl,
  );

  static const String _apiBaseUrls = String.fromEnvironment(
    'API_BASE_URLS',
    defaultValue: _defaultFallbackBaseUrls,
  );

  static List<String> get apiBaseUrlCandidates {
    final rawBases = <String>{
      apiBaseUrl.trim(),
      if (_apiBaseUrls.trim().isNotEmpty)
        ..._apiBaseUrls
            .split(',')
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty),
    };

    final values = <String>{};
    for (final base in rawBases) {
      values.add(base);

      final uri = Uri.tryParse(base);
      if (uri == null || uri.host.isEmpty) {
        continue;
      }

      final hasExplicitPort = base.contains(':${uri.port}') &&
          (uri.port == 8000 || uri.port == 8080);
      if (!hasExplicitPort) {
        continue;
      }

      final alternatePort = uri.port == 8000 ? 8080 : 8000;
      final alternateUri = uri.replace(port: alternatePort);
      values.add(alternateUri.toString());
    }

    return values.toList();
  }

  static List<String> get loginUrls =>
      apiBaseUrlCandidates.map((base) => '$base/api/v1/a/login').toList();

  static List<String> get currentUserUrls =>
      apiBaseUrlCandidates.map((base) => '$base/api/v1/get-my-info').toList();

  static List<String> get logoutUrls =>
      apiBaseUrlCandidates.map((base) => '$base/api/v1/logout').toList();

  static List<String> get attendanceRequestUrls => apiBaseUrlCandidates
      .map((base) => '$base/api/v1/mobile/attendance-requests')
      .toList();

  static List<String> get faceRegistrationUrls => apiBaseUrlCandidates
      .map((base) => '$base/api/v1/mobile/face-registration')
      .toList();
}
