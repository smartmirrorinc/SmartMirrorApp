part of components;

class ModuleForecast extends PositionedModule {
  ModuleForecast(int id, String module, ModulePosition pos)
      : super(id, module, pos);
  static instantiate(Map<String, dynamic> json) =>
      PositionedModule.fromJson(json);
}
