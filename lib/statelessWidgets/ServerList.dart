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
  Future<List<MmmpServer>> futureServers;

  @override
  void initState() {
    super.initState();
    futureServers = discoverServers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<MmmpServer>>(
        future: futureServers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildList(snapshot.data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildList(List<MmmpServer> servers) {
    if (servers.length > 0) {
      return ListView.builder(
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
    } else {
      return Column(children: [
        ListTile(
            title: Text("No servers found. Retry?"),
            onTap: () {
              setState(() {
                futureServers = discoverServers();
              });
            }),
        //ListTile(title: Text("Enter IP"))
      ]);
    }
  }
}
