class UserModel {
  final String? name;
  final String? email;
  final String? password;
  final DateTime? created_at;
  final bool? isActive;

  UserModel({
    this.name,
    this.email,
    this.isActive,
    this.password,
    this.created_at,
  });

  Map<String, dynamic> toMap(UserModel user) {
    return {"name": user.name, "email": user.email, "password": user.password};
  }

  UserModel toUser(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }

  UserModel getUser(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      created_at: DateTime.parse(json['created_at']),
      isActive: json['is_active'],
    );
  }
}
// {name: Cerebro, email: cerebro@gmail.com, _id: 64dc0c7b85b16933f67b5222, created_at: 2023-06-24T17:19:10.572000, is_active: false}