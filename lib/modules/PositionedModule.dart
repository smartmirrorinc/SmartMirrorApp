import 'package:flutter/material.dart';

import 'Module.dart';

class PositionedModule extends Module {
  PositionedModule(int id, int order, String module, ModulePosition pos)
      : super(id, order, module) {
    position = pos;
  }

  @override
  void buildWidgets(BuildContext context, Function refresh) {
    super.buildWidgets(context, refresh);

    Widget dropdown = getPosDropDown(refresh);
    Widget icon = Icon(Icons.picture_in_picture);
    ListTile tile = ListTile(
        leading: icon,
        title: Text("Module position",
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: dropdown);
    widgets.add(
        Card(child: Column(mainAxisSize: MainAxisSize.max, children: [tile])));
  }

  factory PositionedModule.fromJson(Map<String, dynamic> json) {
    return PositionedModule(
        json['_meta']['id'],
        json['_meta']['order'],
        json['module'],
        modulePositionFromString(json['position']));
  }

  @override
  String toString() {
    return "{id:$id, order:$order, module:$module, position:${position.toString()}}";
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
    if (this.position != null)
      json['position'] = this.position.toString().substring(15);
    return json;
  }
}
