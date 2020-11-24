part of components;

class ModuleCalendar extends PositionedModule {
  final String header;
  final List<dynamic> calendars;

  ModuleCalendar(id, order, module, position, _header, _calendars)
      : header = _header,
        calendars = _calendars,
        super(id, order, module, position);

  factory ModuleCalendar.fromJson(Map<String, dynamic> json) {
    // defaults
    String header = 'Calendar';
    List<dynamic> calendars = [
      {
        "symbol": "calendar-check",
        "url":
            "webcal://www.calendarlabs.com/ical-calendar/ics/43/Denmark_Holidays.ics"
      }
    ];

    if (json.containsKey("header")) {
      header = json["header"];
    }
    if (json.containsKey("config") && json["config"].containsKey("calendars")) {
      calendars = json["config"]["calendars"];
    }

    return ModuleCalendar(
      json['_meta']['id'],
      json['_meta']['order'],
      json['module'],
      modulePositionFromString(json['position']),
      header,
      calendars,
    );
  }

  static instantiate(Map<String, dynamic> json) =>
      ModuleCalendar.fromJson(json);

  @override
  String toString() {
    return "{id:$id, order:$order, module:$module, position:${position.toString()}, " +
        "header: $header, " +
        "calendars: ${calendars.toString()}}";
  }

  @override
  void buildWidgets(BuildContext context, Function refresh) {
    super.buildWidgets(context, refresh);

    widgets.add(Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.subtitles),
            subtitle: Align(
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Calendar header",
                    helperText: "Current value: " + header),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
