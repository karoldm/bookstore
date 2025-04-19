class RequestStoreModel {
  final int id;
  String name;
  String slogan;
  String? banner;

  RequestStoreModel({
    required this.id,
    required this.name,
    required this.slogan,
    this.banner,
  });

  Map<String, dynamic> toMap() {
    return {'name': name, 'slogan': slogan, 'banner': banner};
  }
}
