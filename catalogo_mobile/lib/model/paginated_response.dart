class PaginatedResponse<T> {
  final List<T> data;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const PaginatedResponse({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginatedResponse.fromJson(
    dynamic decoded,
    T Function(Map<String, dynamic>) fromJsonT, {
    int fallbackPage = 1,
    int fallbackLimit = 10,
  }) {
    final List<dynamic> listaJson = decoded is Map && decoded['data'] is List
        ? decoded['data'] as List<dynamic>
        : (decoded is List ? decoded : <dynamic>[]);

    final items = listaJson
        .map((item) => fromJsonT(item as Map<String, dynamic>))
        .toList();

    final meta = decoded is Map && decoded['meta'] is Map
        ? decoded['meta'] as Map<String, dynamic>
        : null;

    final total = (meta?['total'] as num?)?.toInt() ?? items.length;
    final page = (meta?['page'] as num?)?.toInt() ?? fallbackPage;
    final limit = (meta?['limit'] as num?)?.toInt() ?? fallbackLimit;
    final totalPages = (meta?['totalPages'] as num?)?.toInt() ??
        (limit > 0 ? (total / limit).ceil().clamp(1, 999999) : 1);

    return PaginatedResponse<T>(
      data: items,
      total: total,
      page: page,
      limit: limit,
      totalPages: totalPages < 1 ? 1 : totalPages,
    );
  }
}
