class AuthUserProfile {
  const AuthUserProfile({
    required this.name,
    required this.email,
    required this.designation,
    required this.department,
    required this.employeeId,
    required this.phone,
    required this.joiningDate,
  });

  final String name;
  final String email;
  final String designation;
  final String department;
  final String employeeId;
  final String phone;
  final String joiningDate;

  String get avatarLetters {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return 'NA';
    }

    final parts = trimmedName
        .split(RegExp(r'\s+'))
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return trimmedName.substring(0, 1).toUpperCase();
    }

    if (parts.length == 1) {
      final token = parts.first;
      return token.substring(0, token.length >= 2 ? 2 : 1).toUpperCase();
    }

    final first = parts.first.substring(0, 1);
    final second = parts[1].substring(0, 1);
    return (first + second).toUpperCase();
  }

  static AuthUserProfile fromJson(Map<String, dynamic> json) {
    final employee = _readMap(json['employee']);

    return AuthUserProfile(
      name: _firstNonEmpty([
        json['name'],
        json['username'],
      ], fallback: 'User'),
      email: _firstNonEmpty([
        json['email'],
      ], fallback: 'N/A'),
      designation: _firstNonEmpty([
        json['designation'],
        employee['designation'],
        employee['job_title'],
      ], fallback: 'N/A'),
      department: _firstNonEmpty([
        json['department'],
        employee['department'],
      ], fallback: 'N/A'),
      employeeId: _firstNonEmpty([
        json['employeeId'],
        json['employee_id'],
        employee['employeeId'],
        employee['employee_id'],
      ], fallback: 'N/A'),
      phone: _firstNonEmpty([
        json['phone'],
        json['mobile'],
        employee['phone'],
        employee['mobile'],
      ], fallback: 'N/A'),
      joiningDate: _firstNonEmpty([
        json['joiningDate'],
        json['date_of_joining'],
        employee['joiningDate'],
        employee['date_of_joining'],
      ], fallback: 'N/A'),
    );
  }

  static AuthUserProfile fallback() {
    return const AuthUserProfile(
      name: 'User',
      email: 'N/A',
      designation: 'N/A',
      department: 'N/A',
      employeeId: 'N/A',
      phone: 'N/A',
      joiningDate: 'N/A',
    );
  }

  static Map<String, dynamic> _readMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    return <String, dynamic>{};
  }

  static String _firstNonEmpty(
    List<Object?> values, {
    required String fallback,
  }) {
    for (final value in values) {
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty && text.toLowerCase() != 'null') {
        return text;
      }
    }
    return fallback;
  }
}
