part of components;

class ModuleUpdateNotification extends PositionedModule {
  ModuleUpdateNotification(int id, int order, String module, ModulePosition pos)
      : super(id, order, module, pos);
  static instantiate(Map<String, dynamic> json) =>
      ModuleUpdateNotification.fromJson(json);

  factory ModuleUpdateNotification.fromJson(Map<String, dynamic> json) {
    return ModuleUpdateNotification(json['_meta']['id'], json['_meta']['order'],
        json['module'], modulePositionFromString(json['position']));
  }

  @override
  String get name {
    return "Update notifications";
  }
}
