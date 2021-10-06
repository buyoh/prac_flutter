import 'package:redux/redux.dart';

class MindTreeListElemIndex {
  String key;
  String title;

  MindTreeListElemIndex(this.key, this.title);

  Map<String, String> toMap() => {
        'key': key,
        'title': title,
      };
}

class MindTreeListState {
  final List<MindTreeListElemIndex> list;
  MindTreeListState({required this.list});

  MindTreeListState.initialState():
        this.list = [];

  bool containKey(String key) =>
    list.any ((element) => element.key == key);
}

class MindTreeListActionRestoreList {
  List<MindTreeListElemIndex> list;
  MindTreeListActionRestoreList(this.list);
}

class MindTreeListActionAdd {
  MindTreeListElemIndex elem;
  MindTreeListActionAdd(this.elem);
  MindTreeListActionAdd.emplace(String key, String title):
      this.elem = MindTreeListElemIndex(key, title);
}

MindTreeListState mindTreeListActionReducer(
    MindTreeListState state, dynamic action) {
  if (action is MindTreeListActionRestoreList) {
    return MindTreeListState(list: action.list);
  }
  if (action is MindTreeListActionAdd) {
    return MindTreeListState(list: [...state.list, action.elem]);
  }
  return state;
}

Store<MindTreeListState> createMindTreeListStore() {
  return Store<MindTreeListState>(
    mindTreeListActionReducer,
    initialState: MindTreeListState.initialState(),
    middleware: [],
  );
}
