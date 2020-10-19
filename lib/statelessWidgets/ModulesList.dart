import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartmirror/modules/Module.dart';
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
      appBar: AppBar(title: Text('Module list')),
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
  return Builder(builder: (context) {
    // Create map where keys is each populated position and values is the
    // modules in that position
    Map<ModulePosition, List<Module>> sortedModules =
        new Map<ModulePosition, List<Module>>();
    modules.forEach((Module x) {
      if (!sortedModules.containsKey(x.position)) {
        sortedModules[x.position] = new List<Module>();
      }
      sortedModules[x.position].add(x);
    });

    // Create a card for each populated position
    List<Card> cards = List<Card>();
    sortedModules.keys.forEach((ModulePosition p) {
      // Create a clickable tile for each module in that position
      List<ListTile> tiles = List<ListTile>();
      sortedModules[p].forEach((Module m) {
        tiles.add(ListTile(
          title: Text(m.module),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ModuleOverviewApp(server: server, module: m)),
            );
          },
        ));
      });

      // Header for the card
      String title = (p == null) ? "No position" : modulePositionToString(p);

      // The card contains just one child: a ListTile where the title
      // contains the header and the subtitle contains a Column of all the
      // modules in that position
      ListTile entry = ListTile(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(children: tiles));

      cards.add(Card(child: Column(children: [entry])));
    });

    // Wrap the cards in a listview for scrollability
    return ListView(children: cards);
  });
}
