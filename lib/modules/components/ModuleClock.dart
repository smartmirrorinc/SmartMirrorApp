part of components;

class ModuleClock extends PositionedModule {
  ModuleClock(int id, int order, String module, ModulePosition pos)
      : super(id, order, module, pos);
  static instantiate(Map<String, dynamic> json) => ModuleClock.fromJson(json);

  factory ModuleClock.fromJson(Map<String, dynamic> json) {
    return ModuleClock(json['_meta']['id'], json['_meta']['order'],
        json['module'], ModulePosition.fromString(json['position']));
  }

  @override
  String get name {
    return "Clock";
  }
}
