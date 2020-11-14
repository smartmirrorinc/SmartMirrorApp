part of components;

// TODO: See comments in ModuleForecast. For whatever reason, this module does
// not yet support lat/lon for location, only location, locationID and position
// from first calendar event location... If this module should be supported,
// it'd probably be best to add lat/lon functionality to currentweather (should
// be able to reuse from forecast, is same API) and try to get that upstream.
//
// docs:
// https://docs.magicmirror.builders/modules/currentweather.html

class ModuleWeather extends PositionedModule {
  ModuleWeather(int id, String module, ModulePosition pos)
      : super(id, module, pos);
  static instantiate(Map<String, dynamic> json) =>
      PositionedModule.fromJson(json);
}
