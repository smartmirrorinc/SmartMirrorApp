import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:smartmirror/helpers/restHelper.dart' as restHelper;
import 'package:smartmirror/modules/Module.dart';

class MmmpServer {
  final String host;
  final String ip;
  final int port;
  final _Manage manage;
  final _Config config;

  MmmpServer({@required String host, @required String ip, @required int port})
      : host = host,
        ip = ip,
        port = port,
        manage = _Manage(),
        config = _Config() {
    manage.server = this;
    config.server = this;
  }

  String get url {
    return "http://$ip:$port/";
  }
}

class _Config {
  MmmpServer server;

  String get url {
    return server.url + "config/";
  }

  Future<List<Module>> getModules() async {
    final data = _toJson(await restHelper.get(url + "modules/"));

    List<Module> modules = new List<Module>();
    data["modules"].forEach((x) => modules.add(moduleFromString(x)));
    modules.sort((a, b) => a.id.compareTo(b.id));

    return modules;
  }

  Future<Module> getModule({@required int id}) async {
    final data = _toJson(await restHelper.get(url + "modules/$id/"));
    return moduleFromString(data["value"]);
  }

  Future<void> addModule({@required String moduleType}) async {
    final response = await restHelper.postJson(url + "modules/", {
      "action": "add",
      "value": {"module": moduleType}
    });
    _checkOk(response);
  }

  Future<void> deleteModule({@required Module module}) async {
    final response = await restHelper.postJson(url + "modules/${module.id}/", {
      "action": "delete",
      "value": {"module": module.toJson()}
    });
    _checkOk(response);
  }

  Future<void> setModule({@required Module module}) async {
    final response = await restHelper.postJson(url + "modules/${module.id}/", {
      "action": "update",
      "value": module.toJson()
    });
    _checkOk(response);
  }
}

class _Manage {
  MmmpServer server;

  String get url {
    return server.url + "manage/";
  }

  Future<List<dynamic>> listmodules() async {
    final data = _toJson(await restHelper.get(url + "listmodules/"));
    return data["value"];
  }

  Future<void> hdmiOn() async {
    await restHelper.get(url + "hdmi_on/");
  }

  Future<void> start() async {
    await restHelper.get(url + "start/");
  }

  Future<void> stop() async {
    await restHelper.get(url + "stop/");
  }

  Future<void> restart() async {
    await restHelper.get(url + "restart/");
  }
}

void _checkOk(http.Response response) {
  if (response.statusCode != 200) {
    throw Exception('HTTP status ${response.statusCode}');
  }
}

Map<String, dynamic> _toJson(http.Response response) {
  _checkOk(response);
  return json.decode(response.body);
}
