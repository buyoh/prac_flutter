import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:prac_flutter/component/AppendNewNodeDialog.dart';
import 'package:prac_flutter/component/EditNodeDialog.dart';

class MindTreeData {
  String _label;
  List<MindTreeData> _children;
  MindTreeData(String label)
      : _label = label,
        _children = [];
  String get label => _label;
  MindTreeData.fromJson(Map<String, dynamic> json)
      : _label = json['label'],
        _children = (json['children'] as List<dynamic>)
            .map((j) => MindTreeData.fromJson(j))
            .toList();

  Map<String, dynamic> toJson() => {
        'label': _label,
        'children': _children.map((e) => e),
      };
}

class AddButton extends StatelessWidget {
  final void Function() _onPressed;
  AddButton({required void Function() onPressed}) : _onPressed = onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(height: 60, width: 60),
        child: ElevatedButton(
          child: Text("ADD"),
          onPressed: _onPressed,
        ));
  }
}

class MindTreeNode extends StatelessWidget {
  static final TextStyle _textStyle = TextStyle(fontSize: 20);
  final MindTreeData _data;
  final int _depth;
  final bool _isTerminal;
  MindTreeNode(MindTreeData data, int depth, {bool? isTerminal})
      : _data = data,
        _depth = depth,
        _isTerminal = isTerminal ?? false;

  void _editNode(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            EditNodeDialogWithState(onComplete: (String? label) {
              log("edit=$label");
            }).start(context));
  }

  @override
  Widget build(BuildContext context) => OutlinedButton(
      style: ButtonStyle(
          // padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
          backgroundColor: MaterialStateProperty.all<Color>(_depth % 2 == 0 ? Colors.lightGreen : Colors.lightGreenAccent)
      ),
      onPressed: () {}, // TODO: toast suggest long press
      onLongPress: () => _editNode(context),
      child: Container(
          alignment: Alignment.centerLeft,
          // decoration: BoxDecoration(
          //   // border: Border.all(color: Colors.black12),
          //   // color: Colors.lightGreen,
          // ),
          width: 200,
          height: _isTerminal ? 200 : double.infinity,
          child: Text(_data.label, style: _textStyle)));
}

class MindTree extends StatelessWidget {
  final MindTreeData _data;
  final List<MindTree> _children;
  final int _depth;
  MindTree(MindTreeData data, int depth)
      : _data = data,
        _depth = depth,
        _children =
            data._children.map((ch) => MindTree(ch, depth + 1)).toList();

  void _appendNewNode(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            AppendNewNodeDialogWithState(onComplete: (String label) {
              log("label=$label");
            }).start(context));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        child: IntrinsicHeight(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, //
          mainAxisSize: MainAxisSize.min,
          children: [
            MindTreeNode(
              _data,
              _depth,
              isTerminal: _children.isEmpty,
            ),
            IntrinsicWidth(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  ..._children,
                  AddButton(
                    onPressed: () => _appendNewNode(context),
                  )
                ]))
          ],
        )));
  }
}
