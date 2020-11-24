part of components;

// TODO: font size option? https://github.com/fewieden/MMM-ip

class ModuleIP extends PositionedModule {
  ModuleIP(int id, int order, String module, ModulePosition pos) : super(id, order, module, pos);
  static instantiate(Map<String, dynamic> json) =>
      PositionedModule.fromJson(json);
}
