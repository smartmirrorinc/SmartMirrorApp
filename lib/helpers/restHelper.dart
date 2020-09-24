import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:smartmirror/dto/module.dart';
import 'package:smartmirror/helpers/discovery.dart';

Future<List<Module>> fetchModuleList(MmmpServer server) async {
  final response =
      await http.get('http://${server.ip}:${server.port}/config/modules/');

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    List<Module> modules = new List<Module>();

    data["modules"].forEach(
        (x) => modules.add(Module(id: x["_meta"]["id"], module: x["module"])));

    modules.sort((a, b) => a.id.compareTo(b.id));
    return modules;
  } else {
    throw Exception('failed to load modules');
  }
}

Future<Module> fetchModule(String remote, int id) async {
  final response = await http.get('http://$remote/config/modules/$id/');

  if (response.statusCode == 200) {
    return Module.fromJson(json.decode(response.body)["value"]);
  } else {
    throw Exception('Failed to load module $id');
  }
}
