part of components;

class ModuleCompliments extends PositionedModule {
  ModuleCompliments(int id, int order, String module, ModulePosition pos)
      : super(id, order, module, pos);
  static instantiate(Map<String, dynamic> json) =>
      ModuleCompliments.fromJson(json);

  factory ModuleCompliments.fromJson(Map<String, dynamic> json) {
    return ModuleCompliments(json['_meta']['id'], json['_meta']['order'],
        json['module'], ModulePosition.fromString(json['position']));
  }

  @override
  String get name {
    return "Compliments";
  }
}
