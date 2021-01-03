part of components;

// TODO: font size option? https://github.com/fewieden/MMM-ip

class ModuleIP extends PositionedModule {
  ModuleIP(int id, int order, String module, ModulePosition pos)
      : super(id, order, module, pos);
  static instantiate(Map<String, dynamic> json) => ModuleIP.fromJson(json);

  factory ModuleIP.fromJson(Map<String, dynamic> json) {
    return ModuleIP(json['_meta']['id'], json['_meta']['order'], json['module'],
        modulePositionFromString(json['position']));
  }

  @override
  String get name {
    return "IP address";
  }
}
