class Review {
  final int id;
  final String name;
  final String markdownText;
  final double rating;
  final int appId;
  final int userId;
  final String authorName;

  Review({
    required this.id,
    required this.name,
    required this.markdownText,
    required this.rating,
    required this.appId,
    required this.userId,
    this.authorName = 'Anonymous',
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    return Review(
      id: json['id'] as int,
      name: json['name'] as String,
      markdownText:
          (json['markdownText'] ?? json['markdown_text'] ?? '') as String,
      rating: (json['rating'] as num).toDouble(),
      appId: (json['appId'] ?? json['app_id']) as int,
      userId: (json['userId'] ?? json['user_id']) as int,
      authorName: user?['name'] as String? ?? 'Anonymous',
    );
  }
}