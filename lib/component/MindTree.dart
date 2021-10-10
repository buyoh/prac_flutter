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

@immutable
class MindTreeNode extends StatefulWidget {
  static final TextStyle textStyle = TextStyle(fontSize: 20);
  final MindTreeTreeData data;
  final int depth;
  final bool isTerminal;
  final bool isEditable;
  final void Function(int id, String label)? onRequestedToChangeNodeLabel;
  final void Function()? onPressed;
  final void Function()? onLongPress;

  MindTreeNode(this.data, this.depth,
      {bool? isTerminal,
      this.onPressed,
      this.onLongPress,
      required this.isEditable,
      required this.onRequestedToChangeNodeLabel})
      : this.isTerminal = isTerminal ?? false;

  @override
  _MindTreeNodeState createState() => _MindTreeNodeState();
}

class _MindTreeNodeState extends State<MindTreeNode> {
  final _textEditingController = TextEditingController();
  bool editing = false;

  Color get nodeColor =>
      widget.depth % 2 == 0 ? Colors.lightGreen : Colors.lightGreenAccent;

  @override
  Widget build(BuildContext context) =>
      editing ? _buildAsEditor(context) : _buildAsButton(context);

  @override
  void initState() {
    super.initState();

    _textEditingController.text = widget.data.label;
  }

  void _changeToEditor() {
    setState(() {
      editing = true;
    });
  }

  void _changeToButton() {
    setState(() {
      editing = false;
    });
  }

  void _onChangeNodeLabel() {
    final newLabel = _textEditingController.text;
    widget.onRequestedToChangeNodeLabel?.call(widget.data.id, newLabel);
    _changeToButton();
  }

  Widget _buildAsButton(BuildContext context) => OutlinedButton(
      style: ButtonStyle(
          // reset bold
          textStyle: MaterialStateProperty.all<TextStyle>(TextStyle()),
          // text color
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          backgroundColor: MaterialStateProperty.all<Color>(nodeColor)),
      onPressed: widget.isEditable
          ? () {
              _changeToEditor();
            }
          : widget.onPressed,
      onLongPress: widget.onLongPress,
      child: Container(
          alignment: Alignment.centerLeft,
          width: 200,
          height: widget.isTerminal ? 200 : double.infinity,
          child: Text(widget.data.label, style: MindTreeNode.textStyle)));

  Widget _buildAsEditor(BuildContext context) => Container(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      color: nodeColor,
      width: 216,
      height: widget.isTerminal ? 200 : double.infinity,
      alignment: Alignment.center,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextField(
            style: MindTreeNode.textStyle,
            controller: _textEditingController,
            autofocus: true,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onEditingComplete: _onChangeNodeLabel),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    primary: Colors.grey, backgroundColor: Colors.white),
                onPressed: _changeToButton,
                child: Icon(Icons.clear_rounded)),
            ElevatedButton(
                onPressed: _onChangeNodeLabel,
                child: Icon(Icons.check_circle_outline)),
          ],
        )
      ]));
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
        builder: (BuildContext context) => EditNodeDialogWithState(
            initialLabel: _data.label,
            onComplete: (String? label) {
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
    // log("${_children.length}  ${_data.label}");
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
              isEditable: true,
              isTerminal: _children.isEmpty,
              onLongPress: () => _editNode(context),
              onRequestedToChangeNodeLabel: (int id, String label) {
                _onRequestedToEditNode?.call(id, label);
              },
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
