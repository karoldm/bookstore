import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mybookstore/interfaces/repositories/local_repository_interface.dart';

class LocalRepository implements LocalRepositoryInterface {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<String?> read(String key) async => await _storage.read(key: key);

  @override
  Future<void> write({required String key, required String value}) async =>
      await _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) async => await _storage.delete(key: key);

  @override
  Future<Map<String, dynamic>?> readMap(String key) async {
    final jsonString = await read(key);
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return null;
  }

  @override
  Future<void> writeMap({
    required String key,
    required Map<String, dynamic> value,
  }) async {
    final jsonString = json.encode(value);
    await write(key: key, value: jsonString);
  }

  @override
  Future<void> clear() async => await _storage.deleteAll();
}
