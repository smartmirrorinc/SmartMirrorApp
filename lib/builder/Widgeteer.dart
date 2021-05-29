import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Widgeteer {
  List<Widget> widgets;

  void addListOfThings(Function onChanged) {}

  void addDropdown(Function onChanged) {}

  void addPositionPicker(ModulePosition pos, Function onChanged) {
    Widget dropdown = getPosDropDown(pos, onChanged);
    Widget icon = Icon(Icons.picture_in_picture);
    ListTile tile = ListTile(
        leading: icon,
        title: Text("Module position",
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: dropdown);
    widgets.add(
        Card(child: Column(mainAxisSize: MainAxisSize.max, children: [tile])));
  }

  void addModifiableTextField(Icon leadingIcon, String labelText,
      String helperText, Function onChanged) {
    widgets.add(Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.subtitles),
            subtitle: Align(
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: labelText,
                    helperText: helperText),
                onChanged: onChanged,
              ),
            ),
          )
        ],
      ),
    ));
  }

  void addCheckbox(Icon leadingIcon, String titleText, bool defaultValue,
      Function onChanged) {
    widgets.add(Card(
        child: Column(children: [
      ListTile(
        leading: leadingIcon,
        title: Text(titleText, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Align(
            child: Checkbox(value: defaultValue, onChanged: onChanged),
            alignment: Alignment.centerLeft),
      )
    ])));
  }

  Widget getPosDropDown(ModulePosition position, Function onChanged) {
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
      onChanged: onChanged,
      items: ModulePosition.values.map((ModulePosition value) {
        return DropdownMenuItem<ModulePosition>(
          value: value,
          child: Text(modulePositionToString(value)),
        );
      }).toList(),
    );
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

String modulePositionToString(ModulePosition pos) {
  if (pos == null) {
    return "No position";
  } else {
    String tmp = pos.toString().substring(15).replaceAll("_", " ");
    return "${tmp[0].toUpperCase()}${tmp.substring(1)}";
  }
}
