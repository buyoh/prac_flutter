import 'package:flutter/material.dart';

class AppendNewMindTreeDialogWithState {
  final void Function(String) _onComplete;
  final TextEditingController _textEditingController = TextEditingController();

  AppendNewMindTreeDialogWithState({required void Function(String) onComplete}) :
        _onComplete = onComplete;

  AlertDialog start(BuildContext context) => AlertDialog(
      title: Text('Create a new mindTree'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: _textEditingController,
          decoration: InputDecoration(
            hintText: 'title',
          ),
          autofocus: true,
          keyboardType: TextInputType.text,
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
