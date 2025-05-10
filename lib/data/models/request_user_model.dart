class RequestUserModel {
  String username;
  String name;
  String password;

  RequestUserModel({
    required this.username,
    required this.name,
    required this.password,
  });

  factory RequestUserModel.empty() {
    return RequestUserModel(username: "", name: "", password: "");
  }

  Map<String, dynamic> toMap() {
    return {'username': username, 'name': name, 'password': password};
  }

  @override
  String toString() {
    return 'RegisterUserModel(name: $name, user: $username, password: $password)';
  }
}
