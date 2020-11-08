part of components;

class ModulePirSensor extends PositionedModule {
  final bool powerSavingNotification;
  final int sensorPin;
  final int powerSavingDelay;

  ModulePirSensor(id, module, position, _powerSavingNotification, _sensorPin,
      _powerSavingDelay)
      : powerSavingNotification = _powerSavingNotification,
        powerSavingDelay = _powerSavingDelay,
        sensorPin = _sensorPin,
        super(id, module, position);

  factory ModulePirSensor.fromJson(Map<String, dynamic> json) {
    bool powerSavingNotification = false;
    int sensorPin = 23;
    int powerSavingDelay = 300;

    if (json.containsKey("config")) {
      if (json["config"].containsKey("powerSavingDelay")) {
        powerSavingDelay = json["config"]["powerSavingDelay"];
      }
      if (json["config"].containsKey("sensorPin")) {
        sensorPin = json["config"]["sensorPin"];
      }
      if (json["config"].containsKey("powerSavingNotification")) {
        powerSavingNotification = json["config"]["powerSavingNotification"];
      }
    }


    return ModulePirSensor(
      json['_meta']['id'],
      json['module'],
      modulePositionFromString(json['position']),
      powerSavingNotification,
      sensorPin,
      powerSavingDelay,
    );
  }

  static instantiate(Map<String, dynamic> json) =>
      ModulePirSensor.fromJson(json);

  @override
  String toString() {
    return "{id:$id, module:$module, position:${position.toString()}, " +
        "powerSavingNotification: $powerSavingNotification, " +
        "sensorPin: $sensorPin, powerSavingDelay: $powerSavingDelay}";
  }
}
