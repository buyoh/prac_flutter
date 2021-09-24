import 'dart:math';

import 'package:flutter/material.dart';

class MindTreeData {
  late String _label;
  late List<MindTreeData> _children;
  MindTreeData(String label):
    _label = label,
    _children = [];
    String get label => _label;
  MindTreeData.fromJson(Map<String, dynamic> json):
  _label = json['label'],
  _children = (json['children'] as List<dynamic>).map((j) => MindTreeData.fromJson(j)).toList();

  Map<String, dynamic> toJson() => {
    'label': _label,
    'children': _children.map((e) => e),
  };
}

class MindTree extends StatelessWidget {
  late MindTreeData _data;
  late List<MindTree> _childlen;
  int _depth = 0;
  MindTree(MindTreeData data, int depth) {
    _data = data;
    _depth = depth;
    _childlen = data._children.map((ch) => MindTree(ch, depth + 1)).toList();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Container(color: _depth % 2 == 0 ? Colors.red : Colors.blue, width: 400, height: 300, child:
            Text(
              _data.label,
            )), Column(
        children: _childlen,
      )],
    );
  }
}