import 'package:flutter/material.dart';
import 'package:smartmirror/builder/Widgeteer.dart';
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
    "MMM-DarkSkyForecast": ModuleDarkSkyForecast.instantiate,
  };

  if (!modules.keys.contains(json["module"])) {
    return ModuleAnonymous(json);
  } else {
    return modules[json["module"]](json);
  }
}

class Module extends Widgeteer {
  final int id;
  final String module;
  int order = 0;
  List<Widget> widgets;
  //TODO: Why does a Module have a ModulePosition?
  ModulePosition position;

  Module(id, order, module)
      : id = id,
        module = module,
        order = (order == null ? 0 : order) {
    if (this.id == null) throw ArgumentError("Null id");
    if (this.module == null) throw ArgumentError("Null module");
  }

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(json['_meta']['id'], json['_meta']['order'], json['module']);
  }

  @override
  String toString() {
    return "{id:$id, order:$order, module:$module}";
  }

  String get name {
    return module;
  }

  static instantiate(Map<String, dynamic> json) => Module.fromJson(json);

  void buildWidgets(BuildContext context, Function refresh) {
    widgets = new List<Widget>.empty(growable: true);

    widgets.add(Card(
        child: Column(children: [
      ListTile(
          leading: Icon(Icons.info),
          title: Text("Type", style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("$module (id $id, order $order)"))
    ])));
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map<String, dynamic>();
    json['_meta'] = Map<String, dynamic>();
    json['_meta']['id'] = this.id;
    json['_meta']['order'] = this.order;
    json['module'] = this.module;
    return json;
  }
}
