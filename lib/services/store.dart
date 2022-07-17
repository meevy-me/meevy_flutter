import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:soul_date/objectbox.g.dart';

import '../models/chat_model.dart';

class LocalStore {
  Store store;

  LocalStore._init(this.store);
  // Future<Store> initStore() async {
  //   store = await openStore();
  //   return store;
  // }
  static Future<LocalStore> init() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    final stored = await openStore(directory: docDir.path + '/chatop');
    return LocalStore._init(stored);
  }

  Future<T?> query<T>(int id) async {
    var box = store.box<T>();
    return box.get(id);
  }

  Future<List<T>> list<T>() async {
    var box = store.box<T>();
    return box.getAll();
  }

  Future<int> insert<T>(T value) async {
    var box = store.box<T>();
    return box.put(value);
  }

  Future<List<int>> insertList<T>(List<T> items) async {
    // items.forEach((element) {
    //   element as Chat;
    //   print(element.friends.target);
    // });
    var box = store.box<T>();
    return box.putMany(items, mode: PutMode.put);
  }
}
