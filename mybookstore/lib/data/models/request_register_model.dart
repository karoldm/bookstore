import 'package:mybookstore/data/models/request_user_model.dart';

class RequestRegisterModel {
  String name;
  String slogan;
  String? banner;
  RequestUserModel admin;

  RequestRegisterModel({
    required this.name,
    required this.slogan,
    required this.admin,
    this.banner,
  });

  factory RequestRegisterModel.empty() {
    return RequestRegisterModel(
      name: "",
      slogan: "",
      banner: null,
      admin: RequestUserModel.empty(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'slogan': slogan,
      'banner': banner,
      'admin': admin.toMap(),
    };
  }

  @override
  String toString() {
    return 'RegisteStoreModel(name: $name, slogan: $slogan, banner: $banner, user: $admin)';
  }
}
