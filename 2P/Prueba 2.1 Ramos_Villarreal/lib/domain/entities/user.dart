class User {
  final int id;
  final String name;
  final String email;
  final String username;
  final String city;
  final String companyName;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.city,
    required this.companyName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      username: json['username'],
      city: json['address']['city'],
      companyName: json['company']['name'],
    );
  }
}