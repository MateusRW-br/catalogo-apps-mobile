import 'dart:convert';
import 'package:http/http.dart' as http;
import '../token/token_storage.dart';

class AuthHelperApi {
  //String baseUrl = 'http://10.0.2.2:3000/api';  no  Android studio
  String baseUrl = 'http://localhost:3000/api';

  Future login({
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

      if (token != null) {
        await TokenStorage.salvarSessao(
          token: token,
          userId: user?['sub'] as int? ?? user?['id'] as int?,
          name: user?['name'] as String?,
          email: user?['email'] as String?,
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
  // Fazer register ou não fazer?   
}