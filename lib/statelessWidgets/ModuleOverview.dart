import 'package:flutter/material.dart';
import 'package:smartmirror/modules/Module.dart';
import 'package:smartmirror/helpers/MmmpServer.dart';

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
          widget.state.server.config.setModule(module: widget.state.module).then((x) {
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
    server.config.getModule(id: module.id).then((module) {
      refresh(module);
    });
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
        module.buildWidgets(context, refresh);
        var widgets = module.widgets;
        return ListView(children: widgets);
      } else {
        return Center(child: CircularProgressIndicator());
      }
    });
  }
}
