import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/app.dart';
import '../model/developer.dart';
import '../model/review.dart';
import '../token/token_storage.dart';

class AppHelperApi {
  // Use http://10.0.2.2:3000/api se rodar no emulador Android
  static const String baseUrl = 'http://localhost:3000/api';
  final TokenStorage _tokenStorage = TokenStorage();

  Future _headers() async {
    final token = await _tokenStorage.lerToken();
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<AppModel>> listarApps({
    String? search,
    String? category,
    String? pricing,
    int? developerId,
    String? sortBy,
    String? order,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
    }
    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }
    if (pricing != null && pricing.isNotEmpty) {
      queryParams['pricing'] = pricing.toLowerCase();
    }
    if (developerId != null) {
      queryParams['developerId'] = developerId.toString();
    }
    if (sortBy != null && sortBy.isNotEmpty) {
      queryParams['sortBy'] = sortBy;
    }
    if (order != null && order.isNotEmpty) {
      queryParams['order'] = order;
    }

    final uri = Uri.parse('$baseUrl/apps').replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: await _headers());

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> listaJson = decoded is Map && decoded['data'] is List
          ? decoded['data'] as List<dynamic>
          : (decoded as List<dynamic>);

      return listaJson
          .map((item) => AppModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Erro ao carregar aplicativos (${response.statusCode})');
  }

  Future<AppModel> buscarAppPorId(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/apps/$id'),
      headers: await _headers(),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final appJson = decoded['data'] is Map<String, dynamic>
          ? decoded['data'] as Map<String, dynamic>
          : decoded;
      return AppModel.fromJson(appJson);
    }

    throw Exception('Erro ao carregar detalhes do app (${response.statusCode})');
  }

  Future<List<Review>> listarReviewsDoApp(int appId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/apps/$appId/reviews?page=1&limit=20'),
      headers: await _headers(),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> listaJson = decoded is Map && decoded['data'] is List
          ? decoded['data'] as List<dynamic>
          : (decoded as List<dynamic>);

      return listaJson
          .map((item) => Review.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Erro ao carregar reviews (${response.statusCode})');
  }

  Future<void> criarReview({
    required int appId,
    required String name,
    required String markdownText,
    required double rating,
  }) async {
    final userId = await _tokenStorage.lerUserId() ?? 1;

    final response = await http.post(
      Uri.parse('$baseUrl/apps/$appId/reviews'),
      headers: await _headers(),
      body: jsonEncode({
        'userId': userId,
        'name': name.trim(),
        'markdownText': markdownText.trim(),
        'rating': rating,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final body = jsonDecode(response.body);
      final msg = body is Map && body['message'] != null
          ? body['message'].toString()
          : 'Erro ao criar review (${response.statusCode})';
      throw Exception(msg);
    }
  }

  Future<List<Developer>> listarDevelopers({
    int page = 1,
    int limit = 20,
    bool includeApps = true,
  }) async {
    final uri = Uri.parse('$baseUrl/developers').replace(
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
        'includeApps': includeApps.toString(),
      },
    );

    final response = await http.get(uri, headers: await _headers());

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> listaJson = decoded is Map && decoded['data'] is List
          ? decoded['data'] as List<dynamic>
          : (decoded as List<dynamic>);

      return listaJson
          .map((item) => Developer.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Erro ao carregar desenvolvedores (${response.statusCode})');
  }

  Future<Developer> buscarDeveloperPorId(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/developers/$id'),
      headers: await _headers(),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final devJson = decoded['data'] is Map<String, dynamic>
          ? decoded['data'] as Map<String, dynamic>
          : decoded;
      return Developer.fromJson(devJson);
    }

    throw Exception('Erro ao carregar desenvolvedor (${response.statusCode})');
  }
}