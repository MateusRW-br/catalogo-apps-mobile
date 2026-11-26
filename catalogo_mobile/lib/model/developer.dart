class Developer {
  final int id;
  final String name;
  final String? icon;
  final int appsCount;

  Developer({
    required this.id,
    required this.name,
    this.icon,
    this.appsCount = 0,
  });

  factory Developer.fromJson(Map<String, dynamic> json) {
    final appsList = json['apps'] as List?;
    final rawCount = json['app_count'] ?? json['appsCount'];
    return Developer(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String?,
      appsCount: rawCount is num
          ? rawCount.toInt()
          : (appsList?.length ?? 0),
    );
  }
}