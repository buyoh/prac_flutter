class MindTreeTreeData {
  int id;
  String label;
  List<MindTreeTreeData> _children;
  MindTreeTreeData(this.id, this.label)
      : _children = [];

  MindTreeTreeData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        label = json['label'],
        _children = (json['children'] as List<dynamic>)
            .map((j) => MindTreeTreeData.fromJson(j))
            .toList();

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'children': _children.map((e) => e),
  };

  // MindTreeData.clone(MindTreeData node):
  //     _label = node._label,
  //     _children = node._children.map((n) => MindTreeData.clone(n)).toList();
  //
  // MindTreeData _findNode(Iterable<int> path) {
  //   var me = this;
  //   for (int i in path) {
  //     if (i < 0 || me._children.length >= i)
  //       throw Error();
  //     me = me._children[i];
  //   }
  //   return me;
  // }
  //
  // void changeLabel(Iterable<int> path, String newLabel) {
  //   var node = _findNode(path);
  //   node._label = newLabel;
  // }
  //
  // void addChild(Iterable<int> path, String newLabel) {
  //   var node = _findNode(path);
  //   node._children.add(MindTreeData(newLabel));
  // }
  //
  // void removeNode(Iterable<int> path) {
  //   MindTreeData? last;
  //   int lastIndex = -1;
  //   var me = this;
  //   for (int i in path) {
  //     if (i < 0 || me._children.length >= i)
  //       throw Error();
  //     last = me;
  //     lastIndex = i;
  //     me = me._children[i];
  //   }
  //   if (last == null) throw Error();
  //   last._children.removeAt(lastIndex);
  // }

  List<MindTreeTreeData> get children => _children;
}
//
// class MindTreeListElem {
//   int _id;
//   int _parentId;
//   String _label;
//   MindTreeListElem(this._id, this._parentId, this._label);
// }
//
// class MindTreeListData {
//   int _lastId = 0;
//   static const int _rootId = 0;
//   Map<MindTreeListElem> _list = [];
//
//   MindTreeListData(String rootLabel):_list = [MindTreeListElem(_rootId, _rootId, rootLabel)];
//
//   void addElem(int )
//
//   MindTreeTreeData generate() {
//
//   }
//
// }
