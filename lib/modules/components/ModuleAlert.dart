part of components;

class ModuleAlert extends Module {
  ModuleAlert(int id, String module) : super(id, module);
  static instantiate(Map<String, dynamic> json) => Module.fromJson(json);
}
