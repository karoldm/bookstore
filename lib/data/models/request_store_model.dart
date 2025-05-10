import 'package:image_picker/image_picker.dart';

class RequestStoreModel {
  int id;
  String name;
  String slogan;
  XFile? banner;

  RequestStoreModel({
    required this.id,
    required this.name,
    required this.slogan,
    this.banner,
  });

  factory RequestStoreModel.fromEmpty() {
    return RequestStoreModel(id: 0, name: '', slogan: '', banner: null);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'slogan': slogan, 'banner': banner};
  }
}
