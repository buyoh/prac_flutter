import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:prac_flutter/component/AppendNewNodeDialog.dart';
import 'package:prac_flutter/component/EditNodeDialog.dart';
import 'package:prac_flutter/type/MindTreeData.dart';

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
  final MindTreeTreeData _data;
  final int _depth;
  final bool _isTerminal;
  final void Function()? _onPressed;
  final void Function()? _onLongPress;

  MindTreeNode(this._data, this._depth,
      {bool? isTerminal,
      void Function()? onPressed,
      void Function()? onLongPress})
      : _isTerminal = isTerminal ?? false,
        _onPressed = onPressed,
        _onLongPress = onLongPress;

  @override
  Widget build(BuildContext context) => OutlinedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              _depth % 2 == 0 ? Colors.lightGreen : Colors.lightGreenAccent)),
      onPressed: _onPressed,
      onLongPress: _onLongPress,
      child: Container(
          alignment: Alignment.centerLeft,
          width: 200,
          height: _isTerminal ? 200 : double.infinity,
          child: Text(_data.label, style: _textStyle)));
}

class MindTree extends StatelessWidget {
  final MindTreeTreeData _data;
  final List<MindTree> _children;
  final int _depth;
  final void Function(int id, String label)? _onRequestedToEditNode;
  final void Function(int parentId, String label)? _onRequestedToAddNewNode;
  final void Function(int id)? _onRequestedToRemoveNode;

  MindTree(
    MindTreeTreeData data,
    int depth, {
    required void Function(int id, String label)? onRequestedToEditNode,
    required void Function(int parentId, String label)? onRequestedToAddNewNode,
    required void Function(int id)? onRequestedToRemoveNode,
  })  : _data = data,
        _depth = depth,
        _children = data.children
            .map((ch) => MindTree(ch, depth + 1,
                onRequestedToEditNode: onRequestedToEditNode,
                onRequestedToAddNewNode: onRequestedToAddNewNode,
                onRequestedToRemoveNode: onRequestedToRemoveNode))
            .toList(),
        _onRequestedToEditNode = onRequestedToEditNode,
        _onRequestedToAddNewNode = onRequestedToAddNewNode,
        _onRequestedToRemoveNode = onRequestedToRemoveNode;

  void _appendNewNode(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            AppendNewNodeDialogWithState(onComplete: (String label) {
              log("label=$label");
              _onRequestedToAddNewNode?.call(_data.id, label);
            }).start(context));
  }

  void _editNode(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            EditNodeDialogWithState(initialLabel: _data.label, onComplete: (String? label) {
              if (label == null) {
                log("remove");
                _onRequestedToRemoveNode?.call(_data.id);
                return;
              }
              log("edit=$label");
              _onRequestedToEditNode?.call(_data.id, label);
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
              onLongPress: () => _editNode(context),
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
