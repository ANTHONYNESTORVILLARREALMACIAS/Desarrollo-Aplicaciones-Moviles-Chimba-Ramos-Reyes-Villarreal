class User {
  final String id;
  final String username;
  final String email;
  final String? avatar;
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.avatar,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        avatar: json['avatar'],
        createdAt: DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'avatar': avatar,
        'created_at': createdAt.toIso8601String(),
      };

  String get displayName => username;
  String get name => username; // Agregar getter 'name' para compatibilidad
  String get initials => username.isNotEmpty 
      ? username.substring(0, 1).toUpperCase() 
      : 'U';
}
