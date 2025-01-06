import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _secureStorage;

  SecureStorage(this._secureStorage);

  Future<List<int>> saveIntList(String key, List<int> values) {
    final encodedValues = jsonEncode(values);
    return _secureStorage.write(key: key, value: encodedValues).then((_) {
      return Future.value(values);
    });
  }

  Future<List<int>> getIntList(String key) {
    return _secureStorage.read(key: key).then((storedValue) {
      if (storedValue == null) {
        return [];
      }
      final decodedValues = jsonDecode(storedValue) as List<dynamic>;
      return decodedValues.map((e) => e as int).toList();
    });
  }

  Future<List<int>> addElementToList(String key, int value) {
    return getIntList(key).then((list) {
      list.add(value);
      return saveIntList(key, list);
    });
  }

  Future<List<int>> removeElementFromList(String key, int value) {
    return getIntList(key).then((list) {
      list.remove(value);
      return saveIntList(key, list);
    });
  }
}
