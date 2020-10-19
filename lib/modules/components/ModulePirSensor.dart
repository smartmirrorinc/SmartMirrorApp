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
    return ModulePirSensor(
      json['_meta']['id'],
      json['module'],
      modulePositionFromString(json['position']),
      json['config']['powerSavingNotification'],
      json['config']['sensorPin'],
      json['config']['powerSavingDelay'],
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
