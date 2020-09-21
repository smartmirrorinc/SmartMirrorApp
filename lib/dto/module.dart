class Module {
  final int id;
  final String module;

  Module({this.id, this.module});

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(id: json['_meta']['id'], module: json['module']);
  }
}

class PositionedModule extends Module {
  final String position;

  PositionedModule({this.position});

  factory PositionedModule.fromJson(Map<String, dynamic> json) {
    return PositionedModule(position: json['position']);
  }
}

class ModuleAlert extends Module {}

class ModuleClock extends PositionedModule {}

class ModulePirSensor extends PositionedModule {
  final bool powerSavingNotification;
  final int sensorPin;
  final int powerSavingDelay;

  ModulePirSensor(
      {this.powerSavingNotification, this.sensorPin, this.powerSavingDelay});

  factory ModulePirSensor.fromJson(Map<String, dynamic> json) {
    return ModulePirSensor(
      powerSavingNotification: json['config']['powerSavingNotification'],
      sensorPin: json['config']['sensorPin'],
      powerSavingDelay: json['config']['powerSavingDelay'],
    );
  }
}
