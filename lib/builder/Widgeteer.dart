import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Widgeteer {
  List<Widget> widgets;

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
}
