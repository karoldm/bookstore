import 'package:mybookstore/data/models/tokens_model.dart';
import 'package:mybookstore/data/models/user_model.dart';
import 'package:mybookstore/enums/role_enum.dart';

class SessionModel extends UserModel {
  int storeId;
  TokensModel tokens;

  SessionModel({
    required super.id,
    required super.name,
    required super.photo,
    required super.role,
    required this.storeId,
    required this.tokens,
  });

  @override
  String toString() {
    return 'UserSessionModel{id: $id, name: $name, photo: $photo, role: $role, storeId: $storeId}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'photo': photo,
      'role': role.toString(),
      'storeId': storeId,
      'tokens': tokens.toMap(),
    };
  }

  factory SessionModel.fromMap(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
      role: Role.fromString(json['role']),
      storeId: json['storeId'],
      tokens: TokensModel.fromMap(json['tokens']),
    );
  }
}
