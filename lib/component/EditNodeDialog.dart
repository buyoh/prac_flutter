import 'package:flutter/material.dart';

class EditNodeDialogWithState {
  final void Function(String?) _onComplete;
  final TextEditingController _textEditingController = TextEditingController();

  EditNodeDialogWithState({required void Function(String?) onComplete})
      : _onComplete = onComplete;

  AlertDialog start(BuildContext context) => AlertDialog(
          title: Text('Edit a node'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: 'label',
              ),
              autofocus: true,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              // onSubmitted: (String text) {
              //   Navigator.of(context).pop();
              //   _onComplete(text);
              // },
            ),
          ]),
          actions: [
            // workaround...
            Row(children: [
              ElevatedButton(
                  child: Text('Delete'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _onComplete(null);
                  }),
              Expanded(child: Container()),
              TextButton(
                  child: Text('cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              ElevatedButton(
                  child: Text('Change'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _onComplete(_textEditingController.value.text);
                  })
            ]),
          ]);
}
