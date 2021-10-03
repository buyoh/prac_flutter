// import 'package:flutter_flux/flutter_flux.dart';
import 'dart:developer';
import 'dart:math' as math;

import 'package:redux/redux.dart';

class MindTreeListElem {
  int id;
  int parentId;
  String label;

  MindTreeListElem(this.id, this.parentId, this.label);

  get isRoot => id == parentId;

  Map<String, dynamic> generateListElemJson() => {
    'id': id,
    'parentId': parentId,
    'text': label,
  };
  // TODO: validation
  MindTreeListElem.fromListElemJson(Map<String, dynamic> json):
    id=json['id'],
  parentId=json['parentId'],
  label=json['text'];
}

class MindTreeState {
  late int nextId;
  late int rootId;
  List<MindTreeListElem> list;

  MindTreeState(this.nextId, this.rootId, this.list);

  MindTreeState.initialState()
      : nextId = 1,
        rootId = 0,
        list = [MindTreeListElem(0, 0, 'root')];

  Map<String, dynamic> generateTreeJson() {
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

  Map<String, dynamic> generateListJson() => {
    'rootId': rootId,
    'nodes': list.map((e) => e.generateListElemJson()).toList()
  };

  MindTreeState.fromListJson(Map<String, dynamic> json):
      list = (json['nodes'] as List<dynamic>).map((e) => MindTreeListElem.fromListElemJson(e)).toList() {
    nextId = 0;
    rootId = -1;
    for (MindTreeListElem e in list) {
      if (e.parentId == e.id) rootId = e.id;
      nextId = math.max(nextId, e.id);
    }
    nextId += 1;
    if (rootId < 0) {
      log('root doesnt exist');
      throw Error();
    }
    // TODO: validation
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

class MindTreeActionReplace {
  Map<String, dynamic> json;

  MindTreeActionReplace(this.json);
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

  if (action is MindTreeActionReplace) {
    return MindTreeState.fromListJson(action.json);
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
