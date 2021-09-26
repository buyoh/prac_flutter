import 'dart:convert';
import 'package:flutter/material.dart';
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
  MindTreeData _data = MindTreeData.fromJson(json.decode("""
          {"label": "item1", "children":[
            {"label": "item1a", "children": []},
            {"label": "item1b", "children": []},
            {"label": "item1c", "children": [
              {"label": "item1c1", "children": []}
            ]}
          ]}"""));

  _MyHomePageState() : _displayedPageStore = createDisplayedPageStore() {
    _applyFromDisplayedPageStore();
    _displayedPageStore.onChange.listen((event) {
      setState(() {
        _applyFromDisplayedPageStore();
      });
    });
  }

  void _applyFromDisplayedPageStore() {
    _title = _displayedPageStore.state.title;
  }

  // @override
  // void initState() {
  //   super.initState();
  // }

  void _incrementCounter() {
    // TODO: example
    _displayedPageStore.dispatch(DisplayedPageAction.updateTitle('foobar'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title + " - " + _title),
      ),
      // scrollDirection: Axis.horizontal,
      body: SingleChildScrollView(
        // scrollDirection: Axis.horizontal,
        child: MindTree(_data, 0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
