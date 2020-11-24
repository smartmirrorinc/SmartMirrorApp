part of components;

class ModuleUpdateNotification extends PositionedModule {
  ModuleUpdateNotification(int id, int order, String module, ModulePosition pos)
      : super(id, order, module, pos);
  static instantiate(Map<String, dynamic> json) =>
      PositionedModule.fromJson(json);
}
