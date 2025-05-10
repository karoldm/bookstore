import 'package:image_picker/image_picker.dart';

class RequestRegisterModel {
  String name;
  String slogan;
  XFile? banner;
  String username;
  String adminName;
  String password;

  RequestRegisterModel({
    required this.name,
    required this.slogan,
    required this.username,
    required this.adminName,
    required this.password,
    this.banner,
  });

  factory RequestRegisterModel.empty() {
    return RequestRegisterModel(
      name: "",
      slogan: "",
      banner: null,
      username: "",
      adminName: "",
      password: "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'slogan': slogan,
      'banner': banner,
      'adminName': adminName,
      'username': username,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'RegisterUserModel(name: $name, slogan: $slogan, banner: $banner, adminName: $adminName, user: $username, password: $password)';
  }
}
