import 'package:flutter/material.dart';

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
    return null;
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

class Module {
  final int id;
  final String module;
  List<Widget> widgets;
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

class PositionedModule extends Module {
  PositionedModule(int id, String module, ModulePosition pos)
      : super(id, module) {
    position = pos;
  }

  @override
  void buildWidgets(Function refresh) {
    super.buildWidgets(refresh);

    Widget dropdown = getPosDropDown(refresh);
    Widget icon = Icon(Icons.picture_in_picture);
    ListTile tile = ListTile(
        leading: icon,
        title: Text("Position", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: dropdown);
    widgets.add(
        Card(child: Column(mainAxisSize: MainAxisSize.max, children: [tile])));
  }

  factory PositionedModule.fromJson(Map<String, dynamic> json) {
    return PositionedModule(json['_meta']['id'], json['module'],
        modulePositionFromString(json['position']));
  }

  @override
  String toString() {
    return "{id:$id, module:$module, position:${position.toString()}}";
  }

  Widget getPosDropDown(Function refresh) {
    return DropdownButton<ModulePosition>(
      value: position,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      isExpanded: true,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (ModulePosition newValue) {
        position = newValue;
        refresh(this);
      },
      items: ModulePosition.values.map((ModulePosition value) {
        return DropdownMenuItem<ModulePosition>(
          value: value,
          child: Text(modulePositionToString(value)),
        );
      }).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json['position'] = this.position.toString().substring(15);
    return json;
  }
}

class ModuleForecast extends PositionedModule {
  ModuleForecast(int id, String module, ModulePosition pos)
      : super(id, module, pos);
  static instantiate(Map<String, dynamic> json) =>
      PositionedModule.fromJson(json);
}

class ModuleWeather extends PositionedModule {
  ModuleWeather(int id, String module, ModulePosition pos)
      : super(id, module, pos);
  static instantiate(Map<String, dynamic> json) =>
      PositionedModule.fromJson(json);
}

class ModuleAlert extends Module {
  ModuleAlert(int id, String module) : super(id, module);
  static instantiate(Map<String, dynamic> json) => Module.fromJson(json);
}

class ModuleClock extends PositionedModule {
  ModuleClock(int id, String module, ModulePosition pos)
      : super(id, module, pos);
  static instantiate(Map<String, dynamic> json) =>
      PositionedModule.fromJson(json);
}

class ModuleCompliments extends PositionedModule {
  ModuleCompliments(int id, String module, ModulePosition pos)
      : super(id, module, pos);
  static instantiate(Map<String, dynamic> json) =>
      PositionedModule.fromJson(json);
}

class ModuleIP extends PositionedModule {
  ModuleIP(int id, String module, ModulePosition pos) : super(id, module, pos);
  static instantiate(Map<String, dynamic> json) =>
      PositionedModule.fromJson(json);
}

class ModuleUpdateNotification extends PositionedModule {
  ModuleUpdateNotification(int id, String module, ModulePosition pos)
      : super(id, module, pos);
  static instantiate(Map<String, dynamic> json) =>
      PositionedModule.fromJson(json);
}

class ModuleNewsfeed extends PositionedModule {
  bool showPublishDate;
  bool showSourceTitle;
  List<dynamic> feeds;

  ModuleNewsfeed(
      id, module, position, _showPublishDate, _showSourceTitle, _feeds)
      : showPublishDate = _showPublishDate,
        showSourceTitle = _showSourceTitle,
        feeds = _feeds,
        super(id, module, position);

  factory ModuleNewsfeed.fromJson(Map<String, dynamic> json) {
    return ModuleNewsfeed(
      json['_meta']['id'],
      json['module'],
      modulePositionFromString(json['position']),
      json['config']['showPublishDate'],
      json['config']['showSourceTitle'],
      json['config']['feeds'],
    );
  }

  static instantiate(Map<String, dynamic> json) =>
      ModuleNewsfeed.fromJson(json);

  @override
  String toString() {
    return "{id:$id, module:$module, position:${position.toString()}, " +
        "showPublishDate: $showPublishDate, " +
        "showSourceTitle: $showSourceTitle, " +
        "feeds: ${feeds.toString()}}";
  }

  @override
  void buildWidgets(Function refresh) {
    super.buildWidgets(refresh);

    // Checkbox to toggle "show publish date"
    widgets.add(Card(
        child: Column(children: [
      ListTile(
        leading: Icon(Icons.date_range),
        title: Text("Show publish date",
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Align(
            child: Checkbox(
                value: showPublishDate,
                onChanged: (x) {
                  showPublishDate = x;
                  refresh(this);
                }),
            alignment: Alignment.centerLeft),
      )
    ])));

    // Checkbox to toggle "show source title"
    widgets.add(Card(
        child: Column(children: [
      ListTile(
        leading: Icon(Icons.subtitles),
        title: Text("Show source title",
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Align(
            child: Checkbox(
                value: showSourceTitle,
                onChanged: (x) {
                  showSourceTitle = x;
                  refresh(this);
                }),
            alignment: Alignment.centerLeft),
      )
    ])));

    // "Feeds" header with icon and add button
    // TODO: make add button actually do something
    var feedsHeaderTile = ListTile(
        leading: Icon(Icons.rss_feed),
        title: Text("Feeds", style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Icon(Icons.add));

    // List with each feed and menu button, click item to open menu
    var feedList = List<Widget>();
    feeds.forEach((feed) {
      feedList.add(PopupMenuButton(
        child: ListTile(
          title: Text(feed['title'],
              style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(feed['url']),
          trailing: Icon(Icons.menu),
        ),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'delete',
            child: Text('Delete'),
          ),
        ],
        onSelected: (String x) {
          if (x == "delete") {
            feeds.remove(feed);
            refresh(this);
          }
        },
      ));
    });

    widgets.add(Card(
        child: Column(
      children: [
        feedsHeaderTile,
        // wrap feeds in scrollable listview
        ListView(
            children: feedList,
            scrollDirection: Axis.vertical,
            shrinkWrap: true)
      ],
    )));
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json['config'] = {
      'broadcastNewsFeeds': true,
      'broadcastNewsUpdates': true,
      'showPublishDate': showPublishDate,
      'showSourceTitle': showSourceTitle,
      'feeds': feeds
    };
    return json;
  }
}

class ModuleCalendar extends PositionedModule {
  final String header;
  final List<dynamic> calendars;

  ModuleCalendar(id, module, position, _header, _calendars)
      : header = _header,
        calendars = _calendars,
        super(id, module, position);

  factory ModuleCalendar.fromJson(Map<String, dynamic> json) {
    return ModuleCalendar(
      json['_meta']['id'],
      json['module'],
      modulePositionFromString(json['position']),
      json['header'],
      json['config']['calendars'],
    );
  }

  static instantiate(Map<String, dynamic> json) =>
      ModuleCalendar.fromJson(json);

  @override
  String toString() {
    return "{id:$id, module:$module, position:${position.toString()}, " +
        "header: $header, " +
        "calendars: ${calendars.toString()}}";
  }
}

class ModulePirSensor extends PositionedModule {
  final bool powerSavingNotification;
  final int sensorPin;
  final int powerSavingDelay;

  ModulePirSensor(id, module, position, _powerSavingNotification, _sensorPin,
      _powerSavingDelay)
      : powerSavingNotification = _powerSavingNotification,
        powerSavingDelay = _powerSavingDelay,
        sensorPin = _sensorPin,
        super(id, module, position);

  factory ModulePirSensor.fromJson(Map<String, dynamic> json) {
    return ModulePirSensor(
      json['_meta']['id'],
      json['module'],
      modulePositionFromString(json['position']),
      json['config']['powerSavingNotification'],
      json['config']['sensorPin'],
      json['config']['powerSavingDelay'],
    );
  }

  static instantiate(Map<String, dynamic> json) =>
      ModulePirSensor.fromJson(json);

  @override
  String toString() {
    return "{id:$id, module:$module, position:${position.toString()}, " +
        "powerSavingNotification: $powerSavingNotification, " +
        "sensorPin: $sensorPin, powerSavingDelay: $powerSavingDelay}";
  }
}
