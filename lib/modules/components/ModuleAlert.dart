part of components;

class ModuleAlert extends Module {
  ModuleAlert(int id, int order, String module) : super(id, order, module);
  static instantiate(Map<String, dynamic> json) => Module.fromJson(json);
}
