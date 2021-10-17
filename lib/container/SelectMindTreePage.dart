import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:prac_flutter/component/AppendNewMindTreeDialog.dart';
import 'package:prac_flutter/component/LogDialog.dart';
import 'package:prac_flutter/container/ViewMindTreePage.dart';
import 'package:prac_flutter/storage/MindTreeStorage.dart';
import 'package:prac_flutter/storage/platform/AppStorage.dart';
import 'package:prac_flutter/store/MindTreeListStore.dart';
import 'package:redux/redux.dart';

class SelectMindTreePage extends StatefulWidget {
  SelectMindTreePage({Key? key}) : super(key: key);

  @override
  _SelectMindTreePageState createState() => _SelectMindTreePageState();
}

class _SelectMindTreePageState extends State<SelectMindTreePage> {
  Store<MindTreeListState> _mindTreeListStateStore;

  _SelectMindTreePageState()
      : _mindTreeListStateStore = createMindTreeListStore() {
    _mindTreeListStateStore.onChange.listen((event) {
      setState(() {
        //
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _restoreFromStorage();
  }

  void _restoreFromStorage() {
    final storage = MindTreeStorage.instance;
    (() async {
      final list = await storage.loadAllIndex();
      _mindTreeListStateStore.dispatch(MindTreeListActionRestoreList(list));
    })();
  }

  void _addNewMindTree(String key, String title) {
    final storage = MindTreeStorage.instance;
    (() async {
      // NOTE: store new mindTree to redux and storage.
      _mindTreeListStateStore
          .dispatch(MindTreeListActionAdd.emplace(key, title));
      storage.create(key);
    })();
  }

  void _requestToAddNewMindTree(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            AppendNewMindTreeDialogWithState(onComplete: (title) {
              final key = title; // FIXME
              if (_mindTreeListStateStore.state.containKey(key)) {
                log('the key already exists');
                return;
              }
              _addNewMindTree(key, title);
            }).start(context));
  }

  void _requestToSelectMindTree(BuildContext context, String key) {
    // async
    Navigator.of(context).pushNamed('/mindTree/Edit',
        arguments: ViewMindTreePageArgument(mindTreeKey: key));
  }

  void _requestToDisplayStorageDump(BuildContext context) {
    (() async {
      final dumpData = await AppStorage.instance.dump();
      showDialog(
          context: context,
          builder: (BuildContext context) => LogDialogWithState(
                  title: 'dump/restore app storage as json',
                  onComplete: (String text) {
                    // NOTE: need to notify that it failed
                    AppStorage.instance.restoreFromDumped(text);
                    // update redux stores.
                    _restoreFromStorage();
                  },
                  initialText: dumpData)
              .start(context));
    })();
  }

  void _requestToEraseStorage(BuildContext context) {
    (() async {
      showDialog(
          context: context,
          builder: (BuildContext context) => LogDialogWithState(
                  title: 'Do you want to erase all data?',
                  readOnly: true,
                  onComplete: (String text) async {
                    await AppStorage.instance.eraseAll();
                    _restoreFromStorage();
                  },
                  initialText: '')
              .start(context));
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                _requestToDisplayStorageDump(context);
              },
              icon: Icon(Icons.outbox)),
          IconButton(
              onPressed: () {
                _requestToEraseStorage(context);
              },
              icon: Icon(Icons.delete_forever))
        ],
        title: Text("mindTree"),
      ),
      // scrollDirection: Axis.horizontal,
      body: ListView(
        children: _mindTreeListStateStore.state.list
            .map((e) => _buildMindTreeListElem(context, e))
            .toList(),
      ),
      floatingActionButton: IntrinsicWidth(
          child: Row(children: [
        FloatingActionButton(
          onPressed: () {
            _requestToAddNewMindTree(context);
          },
          tooltip: 'New mindTree',
          child: Icon(Icons.create_new_folder),
        ),
      ])),
    );
  }

  Widget _buildMindTreeListElem(
          BuildContext context, MindTreeListElemIndex elemIndex) =>
      OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.all(20),
        ),
        child: Text(elemIndex.title),
        onPressed: () {
          _requestToSelectMindTree(context, elemIndex.title);
        },
      );
}
