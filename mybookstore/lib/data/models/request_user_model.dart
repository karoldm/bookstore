import 'dart:io';

class RequestUserModel {
  String username;
  String name;
  String password;
  File? photo;

  RequestUserModel({
    required this.username,
    required this.name,
    required this.password,
    this.photo,
  });

  factory RequestUserModel.empty() {
    return RequestUserModel(
      username: "",
      name: "",
      password: "",
      photo: File(""),
    );
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
    return 'RegisterUserModel(name: $name, username: $username, password: $password, photo: $photo)';
  }
}
