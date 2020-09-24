import 'package:flutter/material.dart';
import 'package:smartmirror/helpers/discovery.dart';
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
  MmmpServer server;

  @override
  void initState() {
    super.initState();
    futureModules = _discoverAndFetchModules();
  }

  Future<List<Module>> _discoverAndFetchModules() async {
    final List<MmmpServer> servers = await discoverServers();
    if (servers.length < 1) {
      throw Exception('failed to discover server');
    }
    server = servers[0];
    return fetchModuleList(server);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Module overview')),
      body: FutureBuilder<List<Module>>(
        future: futureModules,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildList(server, snapshot.data);
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
