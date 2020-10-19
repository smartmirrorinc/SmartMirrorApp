part of components;

class ModuleIP extends PositionedModule {
  ModuleIP(int id, String module, ModulePosition pos) : super(id, module, pos);
  static instantiate(Map<String, dynamic> json) =>
      PositionedModule.fromJson(json);
}
