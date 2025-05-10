abstract class LocalServiceInterface {
  Future<void> writeMap({
    required String key,
    required Map<String, dynamic> value,
  });

  Future<Map<String, dynamic>?> readMap(String key);

  Future<void> delete(String key);

  Future<void> clear();

  Future<String?> read(String key);

  Future<void> write({required String key, required String value});
}
