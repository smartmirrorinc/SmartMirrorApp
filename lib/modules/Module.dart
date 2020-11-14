import 'package:flutter/material.dart';
import 'components/components.dart';

Module moduleFromString(Map<String, dynamic> json) {
  Map modules = {
    "alert": ModuleAlert.instantiate,
    "clock": ModuleClock.instantiate,
    "MMM-PIR-Sensor": ModulePirSensor.instantiate,
    "newsfeed": ModuleNewsfeed.instantiate,
    "calendar": ModuleCalendar.instantiate,
    "compliments": ModuleCompliments.instantiate,
    "MMM-ip": ModuleIP.instantiate,
    "updatenotification": ModuleUpdateNotification.instantiate,
    "currentweather": ModuleWeather.instantiate,
    "weatherforecast": ModuleForecast.instantiate,
  };

  if (!modules.keys.contains(json["module"])) {
    return ModuleAnonymous(json);
  } else {
    return modules[json["module"]](json);
  }
}

enum ModulePosition {
  top_bar,
  top_left,
  top_center,
  top_right,
  upper_third,
  middle_center,
  lower_third,
  bottom_left,
  bottom_center,
  bottom_right,
  bottom_bar,
  fullscreen_above,
  fullscreen_below
}

class Module {
  final int id;
  final String module;
  List<Widget> widgets;
  //TODO: Why does a Module have a ModulePosition?
  ModulePosition position;

  Module(this.id, this.module);

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(json['_meta']['id'], json['module']);
  }

  @override
  String toString() {
    return "{id:$id, module:$module}";
  }

  static instantiate(Map<String, dynamic> json) => Module.fromJson(json);

  void buildWidgets(Function refresh) {
    widgets = new List<Widget>();

    widgets.add(Card(
        child: Column(children: [
      ListTile(
          leading: Icon(Icons.info),
          title: Text("Type", style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("$module (id $id)"))
    ])));
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map<String, dynamic>();
    json['_meta'] = Map<String, dynamic>();
    json['_meta']['id'] = this.id;
    json['module'] = this.module;
    return json;
  }
}

String modulePositionToString(ModulePosition pos) {
  String tmp = pos.toString().substring(15).replaceAll("_", " ");
  return "${tmp[0].toUpperCase()}${tmp.substring(1)}";
}

ModulePosition modulePositionFromString(String pos) {
  if (pos == null) {
    return null;
  }

  Iterable<ModulePosition> p = ModulePosition.values
      .where((x) => x.toString() == ("ModulePosition." + pos));

  if (p.length < 1) {
    return null;
  } else {
    assert(p.length == 1);
    return p.first;
  }
}
