import 'package:http/http.dart' as http;
import 'dart:convert';

Future<http.Response> get(String url) async {
  return http.get(url);
}

Future<http.Response> postJson(String url, dynamic data) {
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  var body = json.encode(data);
  return http.post(url, body: body, headers: headers);
}
