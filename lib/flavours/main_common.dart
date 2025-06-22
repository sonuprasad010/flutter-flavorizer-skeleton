import 'package:flutter/material.dart';
import 'package:flutter_flavorizer_skeleton/flavours/config/flavour_config.dart';

import '../main.dart';

void mainCommon({
  required FlutterFavour flavour,
  required String baseUrl,
  required String name,
}) {
  FlavourConfig(flavour: flavour, name: name);
  runApp(MyApp());
}
