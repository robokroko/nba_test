import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class Store<T> {
  Future<T> set(String key, T value);
  Future<T?> get(String key);
  Future<T?> delete(String key);
  Future<List<String>> keys();
  Future<bool> includes(String key);
  Future<void> clear();
}

class StoreWithConsoleLog<T> extends Store<T> {
  final Store<T> store;
  final String identifier;

  StoreWithConsoleLog(this.store, this.identifier);

  @override
  Future<void> clear() {
    debugPrint('[$identifier]: clear');
    return store.clear();
  }

  @override
  Future<T?> delete(String key) {
    debugPrint('[$identifier]: delete $key');
    return store.delete(key);
  }

  @override
  Future<T?> get(String key) {
    debugPrint('[$identifier]: get $key');
    return store.get(key);
  }

  @override
  Future<bool> includes(String key) {
    debugPrint('[$identifier]: includes $key');
    return store.includes(key);
  }

  @override
  Future<List<String>> keys() {
    debugPrint('[$identifier]: keys');
    return store.keys();
  }

  @override
  Future<T> set(String key, dynamic value) {
    debugPrint('[$identifier]: set $key');
    return store.set(key, value);
  }
}

class StoreWithDuration<T> extends Store<T> {
  final Store<T> store;
  final int durationInSecond;
  final Map<String, int> timestamps;

  StoreWithDuration(this.durationInSecond, this.store) : timestamps = <String, int>{};

  @override
  Future<T> set(String key, T value) {
    timestamps[key] = DateTime.now().second;
    return store.set(key, value);
  }

  @override
  Future<T?> get(String key) {
    final int? timestamp = timestamps[key];
    if (timestamp == null) {
      return Future<T?>.value(null);
    }
    if (durationInSecond < DateTime.now().second - timestamp) {
      delete(key);
      return Future<T?>.value(null);
    }
    return store.get(key);
  }

  @override
  Future<T?> delete(String key) {
    timestamps.remove(key);
    return store.delete(key);
  }

  @override
  Future<List<String>> keys() => store.keys();

  @override
  Future<bool> includes(String key) => store.includes(key);

  @override
  Future<void> clear() {
    return store.clear();
  }
}

class MasterSlaveStore<T> extends Store<T> {
  final Store<T> master;
  final Store<T> secondary;

  MasterSlaveStore(this.master, this.secondary);

  @override
  Future<void> clear() {
    return Future.wait([master.clear(), secondary.clear()]);
  }

  @override
  Future<T?> delete(String key) {
    return this.master.delete(key).then((_) => this.secondary.delete(key));
  }

  @override
  Future<T?> get(String key) {
    return this.master.get(key).then((value) {
      if (value != null) {
        return value;
      }
      return this.secondary.get(key).then((value) {
        if (value == null) {
          return null;
        }
        return this.master.set(key, value);
      });
    });
  }

  @override
  Future<bool> includes(String key) {
    return this.master.includes(key).then((included) {
      if (included) {
        return included;
      }
      return this.secondary.includes(key).then((included) {
        if (!included) {
          return false;
        }
        return this.secondary.get(key).then((value) {
          if (value == null) {
            return false;
          }
          return this.master.set(key, value).then((_) => true);
        });
      });
    });
  }

  @override
  Future<List<String>> keys() {
    return this.master.keys().then((masterKeys) {
      return this.secondary.keys().then((secondaryKeys) {
        final keys = <String>{};
        keys.addAll(masterKeys);
        keys.addAll(secondaryKeys);
        return keys.toList();
      });
    });
  }

  @override
  Future<T> set(String key, T value) {
    return this.master.set(key, value).then((_) => this.secondary.set(key, value));
  }
}

class MemoryStore<T> extends Store<T> {
  final Map<String, T> values;

  MemoryStore(this.values);

  @override
  Future<void> clear() {
    values.clear();
    return Future<void>.value();
  }

  @override
  Future<T?> delete(String key) => Future<T?>.value(values.remove(key));

  @override
  Future<T?> get(String key) => Future<T?>.value(values[key]);

  @override
  Future<bool> includes(String key) => Future<bool>.value(values.containsKey(key));

  @override
  Future<List<String>> keys() => Future<List<String>>.value(values.keys.toList());

  @override
  Future<T> set(String key, T value) =>
      Future<T>.value(values.update(key, (T storedValue) => value, ifAbsent: () => value));
}

class IOStore extends Store<Uint8List> {
  final Directory directory;

  IOStore(this.directory);

  @override
  Future<void> clear() {
    return directory.delete(recursive: true).then((_) {
      return;
    });
  }

  @override
  Future<Uint8List?> delete(String key) {
    File file = _getFile(key);
    return file.delete(recursive: false).then((_) {
      return;
    });
  }

  @override
  Future<Uint8List?> get(String key) {
    final file = _getFile(key);
    if (!file.existsSync()) {
      return Future.value(null);
    }

    final asByte = file.readAsBytesSync();
    return Future.value(asByte);
  }

  @override
  Future<bool> includes(String key) {
    return _getFile(key).exists();
  }

  @override
  Future<List<String>> keys() {
    return Future.sync(() {
      if (!directory.existsSync()) {
        return <String>[];
      }

      final files = directory.listSync().whereType<File>();
      return files.map((file) => file.uri.pathSegments.last.split('.').first).toList();
    });
  }

  @override
  Future<Uint8List> set(String key, Uint8List value) {
    File? file = _getFile(key);
    return file.writeAsBytes(value).then((file) => value);
  }

  String _getPath(String key) => '${directory.path}${Platform.pathSeparator}$key.bin';
  File _getFile(String key) => File(_getPath(key));
}

class FileStore extends Store<File> {
  final Directory directory;

  FileStore(this.directory);

  @override
  Future<void> clear() {
    return directory.delete(recursive: true).then((_) {
      return;
    });
  }

  @override
  Future<File?> delete(String key) {
    File file = _getFile(key);
    return file.delete(recursive: false).then((_) {
      return;
    });
  }

  @override
  Future<File?> get(String key) {
    final file = _getFile(key);
    if (!file.existsSync()) {
      return Future.value(null);
    }

    return Future.value(file);
  }

  @override
  Future<bool> includes(String key) {
    return _getFile(key).exists();
  }

  @override
  Future<List<String>> keys() {
    return Future.sync(() {
      if (!directory.existsSync()) {
        return <String>[];
      }

      final files = directory.listSync().whereType<File>();
      return files.map((file) => file.uri.pathSegments.last.split('.').first).toList();
    });
  }

  @override
  Future<File> set(String key, File value) {
    File? file = _getFile(key);
    debugPrint('[Path]: ${file.path}');

    return value.readAsBytes().then((asBytes) => file.writeAsBytes(asBytes));
  }

  String _getPath(String key) => '${directory.path}${Platform.pathSeparator}$key.bin';
  File _getFile(String key) => File(_getPath(key));
}

abstract class ListStore<T> extends Store<List<T>> {
  Future<List<T>> append(String key, List<T> items);
}

class MemoryListStore<T> extends ListStore<T> {
  final Map<String, List<T>> values;

  MemoryListStore(this.values);

  @override
  Future<List<T>> set(String key, List<T> value) =>
      Future.value(values.update(key, (storedValue) => value, ifAbsent: () => value));

  @override
  Future<List<T>?> get(String key) => Future.value(values[key]);

  @override
  Future<List<String>> keys() => Future.value(values.keys.toList());

  @override
  Future<List<T>?> delete(String key) => Future.value(values.remove(key));

  @override
  Future<bool> includes(String key) => Future.value(values.containsKey(key));

  @override
  Future<void> clear() {
    values.clear();
    return Future.value();
  }

  @override
  Future<List<T>> append(String key, List<T> items) {
    return Future.value(values.update(key, (List<T> storedValues) {
      storedValues.addAll(items);
      return storedValues;
    }, ifAbsent: () => items));
  }
}

class FlutterSecureStorageStore<T> extends Store<T> {
  final FlutterSecureStorage _secureStorage;
  final T Function(Map<String, dynamic>) _parse;

  FlutterSecureStorageStore(this._secureStorage, this._parse);

  @override
  Future<void> clear() {
    return _secureStorage.deleteAll();
  }

  @override
  Future<T?> delete(String key) {
    return _secureStorage.read(key: key).then((storedValue) {
      if (storedValue == null) {
        return Future.value(null);
      }
      final value = _parse(jsonDecode(storedValue));
      return _secureStorage.delete(key: key).then((_) => value);
    });
  }

  @override
  Future<T?> get(String key) {
    return _secureStorage.read(key: key).then((storedValue) {
      if (storedValue == null) {
        return Future.value(null);
      }
      final value = _parse(jsonDecode(storedValue));
      return Future.value(value);
    });
  }

  @override
  Future<List<String>> keys() {
    return _secureStorage.readAll().then((entries) => entries.keys.toList());
  }

  @override
  Future<bool> includes(String key) {
    return _secureStorage.containsKey(key: key);
  }

  @override
  Future<T> set(String key, T value) {
    return _secureStorage.write(key: key, value: jsonEncode(value)).then((_) => value);
  }
}
