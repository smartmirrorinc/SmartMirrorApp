import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smartmirror/helpers/ModulePosition.dart';

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
    // Dropdown must be based on enum, not ModulePosition instances, so grab
    // ModulePosition.position as value and items, and convert to ModulePosition
    // before returning via onChanged
    return DropdownButton<Position>(
        value: position.position,
        icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        isExpanded: true,
        style: TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (Position x) {
          onChanged(ModulePosition(x));
        },
        items: ModulePosition.getPositions().map((ModulePosition pos) {
          return DropdownMenuItem<Position>(
            value: pos.position,
            child: Text(pos.toString()),
          );
        }).toList());
  }
}
