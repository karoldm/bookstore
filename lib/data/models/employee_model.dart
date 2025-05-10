import 'package:bookstore/enums/role_enum.dart';

class EmployeeModel {
  final int id;
  final String name;
  final String username;
  final Role role;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.username,
    this.role = Role.employee,
  });

  factory EmployeeModel.fromMap(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      role: Role.fromString(json['role']),
    );
  }
}
