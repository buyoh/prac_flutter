import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:prac_flutter/storage/AppStorage.dart';
import 'package:prac_flutter/store/MindTreeStore.dart';
import 'package:prac_flutter/type/MindTreeData.dart';
import 'package:redux/redux.dart';

import 'package:prac_flutter/component/MindTree.dart';
import 'package:prac_flutter/store/store.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _title = "/";
  Store<DisplayedPageState> _displayedPageStore;
  Store<MindTreeState> _mindTreeState;

  bool _needBackup = false;
  Timer? _backupTimer;

  _MyHomePageState()
      : _displayedPageStore = createDisplayedPageStore(),
        _mindTreeState = createMindTreeStore() {
    _applyFromDisplayedPageStore();
    _displayedPageStore.onChange.listen((event) {
      setState(() {
        _applyFromDisplayedPageStore();
      });
    });
    _mindTreeState.onChange.listen((event) {
      setState(() {
        _applyFromDisplayedPageStore();
      });
    });
  }

  void _applyFromDisplayedPageStore() {
    _title = _displayedPageStore.state.title;
    _needBackup = true;
  }

  @override
  void initState() {
    super.initState();
    _backupTimer = Timer.periodic(
        Duration(seconds: 10),
        (Timer timer) {
          if (_backupTimer == null) {
            // may not occur
            timer.cancel();
            return;
          }
          _processBackupInterval();
        }
    );
    _restoreStateFromAppStorage();
  }

  @override
  void dispose() {
    super.dispose();
    _backupTimer?.cancel();
    _backupTimer = null;
    _storeStateToAppStorage();
  }

  void _processBackupInterval() {
    if (_needBackup)
      _storeStateToAppStorage();
  }

  void _incrementCounter() {
    // TODO: example
    _displayedPageStore.dispatch(DisplayedPageAction.updateTitle('foobar'));
  }

  void _storeStateToAppStorage() {
    final data = _mindTreeState.state.generateListJson();
    _needBackup = false;
    (() async {
      final storage = AppStorage.getInstance();
      storage.store('mindTreeData-default', json.encode(data));
      log('store complete');
    })();
  }

  void _restoreStateFromAppStorage() {
    (() async {
      final storage = AppStorage.getInstance();
      final t = await storage.load('mindTreeData-default');
      if (t == null) return;
      _mindTreeState.dispatch(MindTreeActionReplace(json.decode(t)));
      log('restore complete');
    })();
  }

  @override
  Widget build(BuildContext context) {
    var mindTreeData =
        MindTreeTreeData.fromJson(_mindTreeState.state.generateTreeJson());
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title + " - " + _title),
      ),
      // scrollDirection: Axis.horizontal,
      body: InteractiveViewer(
        constrained: false,
        child: MindTree(
          mindTreeData,
          0,
          onRequestedToAddNewNode: (int parentId, String label) {
            _mindTreeState.dispatch(MindTreeActionAddNode(parentId, label));
          },
          onRequestedToRemoveNode: (int id) {
            _mindTreeState.dispatch(MindTreeActionRemoveNode(id));
          },
          onRequestedToEditNode: (int id, String label) {
            _mindTreeState.dispatch(MindTreeActionChangeLabel(id, label));
          },
        ),
      ),
      floatingActionButton: IntrinsicWidth(
          child: Row(children: [
        FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
        // FloatingActionButton(
        //   onPressed: _storeStateToAppStorage,
        //   tooltip: 'save',
        //   child: Icon(Icons.save),
        // ),
        // FloatingActionButton(
        //   onPressed: _restoreStateFromAppStorage,
        //   tooltip: 'open',
        //   child: Icon(Icons.folder_open),
        // ),
      ])),
    );
  }
}
