import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:smartmirror/modules/Module.dart';
import 'package:smartmirror/helpers/MmmpServer.dart';
import 'package:smartmirror/helpers/ModulePosition.dart';

import 'ModuleOverview.dart';
import 'NewModuleList.dart';

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
  List<ModulePosition> _modulePositions;
  Map<ModulePosition, List<Module>> _sortedModules;

  @override
  void initState() {
    super.initState();
    futureModules = widget.server.config.getModules();
  }

  void refresh() {
    setState(() {
      futureModules = widget.server.config.getModules();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Module list'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'restart') {
                widget.server.manage.restart();
              }
            },
            itemBuilder: (BuildContext context) {
              return {'restart'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: 'restart',
                  child: Text('Restart MagicMirror²'),
                );
              }).toList();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      NewModuleListApp(server: widget.server))).then((x) {
            refresh();
          });
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<Module>>(
        future: futureModules,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildList(widget.server, snapshot.data, refresh);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }

  // triggered when reordering a module
  void _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    // fetch module from its old position
    var module = _sortedModules[_modulePositions[oldListIndex]][oldItemIndex];

    // update position
    if (module.getPosition() != _modulePositions[newListIndex]) {
      // remove from old position list
      _sortedModules[module.getPosition()].remove(module);

      // insert into new position list at appropriate index
      module.setPosition(_modulePositions[newListIndex]);
      _sortedModules[module.getPosition()].insert(newItemIndex, module);
    } else {
      _sortedModules[module.getPosition()].remove(module);
      _sortedModules[module.getPosition()].insert(newItemIndex, module);
    }

    // update orders in position list
    int order = 100;
    _sortedModules[module.getPosition()].forEach((Module x) {
      x.order = order;
      order += 100;
      widget.server.config.setModule(module: x);
    });

    // refresh the view
    refresh();
  }

  Widget _buildList(MmmpServer server, List<Module> modules, Function refresh) {
    var backgroundColor = Color.fromARGB(255, 243, 242, 248);

    return Builder(builder: (context) {
      // Create map where keys is each populated position and values is the
      // modules in that position
      Map<ModulePosition, List<Module>> sortedModules =
          new Map<ModulePosition, List<Module>>();
      modules.forEach((Module x) {
        if (!sortedModules.containsKey(x.getPosition())) {
          sortedModules[x.getPosition()] = List<Module>.empty(growable: true);
        }
        sortedModules[x.getPosition()].add(x);
      });

      // Keep track of lists for future reference (when reordering)
      _modulePositions = List<ModulePosition>.empty(growable: true);
      _sortedModules = sortedModules;

      // Get list of keys in sortedModules, sorted alphabetically. Objective is
      // to always show positions in the same order
      // https://stackoverflow.com/questions/18244545/dart-how-to-sort-maps-keys
      var sortedKeys = sortedModules.keys.toList()
        ..sort((a, b) => a.toString().compareTo(b.toString()));

      // Create a DragAndDropList for each populated position
      var lists = List<DragAndDropList>.empty(growable: true);
      sortedKeys.forEach((ModulePosition p) {
        // Keep track of those positions
        _modulePositions.add(p);

        // Sort modules within a position by their order
        sortedModules[p].sort((a, b) => a.order.compareTo(b.order));

        // Create a clickable, draggable, dissmissible tile for each module in
        // that position
        var items = List<DragAndDropItem>.empty(growable: true);
        sortedModules[p].forEach((Module m) {
          items.add(DragAndDropItem(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Dismissible(
                      background: Container(
                        color: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        alignment: AlignmentDirectional.centerStart,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      key: Key(m.id.toString()),
                      onDismissed: (direction) {
                        // remove dismissible from tree
                        modules.removeWhere((x) => x.id == m.id);
                        server.config.deleteModule(module: m).then((x) {
                          refresh(); // refresh view in case a position section should disappear
                        });
                      },
                      child: ListTile(
                        title: Text(m.name),
                        onTap: () {
                          // when a tile is clicked, go to the respective
                          // configuration view
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ModuleOverviewApp(
                                    server: server, module: m)),
                          ).then((x) {
                            // refresh view on return in case a module changes position
                            refresh();
                          });
                        },
                      )))));
        });

        // Header for the list
        String title = (p == null) ? "No position" : p.toString();

        var entry = DragAndDropList(
            header: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            children: items);

        lists.add(entry);
      });

      // TODO: figure out how to disable drag and drop on headlines, it does
      // nothing (and shouldnt)
      return DragAndDropLists(
        children: lists,
        onItemReorder: _onItemReorder,
        onListReorder: (int oldListIndex, int newListIndex) {},
        listPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        itemDivider: Divider(
          thickness: 2,
          height: 2,
          color: backgroundColor,
        ),
        itemDecorationWhileDragging: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        listInnerDecoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        lastItemTargetHeight: 8,
        addLastItemTargetHeightToTop: true,
        lastListTargetSize: 40,
      );
    });
  }
}
