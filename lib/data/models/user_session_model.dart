import 'package:bookstore/data/models/tokens_model.dart';
import 'package:bookstore/data/models/user_model.dart';
import 'package:bookstore/enums/role_enum.dart';

class SessionModel extends UserModel {
  int storeId;
  TokensModel tokens;

  SessionModel({
    required super.id,
    required super.name,
    required super.role,
    required super.username,
    required this.storeId,
    required this.tokens,
  });

  @override
  String toString() {
    return 'UserSessionModel{id: $id, name: $name, username: $username, role: $role, storeId: $storeId}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'role': role.toString(),
      'storeId': storeId,
      'tokens': tokens.toMap(),
    };
  }

  factory SessionModel.fromMap(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      role: Role.fromString(json['role']),
      storeId: json['storeId'],
      tokens: TokensModel.fromMap(json['tokens']),
    );
  }
}
