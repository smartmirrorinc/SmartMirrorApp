import 'package:flutter/material.dart';
import 'package:smartmirror/dto/module.dart';
import 'package:smartmirror/helpers/discovery.dart';
import 'package:smartmirror/helpers/restHelper.dart';

class ModuleOverviewApp extends StatelessWidget {
  final Module module;
  final MmmpServer server;

  ModuleOverviewApp({Key key, @required this.server, @required this.module})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(module.module),
      ),
      body: Center(
        child: ModuleOverview(server: server, module: module),
      ),
    );
  }
}

class ModuleOverview extends StatefulWidget {
  final Module module;
  final MmmpServer server;

  ModuleOverview({Key key, @required this.server, @required this.module})
      : super(key: key);

  @override
  _ModuleOverviewState createState() => _ModuleOverviewState();
}

class _ModuleOverviewState extends State<ModuleOverview> {
  Future<Module> futureModule;

  @override
  void initState() {
    super.initState();

    futureModule = fetchModule(
        "${widget.server.ip}:${widget.server.port}", widget.module.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Module overview')),
      body: FutureBuilder<Module>(
        future: futureModule,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.module);
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
