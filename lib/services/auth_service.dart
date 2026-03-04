import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';

class AuthResult {
  const AuthResult({
    required this.success,
    this.message,
    this.token,
  });

  final bool success;
  final String? message;
  final String? token;
}

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _emailKey = 'auth_email';
  static const String _rememberKey = 'remember_me';

  Future<AuthResult> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.loginUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final Map<String, dynamic> data = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};

      if (response.statusCode == 200 && data['success'] == true) {
        final token = data['token']?.toString();
        if (token == null || token.isEmpty) {
          return const AuthResult(
            success: false,
            message: 'Authentication token missing in server response.',
          );
        }

        await _saveSession(
          token: token,
          email: email,
          rememberMe: rememberMe,
        );

        return AuthResult(
          success: true,
          message: data['message']?.toString() ?? 'Login successful',
          token: token,
        );
      }

      if (response.statusCode == 422) {
        final errors = data['errors'];
        if (errors is Map<String, dynamic>) {
          final first = errors.values.first;
          if (first is List && first.isNotEmpty) {
            return AuthResult(success: false, message: first.first.toString());
          }
        }
      }

      return AuthResult(
        success: false,
        message: data['message']?.toString() ??
            'Login failed (${response.statusCode}).',
      );
    } catch (_) {
      return const AuthResult(
        success: false,
        message: 'Unable to connect to backend. Check API base URL and network.',
      );
    }
  }

  Future<void> _saveSession({
    required String token,
    required String email,
    required bool rememberMe,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_emailKey, email);
    await prefs.setBool(_rememberKey, rememberMe);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberKey) ?? true;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_rememberKey);
    await prefs.remove(_emailKey);
  }
}
