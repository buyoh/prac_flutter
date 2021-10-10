import 'package:flutter/material.dart';

class LogDialogWithState {
  final String  _title;
  final bool _readOnly;
  final void Function(String) _onComplete;
  final TextEditingController _textEditingController;

  LogDialogWithState({required String title, bool? readOnly, required void Function(String) onComplete, String? initialText}) :
        _title = title,
        _readOnly = readOnly ?? false,
        _onComplete = onComplete,
        _textEditingController = TextEditingController(text: initialText);

  AlertDialog start(BuildContext context) => AlertDialog(
      title: Text(_title),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: _textEditingController,
          readOnly: _readOnly,
          maxLines: null,
          keyboardType: TextInputType.multiline,
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
            child: Text('ok'),
            onPressed: () {
              Navigator.of(context).pop();
              _onComplete(_textEditingController.value.text);
            }),
      ]);
}
