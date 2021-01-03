part of components;

class ModuleAlert extends Module {
  ModuleAlert(int id, int order, String module) : super(id, order, module);
  static instantiate(Map<String, dynamic> json) => ModuleAlert.fromJson(json);

  factory ModuleAlert.fromJson(Map<String, dynamic> json) {
    return ModuleAlert(
        json['_meta']['id'], json['_meta']['order'], json['module']);
  }

  @override
  String get name {
    return "Notifications";
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json['config'] = {
      'effect': 'slide',
      'alert_effect': 'jelly',
      'display_time': 3500,
      'position':
          'center' // NOTE: *not* a positioned module, only: left, center, right
    };
    return json;
  }
}
