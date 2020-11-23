import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Widgeteer {
  List<Widget> widgets;

  void addModifiableTextField(
      Icon, leadingIcon, String labelText, String helperText) {
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
              ),
            ),
          )
        ],
      ),
    ));
  }
}
