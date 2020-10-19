part of components;

class ModuleClock extends PositionedModule {
  ModuleClock(int id, String module, ModulePosition pos)
      : super(id, module, pos);
  static instantiate(Map<String, dynamic> json) =>
      PositionedModule.fromJson(json);
}
