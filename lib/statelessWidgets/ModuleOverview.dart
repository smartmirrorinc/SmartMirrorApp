import 'package:flutter/material.dart';
import 'package:smartmirror/dto/module.dart';
import 'package:smartmirror/helpers/discovery.dart';
import 'package:smartmirror/helpers/restHelper.dart';

class ModuleOverviewApp extends StatelessWidget {
  final ModuleOverview widget;

  ModuleOverviewApp({Key key, MmmpServer server, Module module})
      : widget = ModuleOverview(server: server, module: module);

  @override
  Widget build(BuildContext context) {
    // Create save button with a Builder to get a context we can refer to when
    // displaying the snackbar
    var btnBuilder = Builder(builder: (context) {
      return FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          setModule("${widget.state.server.ip}:${widget.state.server.port}",
              widget.state.module, () {
            final snackBar = SnackBar(content: Text('Changes saved'));
            Scaffold.of(context).showSnackBar(snackBar);
          });
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.state.module.module),
      ),
      body: Center(
        child: this.widget,
      ),
      floatingActionButton: btnBuilder,
    );
  }
}

class ModuleOverview extends StatefulWidget {
  final _ModuleOverviewState state;

  ModuleOverview({Key key, MmmpServer server, Module module})
      : state = _ModuleOverviewState(server, module),
        super(key: key);

  @override
  _ModuleOverviewState createState() {
    return state;
  }
}

class _ModuleOverviewState extends State<ModuleOverview> {
  MmmpServer server;
  Module module;

  _ModuleOverviewState(MmmpServer server, Module module) {
    this.server = server;
    this.module = module;
  }

  @override
  void initState() {
    super.initState();
    fetchModule("${server.ip}:${server.port}", module.id, refresh);
  }

  void refresh(Module module) {
    setState(() {
      module = module;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (module != null) {
        module.buildWidgets(refresh);
        var widgets = module.widgets;
        return ListView(children: widgets);
      } else {
        return Center(child: CircularProgressIndicator());
      }
    });
  }
}
