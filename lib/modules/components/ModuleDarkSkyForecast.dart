part of components;

class ModuleDarkSkyForecast extends PositionedModule {
  double latitude, longitude;
  int hourlyForecastInterval;
  String apikey;
  GoogleMapController mapController;

  ModuleDarkSkyForecast(id, order, module, position, _latitude, _longitude,
      _hourlyForecastInterval, _apikey)
      : latitude = _latitude,
        longitude = _longitude,
        hourlyForecastInterval = _hourlyForecastInterval,
        apikey = _apikey,
        super(id, order, module, position);

  factory ModuleDarkSkyForecast.fromJson(Map<String, dynamic> json) {
    double latitude = 57.048820;
    double longitude = 9.921747;
    int hourlyForecastInterval = 6;
    String apikey = "";

    if (json.containsKey("config")) {
      if (json["config"].containsKey("latitude")) {
        latitude = json['config']['latitude'];
      }
      if (json["config"].containsKey("longitude")) {
        longitude = json['config']['longitude'];
      }
      if (json["config"].containsKey("hourlyForecastInterval")) {
        hourlyForecastInterval = json['config']['hourlyForecastInterval'];
      }
      if (json["config"].containsKey("apikey")) {
        apikey = json['config']['apikey'];
      }
    }

    return ModuleDarkSkyForecast(
        json['_meta']['id'],
        json['_meta']['order'],
        json['module'],
        modulePositionFromString(json['position']),
        latitude,
        longitude,
        hourlyForecastInterval,
        apikey);
  }

  static instantiate(Map<String, dynamic> json) =>
      ModuleDarkSkyForecast.fromJson(json);

  @override
  String get name {
    return "Advanced weather";
  }

  @override
  String toString() {
    return "{id:$id, order:$order, module:$module, position:${position.toString()}, " +
        "latitude: $latitude, " +
        "longitude: $longitude, " +
        "hourlyForecastInterval: $hourlyForecastInterval, " +
        "apikey: $apikey}";
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // TODO: this does not belong here
  String capString(String x) {
    if (x.length < 13) {
      return x;
    } else {
      return x.substring(0, 10) + "...";
    }
  }

  @override
  void buildWidgets(BuildContext context, Function refresh) {
    super.buildWidgets(context, refresh);

    // API key input field
    widgets.add(Card(
        child: Column(children: [
      ListTile(
          leading: Icon(Icons.vpn_key),
          title: TextField(
            onChanged: (String value) {
              apikey = value;
            },
            style: TextStyle(fontSize: 12),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "API key",
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                helperText: "Old value: " + capString(apikey)),
          )),
      ListTile(
        leading: Icon(Icons.help),
        title: Text("Where do I find my API key?"),
        onTap: () async {
          await launch("https://home.openweathermap.org/api_keys");
        },
      )
    ])));

    // Location picker
    widgets.add(Card(
      child: Column(
        children: [
          // Header
          ListTile(
              leading: Icon(Icons.my_location),
              title: Text("Location",
                  style: TextStyle(fontWeight: FontWeight.bold))),

          // Map showing current position (zoom only, no scrolling)
          SizedBox(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                mapToolbarEnabled: true,
                liteModeEnabled: false,
                scrollGesturesEnabled: false,
                initialCameraPosition: CameraPosition(
                    target: LatLng(latitude, longitude), zoom: 10),
                markers: Set<Marker>.of([
                  Marker(
                      markerId: MarkerId("Current"),
                      position: LatLng(latitude, longitude))
                ]),
              ),
              height: 200),

          // Button to open location picker
          RaisedButton(
            onPressed: () async {
              LocationResult result = await showLocationPicker(context,
                  "PUT_GOOGLE_MAPS_API_KEY_HERE", // TODO: app-specific key
                  initialCenter: LatLng(56.224288, 11.195565), // ~mid Denmark
                  automaticallyAnimateToCurrentLocation: false,
                  myLocationButtonEnabled: true,
                  layersButtonEnabled: false,
                  // accuracy must be 'best' or getting user position does not
                  // work, might be related to
                  // https://github.com/Baseflow/flutter-geolocator/issues/117 ?
                  desiredAccuracy: LocationAccuracy.best,
                  initialZoom: 6);

              latitude = result.latLng.latitude;
              longitude = result.latLng.longitude;

              // move "current position" map to new coords
              mapController.moveCamera(
                CameraUpdate.newLatLng(LatLng(latitude, longitude)),
              );
              refresh(this);
            },
            child: Text('Pick location'),
          ),
        ],
      ),
    ));
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json['config'] = {
      'apikey': apikey,
      'forecastLayout': "table",
      'hourlyForecastInterval': hourlyForecastInterval,
      'label_timeFormat': "HH:mm",
      "latitude": latitude,
      "longitude": longitude
    };
    return json;
  }
}
