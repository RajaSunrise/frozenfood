class User {
  final String id;
  final String email;
  final String name;
  final String password;
  final String address;
  final String phoneNumber;
  final String avatarUrl;
  final int points;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    this.address = '',
    this.phoneNumber = '',
    this.avatarUrl = 'https://i.pravatar.cc/150',
    this.points = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      'address': address,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'points': points,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      password: json['password'],
      address: json['address'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      avatarUrl: json['avatarUrl'] ?? 'https://i.pravatar.cc/150',
      points: json['points'] ?? 0,
    );
  }

  User copyWith({
    String? name,
    String? email,
    String? password,
    String? address,
    String? phoneNumber,
    String? avatarUrl,
    int? points,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      points: points ?? this.points,
    );
  }
}
