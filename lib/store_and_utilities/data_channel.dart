import 'dart:async';
import 'store.dart';

class DataChannel<T> {
  final Store<T> _store;
  final String _key;
  final Future<T?> Function() _fetch;

  DataChannel(this._store, this._key, this._fetch);

  Future<T?> get() {
    final value = _store.get(_key);
    return Future.value(value);
  }

  Future<T?> getOrSync() {
    return _store.get(_key).then((value) {
      if (value != null) {
        return Future.value(value);
      }
      return sync();
    });
  }

  StreamController<T> getAndSync() {
    StreamController<T> streamController = StreamController<T>();
    _store.get(_key).then((value) {
      if (value != null) {
        streamController.add(value);
      }
      return _fetch().then((value) {
        if (value != null) {
          _store.set(_key, value);
          streamController.add(value);
        }
        streamController.close();
      }).catchError((error) {
        streamController.addError(error);
        streamController.close();
      });
    });
    return streamController;
  }

  Future<T?> sync() {
    return _fetch().then((value) {
      if (value != null) {
        _store.set(_key, value);
      }
      return value;
    });
  }

  StreamController<T?> getWithNullAndSync() {
    StreamController<T?> streamController = StreamController<T?>();
    _store.get(_key).then((T? value) {
      streamController.add(value);
      return _fetch().then((T? value) {
        if (value != null) {
          _store.set(_key, value);
        }
        streamController.add(value);
        streamController.close();
      }).catchError((dynamic error) {
        streamController.addError(error);
        streamController.close();
      });
    });
    return streamController;
  }
}

class ListDataChannel<T> extends DataChannel<List<T>> {
  ListDataChannel(ListStore<T> super.store, super.key, super.fetch);

  StreamController<List<T>> appendAndSync() {
    StreamController<List<T>> streamController = StreamController<List<T>>.broadcast();
    _store.get(_key).then((storedValue) {
      if (storedValue != null && storedValue.isNotEmpty) {
        streamController.add(storedValue);
      }
      _fetch().then((values) {
        return (_store as ListStore<T>).append(_key, values ?? []).then((combinedList) {
          streamController.add(combinedList);
          streamController.close();
        });
      }).catchError((error) {
        streamController.addError(error);
        streamController.close();
      });
    });
    return streamController;
  }
}
