import 'package:flutter/material.dart';
import 'package:smartmirror/helpers/ModulePosition.dart';

import 'Module.dart';

class PositionedModule extends Module {
  ModulePosition position;

  PositionedModule(int id, int order, String module, ModulePosition pos)
      : super(id, order, module) {
    position = pos;
  }

  @override
  void buildWidgets(BuildContext context, Function refresh) {
    super.buildWidgets(context, refresh);
    addPositionPicker(position, (ModulePosition newValue) {
      position = newValue;
      refresh(this);
    });
  }

  @override
  dynamic getPosition() {
    return position;
  }

  @override
  void setPosition(dynamic pos) {
    position = pos;
  }

  void refreshMe(Function refresh) {
    refresh(this);
  }

  factory PositionedModule.fromJson(Map<String, dynamic> json) {
    return PositionedModule(json['_meta']['id'], json['_meta']['order'],
        json['module'], ModulePosition.fromString(json['position']));
  }

  @override
  String toString() {
    return "{id:$id, order:$order, module:$module, position:${position.toString()}}";
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    if (this.position != null) json['position'] = this.position.toJsonString();
    return json;
  }
}
