import 'package:flutter/material.dart';
import 'package:smartmirror/helpers/discovery.dart';

import 'ModulesList.dart';

class ServerListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: Text("Server list")),
      body: Center(
        child: ServerList(),
      ),
    ));
  }
}

class ServerList extends StatefulWidget {
  @override
  _ServerListState createState() => _ServerListState();
}

class _ServerListState extends State<ServerList> {
  List<MmmpServer> servers;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildList(servers));
  }

  Widget _buildList(List<MmmpServer> servers) {
    Widget widget;
    if (servers == null) {
      // no servers found, timed out
      // wrap in stack w/ listview for RefreshIndicator to work
      widget = Stack(
        children: <Widget>[
          ListView(),
          Center(child: Text("No servers found. Pull down to refresh."))
        ],
      );
    } else if (servers.length == 0) {
      // no servers found yet
      widget = Center(child: CircularProgressIndicator());
    } else {
      // servers found
      widget = ListView.builder(
          itemCount: servers.length,
          padding: EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            return ListTile(
              title: Text(
                  "${servers[i].host}: ${servers[i].ip}:${servers[i].port}"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ModulesListApp(server: servers[i])),
                );
              },
            );
          });
    }

    return RefreshIndicator(child: widget, onRefresh: _refresh);
  }

  Future<void> _refresh() async {
    setState(() {
      // clear the list
      servers = new List<MmmpServer>();

      // attempt to discover...
      discoverServers((x) {
        if (x == null) {
          // timeout with no discoveries
          servers = null;
        } else {
          // for each discovery, add the server to the list (unless previously
          // discovered)
          bool exists = false;
          for (MmmpServer server in servers)
            if (server.host == x.host &&
                server.ip == x.ip &&
                server.port == x.port) exists = true;

          if (!exists) servers.add(x);
        }

        // rebuild UI
        setState(() {});
      });
    });
  }
}
