part of components;

class ModuleWeather extends PositionedModule {
  ModuleWeather(int id, String module, ModulePosition pos)
      : super(id, module, pos);
  static instantiate(Map<String, dynamic> json) =>
      PositionedModule.fromJson(json);
}
