class AppModel {
  final int id;
  final String name;
  final String? icon;
  final String? link;
  final String smallDescription;
  final String markdownDescription;
  final double rating;
  final String category;
  final String pricing;
  final int developerId;
  final String developerName;
  final int reviewsCount;

  AppModel({
    required this.id,
    required this.name,
    this.icon,
    this.link,
    required this.smallDescription,
    required this.markdownDescription,
    required this.rating,
    required this.category,
    required this.pricing,
    required this.developerId,
    this.developerName = 'Desenvolvedor',
    this.reviewsCount = 0,
  });

  factory AppModel.fromJson(Map<String, dynamic> json) {
    final dev = json['developer'] as Map<String, dynamic>?;
    final reviews = json['reviews'] as List?;
    return AppModel(
      id: json['id'] as int,
      name: (json['name'] ?? '') as String,
      icon: json['icon'] as String?,
      link: json['link'] as String?,
      smallDescription:
          (json['smallDescription'] ?? json['small_description'] ?? '') as String,
      markdownDescription:
          (json['markdownDescription'] ?? json['markdown_description'] ?? '')
              as String,
      rating: (json['rating'] as num? ?? 0).toDouble(),
      category: (json['category'] ?? 'General') as String,
      pricing: (json['pricing'] ?? 'free') as String,
      developerId: (json['developerId'] ??
              json['developer_id'] ??
              dev?['id'] ??
              0) as int,
      developerName: dev?['name'] as String? ?? 'Desenvolvedor',
      reviewsCount: reviews?.length ?? (json['reviewsCount'] as int? ?? 0),
    );
  }
}