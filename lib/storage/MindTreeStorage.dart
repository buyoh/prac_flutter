import 'dart:convert';
import 'package:prac_flutter/store/MindTreeListStore.dart';
import 'package:prac_flutter/store/MindTreeStore.dart';
import 'platform/AppStorage.dart';

class MindTreeStorage {
  static const _versionPrefix = "v0";
  static const _storagePrefix = "mindTreeData-$_versionPrefix-";
  static MindTreeStorage? _instance;

  static MindTreeStorage get instance {
    if (_instance == null) _instance = MindTreeStorage._();
    return _instance!;
  }

  MindTreeStorage._();

  static const _storageIdentifierList = '$_storagePrefix-list';
  // static const _storageIdentifierDefault = '$_storagePrefix-default';

  Future<void> create(String key) async {
    store(key, MindTreeState.initialState());
  }

  Future<void> store(String key, MindTreeState state) async {
    final storage = AppStorage.instance;
    final listRaw = await storage.load(_storageIdentifierList);
    final map =
        listRaw != null ? json.decode(listRaw) as Map<String, dynamic> : {};

    // NOTE: use list<String>
    // use map as index + use list as store
    map[key] = {'key': key, 'title': key, 'state': state.generateListJson()};  // FIXME
    storage.store(_storageIdentifierList, json.encode(map));
  }

  Future<MindTreeState?> load(String key) async {
    final storage = AppStorage.instance;
    final listRaw = await storage.load(_storageIdentifierList);
    final map =
    listRaw != null ? json.decode(listRaw) as Map<String, dynamic> : {};

    if (!map.containsKey(key)) return null;
    final elem = map[key] as Map<String, dynamic>;
    final stateRaw = elem['state'] as Map<String, dynamic>;

    return MindTreeState.fromListJson(stateRaw);
  }

  Future<List<MindTreeListElemIndex>> loadAllIndex() async {
    final storage = AppStorage.instance;
    final listRaw = await storage.load(_storageIdentifierList);
    final map =
        listRaw != null ? json.decode(listRaw) as Map<String, dynamic> : {};

    return map.entries
        .map((e) => MindTreeListElemIndex(
            e.key, (e.value as Map<String, dynamic>)['title'] as String))
        .toList();
  }

  // Future<void> storeDefault(MindTreeState state) async {
  //   final storage = AppStorage.instance;
  //   final data = state.generateListJson();
  //   storage.store(_storageIdentifierDefault, json.encode(data));
  // }
  //
  // Future<MindTreeState> loadDefault() async {
  //   final storage = AppStorage.instance;
  //   final t = await storage.load(_storageIdentifierDefault);
  //   if (t == null) return MindTreeState.initialState();
  //   return MindTreeState.fromListJson(json.decode(t));
  // }


}
