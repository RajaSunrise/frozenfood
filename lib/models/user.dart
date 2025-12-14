class User {
  final String id;
  final String email;
  final String name;
  final String password;
  final String address;
  final String phoneNumber;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    this.address = '',
    this.phoneNumber = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      'address': address,
      'phoneNumber': phoneNumber,
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
    );
  }

  User copyWith({
    String? name,
    String? email,
    String? password,
    String? address,
    String? phoneNumber,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
