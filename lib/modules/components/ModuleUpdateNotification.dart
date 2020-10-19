part of components;

class ModuleUpdateNotification extends PositionedModule {
  ModuleUpdateNotification(int id, String module, ModulePosition pos)
      : super(id, module, pos);
  static instantiate(Map<String, dynamic> json) =>
      PositionedModule.fromJson(json);
}
