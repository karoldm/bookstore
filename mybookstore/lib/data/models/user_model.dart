import 'dart:io';

import 'package:mybookstore/enums/role_enum.dart';

class UserModel {
  final String id;
  final String name;
  final String username;
  final File? photo;
  final Role? role;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    this.photo,
    this.role = Role.employee,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      photo: json['photo'] != null ? File(json['photo']) : null,
      role: Role.fromString(json['role']),
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, username: $username, photo: $photo, role: $role)';
  }
}
