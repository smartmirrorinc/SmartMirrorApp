import 'package:flutter/material.dart';
import 'package:smartmirror/helpers/restHelper.dart';
import 'package:smartmirror/statelessWidgets/ModuleOverview.dart';

import 'dto/module.dart';

void main() => runApp(SmartMirrorApp());

class SmartMirrorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        /*appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),*/
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
  Future<List<Module>> futureModules;

  @override
  void initState() {
    super.initState();
    futureModules = fetchModuleList("192.168.1.44:5000");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Module overview')),
      body: FutureBuilder<List<Module>>(
        future: futureModules,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildList(snapshot.data);
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

Widget _buildList(List<Module> modules) {
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
                  builder: (context) => ModuleOverviewApp(module: modules[i])),
            );
          },
        );
      });
}
