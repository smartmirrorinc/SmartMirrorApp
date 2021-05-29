import 'package:flutter/material.dart';
import 'package:smartmirror/statelessWidgets/ServerList.dart';
import 'package:flutter_config/flutter_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await FlutterConfig.loadEnvVariables();

  runApp(ServerListApp());
}
