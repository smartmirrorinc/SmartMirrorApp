part of components;

class ModuleCalendar extends PositionedModule {
  List<dynamic> calendars;

  ModuleCalendar(id, order, module, position, _calendars)
      : calendars = _calendars,
        super(id, order, module, position);

  factory ModuleCalendar.fromJson(Map<String, dynamic> json) {
    // defaults
    List<dynamic> calendars = [
      {
        "url":
            "webcal://www.calendarlabs.com/ical-calendar/ics/43/Denmark_Holidays.ics"
      }
    ];

    if (json.containsKey("config") && json["config"].containsKey("calendars")) {
      calendars = json["config"]["calendars"];
    }

    return ModuleCalendar(
      json['_meta']['id'],
      json['_meta']['order'],
      json['module'],
      ModulePosition.fromString(json['position']),
      calendars,
    );
  }

  static instantiate(Map<String, dynamic> json) =>
      ModuleCalendar.fromJson(json);

  @override
  String toString() {
    return "{id:$id, order:$order, module:$module, position:${position.toString()}, " +
        "calendars: ${calendars.toString()}}";
  }

  @override
  String get name {
    return "Event list";
  }

  @override
  void buildWidgets(BuildContext context, Function refresh) {
    super.buildWidgets(context, refresh);

    // "Calendars" header with icon and add button
    var calsHeaderTile = PopupMenuButton(
        child: ListTile(
            leading: Icon(Icons.rss_feed),
            title: Text("Calendars",
                style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Icon(Icons.add)),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'addurl',
                child: Text('Add from URL'),
              ),
            ],
        onSelected: (String x) {
          showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                    title: Text('Add calendar'),
                    content: Card(
                        elevation: 0.0,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextField(
                                  decoration: InputDecoration(
                                      labelText: "Calendar URL"),
                                  onSubmitted: (String value) {
                                    calendars.add({"url": value});
                                    refresh(this);
                                    Navigator.pop(context); // dismiss popup
                                  })
                            ])));
              });
        });

    // List with each cal, click item to open menu
    var calList = List<Widget>.empty(growable: true);
    calendars.forEach((cal) {
      calList.add(PopupMenuButton(
        child: ListTile(
          title: Text(cal['url']),
        ),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'delete',
            child: Text('Delete'),
          ),
        ],
        onSelected: (String x) {
          if (x == "delete") {
            calendars.remove(cal);
            refresh(this);
          }
        },
      ));
    });

    var tiles = List<Widget>.empty(growable: true);
    tiles.add(calsHeaderTile);
    calList.forEach((x) => tiles.add(x));

    widgets.add(
        Card(child: SingleChildScrollView(child: Column(children: tiles))));
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json['config'] = {'calendars': calendars, 'getRelative': 8760};
    return json;
  }
}
