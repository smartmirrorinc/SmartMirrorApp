part of components;

class ModuleCompliments extends PositionedModule {
  ModuleCompliments(int id, String module, ModulePosition pos)
      : super(id, module, pos);
  static instantiate(Map<String, dynamic> json) =>
      PositionedModule.fromJson(json);
}
