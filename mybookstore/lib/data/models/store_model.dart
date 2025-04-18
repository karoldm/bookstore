import 'dart:io';

class StoreModel {
  final String name;
  final String slogan;
  final File? banner;
  final String id;

  StoreModel({
    required this.name,
    required this.slogan,
    required this.banner,
    required this.id,
  });

  factory StoreModel.fromMap(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'],
      name: json['name'],
      slogan: json['slogan'],
      banner: File(json['banner']),
    );
  }

  @override
  String toString() {
    return 'StoreModel(id: $id, name: $name, slogan: $slogan, banner: $banner)';
  }
}
