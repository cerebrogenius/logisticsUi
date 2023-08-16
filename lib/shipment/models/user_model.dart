class UserModel{
  final String name;
  final String email;
  final String password;

  UserModel({
    required this.name, 
    required this.email, 
    required this.password
    });
    Map<String,dynamic>toMap(UserModel user){
      return {
        "name":user.name,
        "email":user.email,
        "password":user.password
      };
    }
    UserModel toUser(Map<String,dynamic>json){
      return UserModel(
        name: json['name'], 
        email: json['email'], 
        password: json['password']);
    }
}