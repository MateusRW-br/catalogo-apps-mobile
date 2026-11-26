import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user.dart';
import '../token/token_storage.dart';

class AuthHelperApi {
  //String baseUrl = 'http://10.0.2.2:3000/api';  no  Android studio
  String baseUrl = 'http://localhost:3000/api';

  Future<Profile?> buscarPerfilPorUserId(int userId) async {
    final uri = Uri.parse('$baseUrl/profiles').replace(
      queryParameters: {'userId': userId.toString()},
    );
    final res = await http.get(
      uri,
      headers: const {'Content-Type': 'application/json'},
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final decoded = jsonDecode(res.body);
      Map<String, dynamic>? profileJson;
      if (decoded is Map<String, dynamic>) {
        if (decoded['data'] is Map<String, dynamic>) {
          profileJson = decoded['data'] as Map<String, dynamic>;
        } else if (decoded['data'] is List &&
            (decoded['data'] as List).isNotEmpty) {
          profileJson = (decoded['data'] as List).first as Map<String, dynamic>;
        } else if (decoded['id'] != null) {
          profileJson = decoded;
        }
      } else if (decoded is List && decoded.isNotEmpty) {
        profileJson = decoded.first as Map<String, dynamic>;
      }

      if (profileJson != null) {
        return Profile.fromJson(profileJson);
      }
    }
    return null;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email.trim(),
        'password': password,
      }),
    );

    final body = jsonDecode(res.body);

    if (res.statusCode == 200 || res.statusCode == 201) {
      final token = body['access_token'] as String?;
      final user = body['user'] as Map<String, dynamic>?;
      final userId = (user?['sub'] as num?)?.toInt() ??
          (user?['id'] as num?)?.toInt();

      Profile? profile;
      if (userId != null) {
        try {
          profile = await buscarPerfilPorUserId(userId);
        } catch (_) {
        }
      }

      if (token != null) {
        await TokenStorage.salvarSessao(
          token: token,
          userId: userId,
          name: user?['name'] as String?,
          email: user?['email'] as String?,
          fullName: profile?.fullName,
          birthDate: profile?.birthDate,
          avatarUrl: profile?.avatarUrl,
        );
      }
      return body as Map<String, dynamic>;
    } else {
      final mensagem = body is Map && body['message'] != null
          ? body['message'].toString()
          : 'Falha ao autenticar (${res.statusCode})';
      throw Exception(mensagem);
    }
  }
}