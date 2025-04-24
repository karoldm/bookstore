import 'package:bookstore/enums/role_enum.dart';

class UserModel {
  final int id;
  final String name;
  final String? photo;
  final Role? role;

  UserModel({
    required this.id,
    required this.name,
    this.photo,
    this.role = Role.employee,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
      role: Role.fromString(json['role']),
    );
  }

  factory UserModel.empty() {
    return UserModel(id: 0, name: '', photo: null, role: Role.employee);
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, photo: $photo, role: $role)';
  }
}
