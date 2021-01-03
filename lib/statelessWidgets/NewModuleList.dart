import 'package:flutter/material.dart';
import 'package:smartmirror/helpers/MmmpServer.dart';
import 'package:smartmirror/modules/Module.dart';

class NewModuleListApp extends StatelessWidget {
  final MmmpServer server;

  NewModuleListApp({Key key, @required this.server}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add new module")),
      body: Center(
        child: NewModuleList(server: server),
      ),
    );
  }
}

class NewModuleList extends StatefulWidget {
  final MmmpServer server;

  NewModuleList({Key key, @required this.server}) : super(key: key);

  @override
  _NewModuleListState createState() => _NewModuleListState();
}

class _NewModuleListState extends State<NewModuleList> {
  Future<List<dynamic>> futureAvailableModules;
  List<dynamic> availableModules;

  @override
  void initState() {
    super.initState();
    futureAvailableModules = widget.server.manage.listmodules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: futureAvailableModules,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _buildList(snapshot.data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return CircularProgressIndicator();
            }));
  }

  String _getModuleName(String module) {
    return moduleFromString({'module': module, '_meta': {'id': 0}}).name;
  }

  Widget _buildList(List<dynamic> modules) {
    Widget w = ListView.builder(
        itemCount: modules.length,
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          return ListTile(
            title: Text("${_getModuleName(modules[i])}"),
            onTap: () {
              widget.server.config.addModule(moduleType: modules[i]).then((x) {
                Navigator.pop(context);
              });
            },
          );
        });

    return w;
  }
}
