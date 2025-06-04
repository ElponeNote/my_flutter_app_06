class User {
  final String name;
  final String address;
  final String phone;
  final String email;

  User({
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'] ?? '',
        address: json['address'] ?? '',
        phone: json['phone'] ?? '',
        email: json['email'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address,
        'phone': phone,
        'email': email,
      };
} 