import 'package:bookstore/enums/role_enum.dart';

class UserModel {
  final int? id;
  final String name;
  final Role role;
  final String username;

  UserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.username,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      role: Role.fromString(json['role']),
      username: json['username'],
    );
  }

  factory UserModel.empty() {
    return UserModel(id: 0, name: '', role: Role.employee, username: '');
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, username: $username, role: $role)';
  }
}
