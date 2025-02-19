class UserModel {
  final int id;
  final String name;
  final String lastname;
  final String email;
  final String password;
  final String token;
  final String role;
  final bool activated;

  UserModel({
    required this.id,
    required this.name,
    required this.lastname,
    required this.email,
    required this.password,
    required this.token,
    required this.role,
    required this.activated,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      lastname: json['lastname'],
      email: json['email'],
      password: json['password'],
      token: json['token'] ?? '',
      role: json['role'],
      activated: json['activated'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastname': lastname,
      'email': email,
      'password': password,
      'token': token,
      'role': role,
      'activated': activated,
    };
  }
}
