class Profile {
  final int id;
  final int userId;
  final String fullName;
  final DateTime? birthDate;
  final String? avatarUrl;

  Profile({
    required this.id,
    required this.userId,
    required this.fullName,
    this.birthDate,
    this.avatarUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as int,
      userId: json['userId'] as int,
      fullName: json['fullName'] as String,
      birthDate: json['birthDate'] != null
          ? DateTime.tryParse(json['birthDate'].toString())
          : null,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final Profile? profile;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      profile: json['profile'] != null
          ? Profile.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
    );
  }
}