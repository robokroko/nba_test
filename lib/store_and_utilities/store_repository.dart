import 'store.dart';

class StoreRepository {
  final List<Store<dynamic>> _stores;

  StoreRepository(this._stores);

  Future<void> clearAll() {
    return Future.wait(_stores.map((Store<dynamic> store) => store.clear())).then((_) {
      return;
    });
  }
}
