import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:meta/meta.dart';

import '../../data/cache/cache.dart';

class LocalStorageAdapter /*implements CacheStorage*/ /*implements SaveSecureCacheStorage, FeatchSecureCacheStorage*/ {
  final LocalStorage localStorage;

  LocalStorageAdapter({@required this.localStorage});
  // @override
  // Future<void> delete(String key) {
  //   // TODO: implement delete
  //   throw UnimplementedError();
  // }
  //
  // @override
  // Future fetch(String key) {
  //   // TODO: implement fetch
  //   throw UnimplementedError();
  // }

  @override
  Future<void> save({@required String key, @required dynamic value}) async {
    await localStorage.setItem(key, value);
  }
  // final FlutterSecureStorage secureStorage;
  //
  // LocalStorageAdapter({@required this.secureStorage});
  //
  // @override
  // Future<void> saveSecure({@required String key, @required String value}) async {
  //   await secureStorage.write(key: key, value: value);
  // }
  //
  // @override
  // Future<String> fetchSecure(String key) async {
  //   return secureStorage.read(key: key);
  // }
}