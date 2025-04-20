class EmployeeModel {
  final int id;
  final String name;
  final String username;
  final String? photo;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.username,
    this.photo,
  });

  factory EmployeeModel.fromMap(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      photo: json['photo'],
    );
  }
}
