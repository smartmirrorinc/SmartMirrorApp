import 'package:flutter/material.dart';
import 'package:smartmirror/helpers/restHelper.dart';

import 'dto/module.dart';

void main() => runApp(SmartMirrorApp());

class SmartMirrorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
          child: ModulesList(),
        ),
      ),
    );
  }
}

class ModulesList extends StatefulWidget {
  @override
  _ModulesListState createState() => _ModulesListState();
}

class _ModulesListState extends State<ModulesList> {
  List<Module> modules = new List<Module>();

  @override
  void initState() {
    super.initState();
    setModules();
  }

  void setModules() {
    modules
        .add(new Module(id: 1, name: "Nummer 1", order: 1, position: "hest"));
    modules
        .add(new Module(id: 2, name: "Nummer 2", order: 2, position: "hests"));
    modules.add(
        new Module(id: 3, name: "Nummer 3", order: 3, position: "Henning"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Module overview')),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return ListView.builder(
        itemCount: 3,
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          //if (i.isOdd) return Divider();
          return ListTile(title: Text(modules[i].name));
        });
  }
}
