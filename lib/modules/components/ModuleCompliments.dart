part of components;

class ModuleCompliments extends PositionedModule {
  ModuleCompliments(int id, int order, String module, ModulePosition pos)
      : super(id, order, module, pos);
  static instantiate(Map<String, dynamic> json) =>
      PositionedModule.fromJson(json);
}
