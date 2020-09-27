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
  Module module;

  @override
  void initState() {
    super.initState();
    fetchModule(
        "${widget.server.ip}:${widget.server.port}", widget.module.id, refresh);
  }

  void refresh(Module module) {
    setState(() {
      this.module = module;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (module != null) {
        module.buildWidgets(refresh);
        return ListView(children: module.widgets);
      } else {
        return Center(child: CircularProgressIndicator());
      }
    });
  }
}
