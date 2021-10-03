import 'package:flutter/material.dart';

class AppendNewNodeDialogWithState {
  final void Function(String) _onComplete;
  final TextEditingController _textEditingController = TextEditingController();

  AppendNewNodeDialogWithState({required void Function(String) onComplete}) :
        _onComplete = onComplete;

  AlertDialog start(BuildContext context) => AlertDialog(
      title: Text('Add a new node'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: _textEditingController,
          decoration: InputDecoration(
            hintText: 'label',
          ),
          autofocus: true,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          onSubmitted: (String text) {
            Navigator.of(context).pop();
            _onComplete(text);
          },
        ),
      ]),
      actions: [
        TextButton(
            child: Text('cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        ElevatedButton(
            child: Text('Add'),
            onPressed: () {
              Navigator.of(context).pop();
              _onComplete(_textEditingController.value.text);
            }),
      ]);
}
