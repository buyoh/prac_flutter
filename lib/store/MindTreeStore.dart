// import 'package:flutter_flux/flutter_flux.dart';
import 'dart:developer';

import 'package:redux/redux.dart';

class MindTreeListElem {
  int id;
  int parentId;
  String label;

  MindTreeListElem(this.id, this.parentId, this.label);

  get isRoot => id == parentId;
}

class MindTreeState {
  int nextId;
  int rootId;
  List<MindTreeListElem> list;

  MindTreeState(this.nextId, this.rootId, this.list);

  MindTreeState.initialState()
      : nextId = 1,
        rootId = 0,
        list = [MindTreeListElem(0, 0, 'root')];

  Map<String, dynamic> generate() {
    Map<int, int> id2index = {};
    Map<int, List<int>> children = {};
    for (var elem in list) {
      int i = id2index.length;
      if (id2index.containsKey(i)) {
        log('id:${elem.id} node is duplicated!');
        continue;
      }
      id2index[elem.id] = i;

      if (!elem.isRoot) {
        children[elem.parentId] ??= [];
        children[elem.parentId]!.add(elem.id);
      }
    }

    var dfs = (int id, Function dfs) {
      MindTreeListElem elem = list[id2index[id]!];
      Map<String, dynamic> json = {};
      json['id'] = elem.id;
      json['label'] = elem.label;
      json['children'] = children[id] == null
          ? []
          : children[id]!.map((c) => dfs(c, dfs)).toList();
      return json;
    };
    return dfs(rootId, dfs);
  }
}

class MindTreeActionAddNode {
  int parentId;
  String label;

  MindTreeActionAddNode(this.parentId, this.label);
}

class MindTreeActionChangeLabel {
  int targetId;
  String label;

  MindTreeActionChangeLabel(this.targetId, this.label);
}

class MindTreeActionRemoveNode {
  int targetId;

  MindTreeActionRemoveNode(this.targetId);
}

MindTreeState mindTreeActionReducer(MindTreeState state, dynamic action) {
  if (action is MindTreeActionAddNode) {
    int newId = state.nextId;
    return MindTreeState(state.nextId + 1, state.rootId, [
      ...state.list,
      MindTreeListElem(newId, action.parentId, action.label)
    ]);
  }
  if (action is MindTreeActionChangeLabel) {
    return MindTreeState(
        state.nextId,
        state.rootId,
        state.list
            .map((e) => e.id != action.targetId
                ? e
                : MindTreeListElem(e.id, e.parentId, action.label))
            .toList());
  }
  if (action is MindTreeActionRemoveNode) {
    if (action.targetId == state.rootId) {
      log('not implemented: cannot remove root');
      // throw Error();
      return state;
    }
    if (!state.list.any((e) => e.parentId != action.targetId)) {
      log('not implemented: cannot remove node has children');
      // throw Error();
      return state;
    }
    return MindTreeState(state.nextId, state.rootId,
        state.list.where((e) => e.id != action.targetId).toList());
  }
  return state;
}

Store<MindTreeState> createMindTreeStore() {
  return Store<MindTreeState>(
    mindTreeActionReducer,
    initialState: MindTreeState.initialState(),
    middleware: [],
  );
}
