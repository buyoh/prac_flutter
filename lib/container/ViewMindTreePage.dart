import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:prac_flutter/storage/MindTreeStorage.dart';
import 'package:prac_flutter/store/MindTreeStore.dart';
import 'package:prac_flutter/type/MindTreeData.dart';
import 'package:redux/redux.dart';

import 'package:prac_flutter/component/MindTree.dart';
import 'package:prac_flutter/store/ViewMindTreePageStore.dart';

@immutable
class ViewMindTreePageArgument {
  final String? mindTreeKey;

  ViewMindTreePageArgument({this.mindTreeKey});

  ViewMindTreePageArgument.empty() : this.mindTreeKey = null;
}

class ViewMindTreePage extends StatefulWidget {
  final ViewMindTreePageArgument arguments;

  ViewMindTreePage({Key? key, Object? arguments})
      : this.arguments = arguments is ViewMindTreePageArgument
            ? arguments
            : ViewMindTreePageArgument.empty(),
        super(key: key);

  @override
  _ViewMindTreePageState createState() =>
      _ViewMindTreePageState(arguments.mindTreeKey);
}

class _ViewMindTreePageState extends State<ViewMindTreePage> {
  final String? _mindTreeKey;
  Store<DisplayedPageState> _displayedPageStore;
  Store<MindTreeState> _mindTreeStateStore;

  bool _needBackup = false;
  Timer? _backupTimer;

  _ViewMindTreePageState(this._mindTreeKey)
      : _displayedPageStore = createDisplayedPageStore(),
        _mindTreeStateStore = createMindTreeStore() {
    _applyFromDisplayedPageStore();
    _displayedPageStore.onChange.listen((event) {
      setState(() {
        _applyFromDisplayedPageStore();
      });
    });
    _mindTreeStateStore.onChange.listen((event) {
      setState(() {
        _applyFromDisplayedPageStore();
      });
    });
  }

  void _applyFromDisplayedPageStore() {
    // _title = _displayedPageStore.state.title;
    _needBackup = true;
  }

  @override
  void initState() {
    super.initState();

    _backupTimer = Timer.periodic(Duration(seconds: 10), (Timer timer) {
      if (_backupTimer == null) {
        // may not occur
        timer.cancel();
        return;
      }
      _processBackupInterval();
    });

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
    if (_needBackup) _storeStateToAppStorage();
  }

  void _storeStateToAppStorage() {
    final mindTreeKey = _mindTreeKey;
    if (mindTreeKey == null) return;
    final state = _mindTreeStateStore.state;
    _needBackup = false;
    (() async {
      final storage = MindTreeStorage.instance;
      storage.store(mindTreeKey, state);
      log('store complete');
    })();
  }

  void _restoreStateFromAppStorage() {
    final mindTreeKey = _mindTreeKey;
    if (mindTreeKey == null) return;
    (() async {
      final storage = MindTreeStorage.instance;
      final t = await storage.load(mindTreeKey);
      if (t == null) return;
      _mindTreeStateStore
          .dispatch(MindTreeActionRestore(t));
      log('restore complete');
    })();
  }

  void _navigateSelectMindTree() {
    (() async {
      // TODO:
      final _ = await Navigator.pushNamed(context, '/mindTree/list',
          arguments: {'selected': 'default'});
    })();
  }

  @override
  Widget build(BuildContext context) {
    var mindTreeData =
        MindTreeTreeData.fromJson(_mindTreeStateStore.state.generateTreeJson());
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("mindmap - "),
      ),
      // scrollDirection: Axis.horizontal,
      body: _mindTreeKey == null
          ? Container()
          : buildMindTree(context, mindTreeData),
      floatingActionButton: IntrinsicWidth(
          child: Row(children: [
        FloatingActionButton(
          onPressed: () {
            _navigateSelectMindTree();
          },
          tooltip: 'list',
          child: Icon(Icons.list),
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

  Widget buildMindTree(BuildContext context, MindTreeTreeData mindTreeData) =>
      InteractiveViewer(
        constrained: false,
        minScale: 1,
        boundaryMargin: EdgeInsets.fromLTRB(1, 1, 1000, 1000),
        child: MindTree(
          mindTreeData,
          0,
          onRequestedToAddNewNode: (int parentId, String label) {
            _mindTreeStateStore
                .dispatch(MindTreeActionAddNode(parentId, label));
          },
          onRequestedToRemoveNode: (int id) {
            _mindTreeStateStore.dispatch(MindTreeActionRemoveNode(id));
          },
          onRequestedToEditNode: (int id, String label) {
            _mindTreeStateStore.dispatch(MindTreeActionChangeLabel(id, label));
          },
        ),
      );
}
