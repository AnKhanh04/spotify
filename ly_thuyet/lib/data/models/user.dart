class User {
  final int id;
  final String username;
  final String email;
  final String? fullName;
  final String? avatarUrl;

  const User({
    required this.id,
    required this.username,
    required this.email,
    this.fullName,
    this.avatarUrl,
  });

  /// Tạo từ JSON (linh hoạt vì API có thể thiếu field)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? json['fullname'],
      avatarUrl: json['avatar_url'],
    );
  }
}
