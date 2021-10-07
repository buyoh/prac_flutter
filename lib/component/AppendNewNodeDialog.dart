import 'package:flutter/material.dart';

class AppendNewNodeDialogWithState {
  final void Function(String) _onComplete;
  final TextEditingController _textEditingController;

  AppendNewNodeDialogWithState({required void Function(String) onComplete, String? initialLabel}) :
        _onComplete = onComplete,
        _textEditingController = TextEditingController(text: initialLabel);

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
