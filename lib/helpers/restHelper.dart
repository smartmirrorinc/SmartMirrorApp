import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:smartmirror/dto/module.dart';

Future<List<Module>> fetchModuleOverview(String remote) async {
  final response = await http.get('http://$remote/config/modules/');

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    List<Module> modules = new List<Module>();

    data["modules"].forEach(
        (x) => modules.add(Module(id: x["_meta"]["id"], module: x["module"])));

    return modules;
  } else {
    throw Exception('failed to load modules');
  }
}

Future<Module> fetchModule(String remote, int id) async {
  final response = await http.get('http://$remote/config/modules/$id/');

  if (response.statusCode == 200) {
    return Module.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load module $id');
  }
}
