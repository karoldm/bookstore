import 'package:bookstore/data/models/user_model.dart';

class StoreModel {
  String name;
  String slogan;
  String? banner;
  final int id;
  UserModel user;

  StoreModel({
    required this.user,
    required this.name,
    required this.slogan,
    required this.banner,
    required this.id,
  });

  factory StoreModel.fromMap(Map<String, dynamic> json) {
    return StoreModel(
      user:
          json['user'] != null
              ? UserModel.fromMap(json['user'])
              : UserModel.empty(),
      id: json['idStore'] ?? json['id'],
      name: json['name'],
      slogan: json['slogan'],
      banner: json['banner'],
    );
  }

  @override
  String toString() {
    return 'StoreModel(id: $id, name: $name, slogan: $slogan, banner: $banner, user: $user)';
  }
}
