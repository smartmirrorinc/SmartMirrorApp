part of components;

// TODO: Support MMM-DarkSkyForecast instead of (or along with?) the "native"
// weatherforecast module? There's a fork dropping the deprecated DarkSky API in
// favor of OpenWeather One Call:
// https://github.com/gerjomarty/MMM-DarkSkyForecast

// TODO: support this configuration structure:
//   "position": "top_right",
//   "config": {
//       "lat": 12.345,
//       "lon": 12.345,
//       "appid": "<personal openweathermap.org API key>"
//   },
// Docs at: https://docs.magicmirror.builders/modules/weatherforecast.html
//
// Docs are not entirely clear on location vs locationID vs lat/lon -- but
// looking at the code, it seems that recent versions have implemented support
// for lat/lon in degrees. As of commit 86fb1b9, location resolution order:
// locationID, lat/lon, location, first calendar event location. A Google maps
// position selector would be awesome.
//
// Probably just link to API key creation for now, letting user copy-paste that
// into a text field?

class ModuleForecast extends PositionedModule {
  ModuleForecast(int id, int order, String module, ModulePosition pos)
      : super(id, order, module, pos);
  static instantiate(Map<String, dynamic> json) =>
      PositionedModule.fromJson(json);
}
