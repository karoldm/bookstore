class RequestUserModel {
  String username;
  String name;
  String password;
  String? photo;

  RequestUserModel({
    required this.username,
    required this.name,
    required this.password,
    this.photo,
  });

  factory RequestUserModel.empty() {
    return RequestUserModel(username: "", name: "", password: "", photo: null);
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'name': name,
      'password': password,
      'photo': photo,
    };
  }

  @override
  String toString() {
    return 'RegisterUserModel(name: $name, user: $username, password: $password, photo: $photo)';
  }
}
