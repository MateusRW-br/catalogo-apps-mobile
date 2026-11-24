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
    return Developer(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String?,
      appsCount: appsList?.length ?? (json['appsCount'] as int? ?? 0),
    );
  }
}