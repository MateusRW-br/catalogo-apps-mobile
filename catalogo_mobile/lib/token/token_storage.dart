import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  final String token;
  final int? userId;
  final String? name;
  final String? email;
  final String? fullName;
  final DateTime? birthDate;
  final String? avatarUrl;

  const UserSession({
    required this.token,
    this.userId,
    this.name,
    this.email,
    this.fullName,
    this.birthDate,
    this.avatarUrl,
  });
}

class TokenStorage {
  static final ValueNotifier<int> sessionVersion = ValueNotifier<int>(0);

  static const _keyToken = 'access_token';
  static const _keyUserId = 'user_id';
  static const _keyUserName = 'user_name';
  static const _keyUserEmail = 'user_email';
  static const _keyProfileFullName = 'profile_full_name';
  static const _keyProfileBirthDate = 'profile_birth_date';
  static const _keyProfileAvatarUrl = 'profile_avatar_url';

  static Future<void> salvarSessao({
    required String token,
    int? userId,
    String? name,
    String? email,
    String? fullName,
    DateTime? birthDate,
    String? avatarUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    if (userId != null) {
      await prefs.setInt(_keyUserId, userId);
    } else {
      await prefs.remove(_keyUserId);
    }
    if (name != null) {
      await prefs.setString(_keyUserName, name);
    } else {
      await prefs.remove(_keyUserName);
    }
    if (email != null) {
      await prefs.setString(_keyUserEmail, email);
    } else {
      await prefs.remove(_keyUserEmail);
    }
    if (fullName != null && fullName.isNotEmpty) {
      await prefs.setString(_keyProfileFullName, fullName);
    } else {
      await prefs.remove(_keyProfileFullName);
    }
    if (birthDate != null) {
      await prefs.setString(_keyProfileBirthDate, birthDate.toIso8601String());
    } else {
      await prefs.remove(_keyProfileBirthDate);
    }
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      await prefs.setString(_keyProfileAvatarUrl, avatarUrl);
    } else {
      await prefs.remove(_keyProfileAvatarUrl);
    }
    sessionVersion.value++;
  }

  Future<UserSession?> lerSessao() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_keyToken);
    if (token == null || token.isEmpty) return null;

    final birthDateStr = prefs.getString(_keyProfileBirthDate);
    return UserSession(
      token: token,
      userId: prefs.getInt(_keyUserId),
      name: prefs.getString(_keyUserName),
      email: prefs.getString(_keyUserEmail),
      fullName: prefs.getString(_keyProfileFullName),
      birthDate:
          birthDateStr != null ? DateTime.tryParse(birthDateStr) : null,
      avatarUrl: prefs.getString(_keyProfileAvatarUrl),
    );
  }

  Future<String?> lerToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  Future<int?> lerUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserId);
  }

  Future<String?> lerUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  Future<void> limparSessao() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyProfileFullName);
    await prefs.remove(_keyProfileBirthDate);
    await prefs.remove(_keyProfileAvatarUrl);
    sessionVersion.value++;
  }
}