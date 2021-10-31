import 'package:localstorage/localstorage.dart';
import 'package:meta/meta.dart';

import '../../data/cache/cache.dart';

class LocalStorageAdapter /*implements CacheStorage*/ {
  final LocalStorage localStorage;

  LocalStorageAdapter({@required this.localStorage});

  @override
  Future<void> save({@required String key, @required dynamic value}) async {
    await localStorage.deleteItem(key);

    await localStorage.setItem(key, value);
  }

  @override
  Future<void> delete(String key) async {
    await localStorage.deleteItem(key);
  }

  //
  // @override
  // Future fetch(String key) {
  //   // TODO: implement fetch
  //   throw UnimplementedError();
  // }
}