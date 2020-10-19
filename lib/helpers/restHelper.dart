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

    data["modules"].forEach((x) => modules.add(moduleFromString(x)));

    modules.sort((a, b) => a.id.compareTo(b.id));
    return modules;
  } else {
    throw Exception('failed to load modules');
  }
}

void fetchModule(String remote, int id, Function callback) async {
  final response = await http.get('http://$remote/config/modules/$id/');

  if (response.statusCode == 200) {
    callback(moduleFromString(json.decode(response.body)["value"]));
  } else {
    throw Exception('Failed to load module $id');
  }
}

void setModule(String remote, Module module, Function callback) async {
  var url = "http://$remote/config/modules/${module.id}/";

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Map<String, dynamic> moduleJson = module.toJson();
  var body = json.encode({"action": "update", "value": moduleJson});

  final response = await http.post(url, body: body, headers: headers);

  if (response.statusCode == 200) {
    callback();
  } else {
    throw Exception('Failed to set module ${module.id}');
  }
}
