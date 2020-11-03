part of components;

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

  @override
  void buildWidgets(Function refresh) {
    super.buildWidgets(refresh);

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
