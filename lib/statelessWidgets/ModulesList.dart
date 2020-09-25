import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartmirror/dto/module.dart';
import 'package:smartmirror/helpers/discovery.dart';
import 'package:smartmirror/helpers/restHelper.dart';

import 'ModuleOverview.dart';

class ModulesListApp extends StatelessWidget {
  final MmmpServer server;

  ModulesListApp({Key key, @required this.server}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ModulesList(server: server),
      ),
    );
  }
}

class ModulesList extends StatefulWidget {
  final MmmpServer server;

  ModulesList({Key key, @required this.server}) : super(key: key);

  @override
  _ModulesListState createState() => _ModulesListState();
}

class _ModulesListState extends State<ModulesList> {
  Future<List<Module>> futureModules;

  @override
  void initState() {
    super.initState();
    futureModules = fetchModuleList(widget.server);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Module overview')),
      body: FutureBuilder<List<Module>>(
        future: futureModules,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildList(widget.server, snapshot.data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

Widget _buildList(MmmpServer server, List<Module> modules) {
  return ListView.builder(
      itemCount: modules.length,
      padding: EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        return ListTile(
          title: Text("${modules[i].id}: ${modules[i].module}"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ModuleOverviewApp(server: server, module: modules[i])),
            );
          },
        );
      });
}
