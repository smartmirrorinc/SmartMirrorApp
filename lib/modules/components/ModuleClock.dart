part of components;

class ModuleClock extends PositionedModule {
  ModuleClock(int id, int order, String module, ModulePosition pos)
      : super(id, order, module, pos);
  static instantiate(Map<String, dynamic> json) =>
      PositionedModule.fromJson(json);
}
