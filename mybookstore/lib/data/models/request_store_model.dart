import 'dart:io';

import 'package:mybookstore/data/models/request_user_model.dart';

class RequestStoreModel {
  String name;
  String slogan;
  File? banner;
  RequestUserModel admin;

  RequestStoreModel({
    required this.name,
    required this.slogan,
    required this.admin,
    this.banner,
  });

  factory RequestStoreModel.empty() {
    return RequestStoreModel(
      name: "",
      slogan: "",
      banner: File(""),
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
